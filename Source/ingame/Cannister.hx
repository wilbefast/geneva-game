import openfl.display.Sprite;

class Cannister extends Sprite
{
	private var _tile : Tile;

	public function new(tile : Tile)
	{
		super();

		_tile = tile;

		graphics.beginFill(0x00ff00);
		graphics.drawRect(-6, -6, 12, 12);
		graphics.endFill();
	}

	public function getTile() : Tile
	{
		return _tile;
	}

	public function step()
	{
		_tile.addGas(0.6, 0);
	}
}