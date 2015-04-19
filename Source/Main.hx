package ;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.PixelSnapping;
import openfl.Assets;
import motion.Actuate;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.events.Event;
import openfl.Lib;

class Main extends Sprite 
{
	private var _rain_channel : SoundChannel;
	private var _rain : Sound;

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

		// Add the vignette
		var vignette = new Bitmap(
			Assets.getBitmapData("assets/vignette.png"),
			PixelSnapping.ALWAYS);
		addChild(vignette);

		// Loop the rain sound
		Audio.get().loopMusic("rain", 0.5);
	
#if debug
		// mute
		Audio.get().setVolume(0.0);
#end
	}
}