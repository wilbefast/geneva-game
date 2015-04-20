import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.Assets;
import motion.easing.Quad;
import motion.Actuate;

class Tile extends Sprite
{
	private var gridX(default, null) : Int;
	private var gridY(default, null) : Int;

	private var _type : TileType;

	private var _north : Tile;
	private var _south : Tile;
	private var _east : Tile;
	private var _west : Tile;
	private var _neighbours : Map<String, Tile>;

	// --------------------------------------------------------------------------
	// CREATION
	// --------------------------------------------------------------------------

	public function new(gridX : Int, gridY : Int, 
		type : TileType, gasSprite : Sprite = null)
	{
		super();

		this.gridX = gridX;
		this.gridY = gridY;

		_gasSprite = gasSprite;
		if(_gasSprite != null)
		{
			_gasBitmap = new Bitmap(
				Assets.getBitmapData("assets/gas_small.png"),
				PixelSnapping.ALWAYS);
			_gasSprite.addChild(_gasBitmap);
			_gasSprite.alpha = 0;

			_gas_bounce_t = Math.random();
			
		}

		// Graphics depending on tile type
		_type = type;
		switch(type)
		{
			case (DoorSwitch(_) | Door(_) | Floor):
				var img = new Bitmap(Assets.getBitmapData(
					"assets/mud" + Std.string(Std.random(6) + 1) + ".png"),
					PixelSnapping.ALWAYS);
				img.x = -img.width*0.5;
				img.y = -img.height*0.5;
				addChild(img);

			case Flooded:
				var img = new Bitmap(Assets.getBitmapData(
					"assets/flooded.png"),
					PixelSnapping.ALWAYS);
				img.x = -img.width*0.5;
				img.y = -img.height*0.5;
				addChild(img);

			case Wall:
				// Do nothing

			case Hole:
				var img = new Bitmap(Assets.getBitmapData(
					"assets/hole.png"), PixelSnapping.ALWAYS);
				img.x = -img.width*0.5;
				img.y = -img.height*0.5;
				addChild(img);

			case Exit:
				var img = new Bitmap(Assets.getBitmapData(
					"assets/exit.png"), PixelSnapping.ALWAYS);
				img.x = -img.width*0.5;
				img.y = -img.height*0.5;
				addChild(img);


			case _:
				throw "Invalid Tile type " + _type;
		}
	}

	public function setNeighbours(n : Tile, s : Tile, e : Tile, w : Tile)
	{
		_neighbours = new Map<String, Tile>();

		if(n != null)
		{
			_north = n; 
			if(n._south != null && n._south != this)
				throw "Incosistency in North neighbour detected";
			_neighbours["north"] = n;
		}
		
		if(s != null)
		{
			_south = s; 
			if(s._north != null && s._north != this)
				throw "Incosistency in South neighbour detected";
			_neighbours["south"] = s;
		}
		
		if(e != null)
		{
			_east = e; 
			if(e._west != null && e._west != this)
				throw "Incosistency in East neighbour detected";
			_neighbours["east"] = e;
		}
		
		if(w != null)
		{
			_west = w; 
			if(w._east != null && w._east != this)
				throw "Incosistency in West neighbour detected";
			_neighbours["west"] = w;
		}
	}

	// --------------------------------------------------------------------------
	// QUERY
	// --------------------------------------------------------------------------

	public function getNorth() { return _north; } 
	public function getSouth() { return _south; } 
	public function getEast() { return _east; } 
	public function getWest() { return _west; } 

	public function getNeighbour(dx : Int, dy : Int)
	{
		if(dy < 0)
			return _north;
		else if(dy > 0)
			return _south;
		else if(dx < 0)
			return _west;
		else if (dx > 0)
			return _east;

		throw "Invalid parameters 0, 0 passed to Tile::getNeighbour";
	}

