import openfl.display.Sprite;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.PixelSnapping;
import openfl.Assets;
import motion.Actuate;
import openfl.media.Sound;

class Level extends Sprite
{
	private var _tiles : Array<Tile>;

	private var _width : Int = 0;
	private var _height : Int = 0;

	private var _tileLayer : Sprite;

	private var _avatar : Avatar;
	private var _avatarLayer : Sprite;

	private var _gameObjects : List<GameObject>;
	private var _gameObjectsLayer : Sprite;

	private var _gasLayer : Sprite;

	private var _rain : Bitmap;

	// --------------------------------------------------------------------------
	// INIT
	// --------------------------------------------------------------------------

	private static function _getColourType(colour : UInt) : TileType
	{
		return switch(colour)
		{
			case 0x000000: Wall;
			case 0xffffff: Floor;
			case 0xff0000: CorpseStart;
			case 0x00ff00: CannisterStart;
			case 0x0000ff: PlayerStart;
			case 0x808080: Hole;
			case 0xffff00: Exit;
			case 0x00ffff: Flooded;
			case 0xff8080: WoundedStart;
			case 0x808000: BoardsStart;
			case x if (x < 0x0000ff):
				return Door(x);
			case x if (x < 0x00ff00):
				return DoorSwitch(x >> 8);
			default:
				throw "Invalid colour " + colour +  " in level image";
		}
	}

	public static function levelFilename(levelNumber : Int) : String
	{
		var levelNumberStr = Std.string(levelNumber + 1);
		while(levelNumberStr.length < 2)
			levelNumberStr = '0' + levelNumberStr;
		return ("assets/level" + levelNumberStr + ".png");
	}

	public function new(levelNumber : Int)
	{
		super();

		// reset circuits
		Circuits.get().reset();

		// load image
		var levelNumberStr = levelFilename(levelNumber);
		var bitmap = Assets.getBitmapData(levelNumberStr);
		if(bitmap == null)
			throw "No file exists for level '" + levelNumberStr + "'";

		// Dimensions
		_width = bitmap.width;
		_height = bitmap.height;

		// Layers
		_tileLayer = new Sprite();
		addChild(_tileLayer);
		_gameObjectsLayer = new Sprite();
		addChild(_gameObjectsLayer);
		_avatarLayer = new Sprite();
		addChild(_avatarLayer);
		_gasLayer = new Sprite();
		addChild(_gasLayer);

		// Objects holders
		_gameObjects = new List<GameObject>();

		// Tiles
		_tiles = new Array<Tile>();
		for(gridX in 0 ... _width)
		{
			for(gridY in 0 ... _height)
			{
				var type = _getColourType(bitmap.getPixel(gridX, gridY));
				var i = gridY*_width + gridX;

				// Gas sprite
				var gasSprite : Sprite = null;
				if(type != Wall)
				{
					gasSprite = new Sprite();
					var g = gasSprite.graphics;
					_gasLayer.addChild(gasSprite);
				}

				// Tile
				var t = switch(type)
				{
					case PlayerStart | 
						CannisterStart | 
						WoundedStart |
						BoardsStart |
						CorpseStart:
						 new Tile(gridX, gridY, Floor, gasSprite);
					case Floor | 
						Hole | 
						Wall | 
						Exit | 
						DoorSwitch(_) |
						Door(_) |
						Flooded:
							new Tile(gridX, gridY, type, gasSprite);
				}
				if(t == null)
					throw "Attempting to add null tile to level";
				_tiles[i] = t;
				_tileLayer.addChild(t);
				t.x = gridX*32;
				t.y = gridY*32;

				// Position gas
				if(gasSprite != null)
				{
					gasSprite.x = t.x;
					gasSprite.y = t.y;
				}

				// Contained objects
				function _addObject(obj : GameObject, tile : Tile) {
					_gameObjects.push(obj);
					_gameObjectsLayer.addChild(obj);
					tile.putObject(obj);
				}
				switch(type)
				{
					case PlayerStart: 
						_avatar = new Avatar(t);
						_avatarLayer.addChild(_avatar);
						_avatar.x = t.x;
						_avatar.y = t.y;
					case CannisterStart: _addObject(new Cannister(t), t);
					case CorpseStart: _addObject(new Corpse(t), t);
					case WoundedStart: _addObject(new Wounded(t), t);
					case BoardsStart: _addObject(new Boards(t), t);

					case Door(c):
						Circuits.get().registerDoor(t, c);

					case DoorSwitch(c):
						Circuits.get().registerSwitch(t, c);

					case _:
						// do nothing
				}
			}
		}

		// Tile neighbours
		for(gridX in 0 ... _width)
		{
			for(gridY in 0 ... _height)
			{
				var n : Tile = null;
				var s : Tile = null;
				var e : Tile = null;
				var w : Tile = null;

				if(gridY >= 1)
					n = getTile(gridX, gridY - 1);
				if(gridY < _height - 1)
					s = getTile(gridX, gridY + 1);
				if(gridX < _height - 1)
					e = getTile(gridX + 1, gridY);
				if(gridX >= 1)
					w = getTile(gridX - 1, gridY);

				var t = _tiles[gridY*_width + gridX];
				t.setNeighbours(n, s, e, w);
			
				// Tiles based on neighbourhood
				if(t.getType() == Wall 
				&& s != null 
				&& s.getType() != Wall
				&& s.getType() != Exit)
				{
					var img = new Bitmap(Assets.getBitmapData(
					"assets/wall.png"),
					PixelSnapping.ALWAYS);
					img.x = t.x - img.width*0.5;
					img.y = t.y - img.height*0.5;

					_gameObjectsLayer.addChild(img);
				}
			}
		}

		// There should be an avatar
		if(_avatar == null)
			throw "Level file contains no avatar start position";
	}

