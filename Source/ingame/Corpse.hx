import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.PixelSnapping;
import openfl.Assets;

class Corpse extends GameObject
{
	public function new(tile : Tile)
	{
		super(tile);

		var img = new Bitmap(Assets.getBitmapData(
			"assets/corpse.png"),
			PixelSnapping.ALWAYS);
		img.x = -img.width*0.5;
		img.y = -img.height*0.5;
		addChild(img);
	}
}