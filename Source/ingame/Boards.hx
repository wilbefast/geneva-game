class Boards extends GameObject
{
	public function new(tile : Tile)
	{
		super(tile);

		graphics.beginFill(0x808000);
		graphics.drawRect(-8, -8, 16, 16);
		graphics.endFill();
	}
}