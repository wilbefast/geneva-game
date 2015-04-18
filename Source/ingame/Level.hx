import openfl.display.Sprite;

class Level extends Sprite
{
	private var _tiles : Array<Tile>;

	private var _width : Int = 0;
	private var _height : Int = 0;

	private var _avatar : Avatar;

	public function new(width : Int, height : Int)
	{
		super();

		// Dimensions
		_width = width;
		_height = height;

		// Tiles
		_tiles = new Array<Tile>();
		for(gridX in 0 ... _width)
		{
			for(gridY in 0 ... _height)
			{
				var t = new Tile(gridX, gridY);
				_tiles[gridY*_width + gridX] = t;
				addChild(t);
				Position.relative(t, 
					0.1 + 0.8 * gridX / (_width - 1.0), 
					0.1 + 0.8 * gridY / (_height - 1.0));
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

		// Avatar
		var centre = getTile(Math.floor(_width / 2), Math.floor(_width / 2));
		_avatar = new Avatar(centre);
		addChild(_avatar);
		_avatar.x = centre.x;
		_avatar.y = centre.y;
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