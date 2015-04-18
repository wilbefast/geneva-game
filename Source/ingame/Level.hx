import openfl.display.Sprite;
import openfl.display.BitmapData;
import openfl.Assets;

class Level extends Sprite
{
	private var _tiles : Array<Tile>;

	private var _width : Int = 0;
	private var _height : Int = 0;

	private var _avatar : Avatar;

	private static function _getColourType(colour : UInt) : TileType
	{
		return switch(colour)
		{
			case 0x000000: Wall;
			case 0xffffff: Floor;
			case 0x00ff00: Cannister;
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

		// Objects to spawn

		// Tiles
		_tiles = new Array<Tile>();
		for(gridX in 0 ... _width)
		{
			for(gridY in 0 ... _height)
			{
				var type = _getColourType(bitmap.getPixel(gridX, gridY));
				var i = gridY*_width + gridX;

				// Tile
				var t = switch(type)
				{
					case PlayerStart | Cannister:
						 new Tile(gridX, gridY, Floor);
					case Floor | Hole | Wall | Exit:
						new Tile(gridX, gridY, type);
				}
				_tiles[i] = t;
				addChild(t);
				Position.relative(t, 
					0.1 + 0.8 * gridX / (_width - 1.0), 
					0.1 + 0.8 * gridY / (_height - 1.0));

				// Contained object
				switch(type)
				{
					case PlayerStart:
						_avatar = new Avatar(t);
						addChild(_avatar);
						_avatar.x = t.x;
						_avatar.y = t.y;

					case Cannister:
						// TODO

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
				var t = _tiles[gridY*_width + gridX];

				if(gridY >= 1)
					t.north = getTile(gridX, gridY - 1);
				if(gridY < _height - 1)
					t.south = getTile(gridX, gridY + 1);
				if(gridX >= 1)
					t.west = getTile(gridX - 1, gridY);
				if(gridX < _height - 1)
					t.east = getTile(gridX + 1, gridY);
			}
		}
	}

	public function getAvatar()
	{
		return _avatar;
	}

	public function getTile(gridX : Int, gridY : Int) : Tile
	{
		if(gridX < 0 || gridX >= _width || gridY < 0 || gridY >= _height)
			throw "Invalid position passed to Level::getTile";

		return _tiles[gridY*_width + gridX];
	}
}