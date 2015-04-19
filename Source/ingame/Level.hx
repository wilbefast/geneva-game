import openfl.display.Sprite;
import openfl.display.BitmapData;
import openfl.Assets;
import motion.Actuate;

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
			case 0xff8080: WoundedStart;
			case 0x808000: BoardsStart;
			default:
				throw "Invalid colour " + colour +  " in level image";
		}
	}

	public function new(levelNumber : Int)
	{
		super();

		// load image
		var levelNumberStr = Std.string(levelNumber + 1);
		while(levelNumberStr.length < 2)
			levelNumberStr = '0' + levelNumberStr;
		var bitmap = Assets.getBitmapData (
			"assets/level" + levelNumberStr + ".png");
		if(bitmap == null)
			throw "No file exists for level '" + levelNumberStr + "'";

		// Dimensions
		_width = bitmap.width;
		_height = bitmap.height;

		// Layers
		_tileLayer = new Sprite();
		addChild(_tileLayer);
		_avatarLayer = new Sprite();
		addChild(_avatarLayer);
		_gameObjectsLayer = new Sprite();
		addChild(_gameObjectsLayer);
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
					g.beginFill(0x00ff00);
					g.drawRect(-16, -16, 32, 32);
					g.endFill();
					gasSprite.alpha = 0.0;
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
					obj.x = tile.x;
					obj.y = tile.y;
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

					case Floor | Hole | Wall | Exit | Flooded:
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

				_tiles[gridY*_width + gridX].setNeighbours(n, s, e, w);
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

	public function update(dt : Float)
	{
		if(_step_in_progress)
		{
			// Wait till end of step ...
		}
		else if(_step_queue == 0)
		{
			// Move avatar ?
			var d = Input.getDirection();
			var dx : Int = d.x < 0 ? Math.floor(d.x) : Math.ceil(d.x);
			var dy : Int = d.y < 0 ? Math.floor(d.y) : Math.ceil(d.y);
			if(dx != 0 || dy != 0)
				_step_queue = _avatar.tryMove(
					_avatar.getTile().getNeighbour(dx, dy));
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
			
	}}