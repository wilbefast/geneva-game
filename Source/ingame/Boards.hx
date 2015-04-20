import openfl.display.Sprite;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.PixelSnapping;
import openfl.Assets;

class Boards extends GameObject
{
	public function new(tile : Tile)
	{
		super(tile);

		var img = new Bitmap(Assets.getBitmapData(
			"assets/boards.png"),
			PixelSnapping.ALWAYS);
		if(Std.random(2) == 0)
			img.scaleX = -1;
		else
			img.scaleX = 1;
		if(Std.random(2) == 0)
			img.scaleY = -1;
		else
			img.scaleY = 1;
		img.x = -img.width*0.5;
		img.y = -img.height*0.5;
		addChild(img);
	}
}