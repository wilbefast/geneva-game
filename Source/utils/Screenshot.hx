import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.utils.ByteArray;
import openfl.display.PNGEncoderOptions;
import sys.io.FileOutput;

class Screenshot
{
	private static var _next_file : Int = 0;

	public static function capture(object : DisplayObject)
	{
		var raw : BitmapData = new BitmapData(
			Std.int(object.width), Std.int(object.height), false, 0x000000);
		raw.draw(object);

		var filename = Std.string(_next_file++);
		while(filename.length < 12)
			filename = "0" + filename;

		var png : ByteArray = raw.encode(raw.rect, new PNGEncoderOptions());
		var fo:FileOutput = sys.io.File.write(filename + ".png", true);
		fo.writeString(png.toString());
		fo.close();
	}
}