package ;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;
import motion.Actuate;

class Main extends Sprite 
{
	public function new () 
	{
		super ();

		// Set up the input manager
		Input.listen();

		// Set up the scene manager
		var scenes = SceneManager.get();
		scenes.set("Title", new TitleScene());
		scenes.set("InGame", new InGameScene());
		scenes.set("Fail", new FailScene());
		addChild(scenes);

		// Add the rain
		var rain_source = [ 
			Assets.getBitmapData("assets/rain1.png"),
			Assets.getBitmapData("assets/rain2.png"),
			Assets.getBitmapData("assets/rain3.png")];
		var rain = new Bitmap(rain_source[0]);
		addChild(rain);
		var _rain_i = 0;
		function _cycleRain()
		{
			Actuate.timer(0.1).onComplete(function() {
				_rain_i = (_rain_i + 1) % 3;
				rain.bitmapData = rain_source[_rain_i];
				_cycleRain();
			});
		}
		_cycleRain();


		rain.bitmapData = rain_source[1];

		// Add the vignette
		var vignette = new Bitmap(
			Assets.getBitmapData("assets/vignette.png"));
		addChild(vignette);

	}
}