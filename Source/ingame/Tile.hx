import openfl.display.Sprite;

class Tile extends Sprite
{
	private var gridX(default, null) : Int;
	private var gridY(default, null) : Int;

	public var north : Tile;
	public var south : Tile;
	public var east : Tile;
	public var west : Tile;

	public function new(gridX : Int, gridY : Int)
	{
		super();

		this.gridX = gridX;
		this.gridY = gridY;

		graphics.beginFill(0xffffff);
		graphics.drawRect(0, 0, 1, 1);
		graphics.endFill();
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
}