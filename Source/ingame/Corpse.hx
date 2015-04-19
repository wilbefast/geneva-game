class Corpse extends GameObject
{
	public function new(tile : Tile)
	{
		super(tile);

		graphics.beginFill(0xff0000);
		graphics.drawRect(-6, -6, 12, 12);
		graphics.endFill();
	}
}