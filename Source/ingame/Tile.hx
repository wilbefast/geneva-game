import openfl.display.Sprite;

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

		_type = type;
		switch(_type)
		{
			case Floor:

			case Wall:
				graphics.beginFill(0xffffff);
				graphics.drawRect(-16, -16, 32, 32);
				graphics.endFill();

			case Hole:
				graphics.beginFill(0x808080);
				graphics.drawRect(-10, -10, 20, 20);
				graphics.endFill();

			case Exit:
				graphics.beginFill(0xffff00);
				graphics.drawRect(-10, -10, 20, 20);
				graphics.endFill();		

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

	public function isWalkable()
	{
		return switch(_type)
		{
			case Wall | Hole: false;
			case Floor | Exit: true;
			case _:
				throw "Invalid Tile type " + _type;
		}
	}

	public function isGasable()
	{
		return switch(_type)
		{
			case Wall : false;
			case Floor | Exit | Hole : true;
			case _:
				throw "Invalid Tile type " + _type;
		}
	}

	public function getType() : TileType
	{
		return _type;
	}


	// --------------------------------------------------------------------------
	// GAS
	// --------------------------------------------------------------------------

	private var _gas : Float = 0.0;
	private var _gasSurplus : Float = 0.0;
	private var _gasDistance : Int = 0x3FFFFFF;

	private var _gasSprite : Sprite = null;

	public function step()
	{
		addGas(0.0, _gasDistance);
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
				_gasSurplus = surplus;
		}

		
		// Adjust gas visibility
		if(_gasSprite != null)
			_gasSprite.alpha = _gas;
	}
}