	public function isWalkable() : Bool
	{
		return switch(_type)
		{
			case Wall | Hole: 
				false;
			case Door(circuit): 
				Circuits.get().isOn(circuit);
			case _: 
				true;
		}
	}

	public function moveCost() : Float
	{
		if(_contents != null)
		{
			if(Std.is(_contents, Corpse))
				return 2.0;
			if(Std.is(_contents, Boards))
				return 0.5;
		}

		return switch(_type)
		{
			case Flooded: return 3.0;
			case _: 1.0;
		}
	}

	public function isGasable()
	{
		return switch(_type)
		{
			case Wall : 
				false;
			case Door(circuit): 
				Circuits.get().isOn(circuit);
			case _: 
				true;
		}
	}

	public function getType() : TileType
	{
		return _type;
	}

	// --------------------------------------------------------------------------
	// CONTENTS
	// --------------------------------------------------------------------------

	private var _contents : GameObject = null;

	public function putObject(obj : GameObject) : GameObject
	{
		var prevContents = _contents;
		_contents = obj;
		obj.x = x;
		obj.y = y;
		return prevContents;
	}

	public function pickObject() : GameObject
	{
		var prevContents = _contents;
		_contents = null;
		return prevContents;
	}

	// --------------------------------------------------------------------------
	// GAS
	// --------------------------------------------------------------------------

	private var _gas : Float = 0.0;
	private var _gasSurplus : Float = 0.0;
	private var _gasDistance : Int = 0x3FFFFFF;

	private var _gasSprite : Sprite = null;
	private var _gasBitmap : Bitmap = null;
	private var _gas_bounce_t : Float = 0.0;

	public function getGas() : Float
	{
		return _gas;
	}

	public function step()
	{
		addGas(0.0, _gasDistance);

		// Bounce
		if(_gas > 0)
		{
			var base = _gas_bounce_t;
			Actuate.update(function(t : Float) {

				_gas_bounce_t = base + 0.1*t*Level.STEP_DURATION;
				if(_gas_bounce_t > 1)
					_gas_bounce_t -= 1;

				_gasSprite.scaleY = 
					1 + 0.2*Math.cos(2 * _gas_bounce_t * Math.PI);
				_gasSprite.scaleX = 
					1 + 0.2*Math.cos(2 * _gas_bounce_t * Math.PI);
			}, Level.STEP_DURATION, [0], [1]);
		}
	}

	public function addGas(amount : Float, distance : Int)
	{
		if(distance <= _gasDistance)
			_gasDistance = distance;

		_gas += amount + _gasSurplus;
		_gasSurplus = 0.0;

		var surplus = _gas - 1.0;
		if(surplus > 0)
		{
			_gas = 1.0;

			var gasableNeighbours : List<Tile> = new List<Tile>();
			for(t in _neighbours)
				if(t.isGasable() && t._gasDistance >= distance)
					gasableNeighbours.push(t);

			if(!gasableNeighbours.isEmpty())
			{
				var offer_each = surplus / gasableNeighbours.length;
				surplus = 0;
				for(t in gasableNeighbours)
					t.addGas(offer_each, distance + 1);
			}
			else
				_gasSurplus = Math.min(1, surplus);
		}

		
		// Adjust gas visibility
		if(_gasSprite != null)
		{
			if(_gas <= 0)
				_gasSprite.alpha = 0;
			else 
			{
				_gasSprite.alpha = 1;
				if(_gas < 0.5)
				_gasBitmap.bitmapData = Assets.getBitmapData(
					"assets/gas_small.png");
				else if(_gas < 0.75)
					_gasBitmap.bitmapData = Assets.getBitmapData(
						"assets/gas_medium.png");
				else
					_gasBitmap.bitmapData = Assets.getBitmapData(
						"assets/gas_large.png");	

				_gasBitmap.x = -_gasBitmap.width*0.5;
				_gasBitmap.y = -_gasBitmap.height*0.5;
			}	
		}
	}
}