	// --------------------------------------------------------------------------
	// QUERY
	// --------------------------------------------------------------------------


	public function getTile(gridX : Int, gridY : Int) : Tile
	{
		if(gridX < 0 || gridX >= _width || gridY < 0 || gridY >= _height)
			throw "Invalid position passed to Level::getTile";

		return _tiles[gridY*_width + gridX];
	}

	// --------------------------------------------------------------------------
	// STEP
	// --------------------------------------------------------------------------

	public static inline var STEP_DURATION : Float = 0.15;

	private var _step_queue : Int = 0;
	private var _step_in_progress : Bool = false;

	public function isStepping() : Bool
	{
		return (_step_in_progress || (_step_queue > 0));
	}

	public function update(dt : Float)
	{
		if(_step_in_progress)
		{
			// Wait till end of step ...
		}
		else if(_step_queue == 0)
		{
			// Dead avatar ?
			if(_avatar.isDead())
				_step_queue++;
			else
			{
				// Interact avatar ?
				if(Input.desiredInteraction())
					_step_queue = _avatar.tryInteract();

				if(_step_queue <= 0)
				{
					// Move avatar ?
					var d = Input.getDirection();
					var dx : Int = d.x < 0 ? Math.floor(d.x) : Math.ceil(d.x);
					var dy : Int = d.y < 0 ? Math.floor(d.y) : Math.ceil(d.y);
					if(dx != 0 || dy != 0)
						_step_queue = _avatar.tryMove(
							_avatar.getTile().getNeighbour(dx, dy));

					if(_step_queue > 0)
						Audio.get().playSound("footstep");
				}
				else if(_step_queue <= 1)
					Audio.get().playSound("footstep");
				else
					Audio.get().playSound("interact");

			}
		}
		else
		{
			// Update everything else
			for(c in _gameObjects)
				c.step();

			for(t in _tiles)
				t.step();

			// Wait for the step to finish
			_step_queue--;
			_step_in_progress = true;
			Actuate.timer(STEP_DURATION)
			.onComplete(function() {
				_step_in_progress = false;
			});
		}
	}


	// --------------------------------------------------------------------------
	// BATCH
	// --------------------------------------------------------------------------

	public function forEach(f : Tile -> Int -> Int -> Bool) : Bool
	{
		for(gridX in 0 ... _width)
		{
			for(gridY in 0 ... _height)
			{
				if(!f(_tiles[gridY*_width + gridX], gridX, gridY))
					return false;
			}
		}
		return true;
	}
}