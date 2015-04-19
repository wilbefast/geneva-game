import openfl.display.Sprite;

class GameObject extends Sprite
{
	private var _tile : Tile;

	public function new(tile : Tile)
	{
		super();

		if(tile == null)
			throw "GameObject tile cannot be null on initialisation";
		_tile = tile;
	}

	public function getTile() : Tile
	{
		return _tile;
	}

	public function step()
	{
		// Override me 
	}
}