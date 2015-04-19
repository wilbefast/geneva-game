class Wounded extends GameObject
{
	public function new(tile : Tile)
	{
		super(tile);

		graphics.beginFill(0xff8080);
		graphics.drawRect(-6, -6, 12, 12);
		graphics.endFill();
	}
}