import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.PixelSnapping;
import openfl.Assets;

class Cannister extends GameObject
{
	public function new(tile : Tile)
	{
		super(tile);

		var img = new Bitmap(Assets.getBitmapData(
			"assets/cannister.png"),
			PixelSnapping.ALWAYS);
		if(Std.random(2) == 0)
			img.scaleX = -1;
		else
			img.scaleX = 1;
		img.x = -img.width*0.5;
		img.y = -img.height*0.75;
		addChild(img);
	}
	
	public override function step()
	{
		_tile.addGas(0.6, 0);
	}
}