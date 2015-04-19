import openfl.display.Sprite;
import openfl.display.BitmapData;
import openfl.Assets;

class Level extends Sprite
{
	private var _tiles : Array<Tile>;

	private var _width : Int = 0;
	private var _height : Int = 0;

	private var _avatar : Avatar;
	private var _avatarLayer : Sprite;

	private var _cannisters : Array<Cannister>;
	private var _cannistersLayer : Sprite;

	private var _gasLayer : Sprite;

	private static function _getColourType(colour : UInt) : TileType
	{
		return switch(colour)
		{
			case 0x000000: Wall;
			case 0xffffff: Floor;
			case 0x00ff00: CannisterStart;
			case 0x0000ff: PlayerStart;
			case 0x808080: Hole;
			case 0xffff00: Exit;
			default:
				throw "Invalid colour " + colour +  " in level image";
		}
	}

	public function new(levelNumber : Int)
	{
		super();

		// load image
		var bitmap = Assets.getBitmapData ("assets/level01.png");

		// Dimensions
		_width = bitmap.width;
		_height = bitmap.height;

		// Layers
		_avatarLayer = new Sprite();
		addChild(_avatarLayer);
		_cannistersLayer = new Sprite();
		addChild(_cannistersLayer);
		_gasLayer = new Sprite();
		addChild(_gasLayer);

		// Objects holders
		_cannisters = new Array<Cannister>();

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
					case PlayerStart | CannisterStart:
						 new Tile(gridX, gridY, Floor, gasSprite);
					case Floor | Hole | Wall | Exit:
						new Tile(gridX, gridY, type, gasSprite);
				}
				_tiles[i] = t;
				addChild(t);
				t.x = gridX*32;
				t.y = gridY*32;

				// Position gas
				if(gasSprite != null)
				{
					gasSprite.x = t.x;
					gasSprite.y = t.y;
				}

				// Contained object
				switch(type)
				{
					case PlayerStart:
						_avatar = new Avatar(t);
						_avatarLayer.addChild(_avatar);
						_avatar.x = t.x;
						_avatar.y = t.y;

					case CannisterStart:
						var c = new Cannister(t);
						_cannisters.push(c);
						_cannistersLayer.addChild(c);
						c.x = t.x;
						c.y = t.y;

					case Floor | Hole | Wall | Exit:
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
	}

	public function getTile(gridX : Int, gridY : Int) : Tile
	{
		if(gridX < 0 || gridX >= _width || gridY < 0 || gridY >= _height)
			throw "Invalid position passed to Level::getTile";

		return _tiles[gridY*_width + gridX];
	}

	public function update(dt : Float)
	{
		// Move avatar
		var avatarMoved = false;
		var d = Input.getDirection();
		var dx : Int = d.x < 0 ? Math.floor(d.x) : Math.ceil(d.x);
		var dy : Int = d.y < 0 ? Math.floor(d.y) : Math.ceil(d.y);
		if(dx != 0 || dy != 0)
			avatarMoved = _avatar.tryMove(
				_avatar.getTile().getNeighbour(dx, dy));

		// Update everything only if the avatar moved
		if(avatarMoved)
		{
			for(c in _cannisters)
				c.step();

			for(t in _tiles)
				t.step();
		}
	}
}