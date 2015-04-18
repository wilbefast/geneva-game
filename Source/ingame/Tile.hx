import openfl.display.Sprite;

class Tile extends Sprite
{
	private var gridX(default, null) : Int;
	private var gridY(default, null) : Int;

	private var _type : TileType;

	public var north : Tile;
	public var south : Tile;
	public var east : Tile;
	public var west : Tile;

	public function new(gridX : Int, gridY : Int, type : TileType)
	{
		super();

		this.gridX = gridX;
		this.gridY = gridY;

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

	public function getNeighbour(dx : Int, dy : Int)
	{
		if(dy < 0)
			return north;
		else if(dy > 0)
			return south;
		else if(dx < 0)
			return west;
		else if (dx > 0)
			return east;

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

	public function getType() : TileType
	{
		return _type;
	}
}