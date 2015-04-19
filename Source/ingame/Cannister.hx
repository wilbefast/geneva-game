class Cannister extends GameObject
{
	public function new(tile : Tile)
	{
		super(tile);

		graphics.beginFill(0x00ff00);
		graphics.drawRect(-6, -6, 12, 12);
		graphics.endFill();
	}
	
	public override function step()
	{
		_tile.addGas(0.6, 0);
	}
}