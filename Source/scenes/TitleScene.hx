package ;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.PixelSnapping;
import openfl.Assets;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.ui.Keyboard;
import openfl.system.System;
import motion.Actuate;
import motion.easing.Linear;

class TitleScene extends Scene 
{
	public function new()
	{
		super();

		// Add the rain
		var rain_source = [ 
			Assets.getBitmapData("assets/rain1.png"),
			Assets.getBitmapData("assets/rain2.png"),
			Assets.getBitmapData("assets/rain3.png")];
		var _rain = new Bitmap(rain_source[0], PixelSnapping.ALWAYS);
		_rain.y += 80;
		addChild(_rain);
		var _rain_i = 0;
		function _cycleRain()
		{
			Actuate.timer(0.1).onComplete(function() {
				_rain_i = (_rain_i + 1) % 3;
				_rain.bitmapData = rain_source[_rain_i];
				_cycleRain();
			});
		}
		_cycleRain();

		// title
		var cannister = new Bitmap(
			Assets.getBitmapData("assets/title_cannister.png"),
			PixelSnapping.ALWAYS);
		cannister.scaleX = 4;
		cannister.scaleY = 4;
		addChild(cannister);
		cannister.x = width*0.7 - cannister.width*0.5;
		cannister.y = height*0.5 - cannister.height*0.5;
		var _base_y = cannister.y;
		function _bounce()
		{
			Actuate.update(function(t : Float) {
				cannister.y = _base_y + 8*Math.sin(2 * t * Math.PI);
			}, 3.0, [0], [1]).onComplete(_bounce).ease(Linear.easeNone);
		}
		_bounce();

		// title
		var title = new Bitmap(
			Assets.getBitmapData("assets/title.png"),
			PixelSnapping.ALWAYS);
		title.scaleX = 4;
		title.scaleY = 4;
		title.x = width*0.3 - title.width*0.5;
		title.y = height*0.52 - title.height*0.5;
		addChild(title);

	}


	// --------------------------------------------------------------------------
	// OVERRIDES SCENE
	// --------------------------------------------------------------------------

	public override function onEnter(source : Scene) : Void
	{
		// Play the intro sound once
		Audio.get().playMusic("title_music", 0.8);
	}

	public override function onExit(destination : Scene) : Void
	{
		// Stop the intro sound
		Audio.get().stopMusic("title_music");
	}

	public override function onUpdate(dt : Float) : Void
	{

	}

	public override function onKeyPress(keyCode : UInt) : Void
	{
		switch(keyCode)
		{
			case Keyboard.ENTER:
				SceneManager.get().goto("InGame");

			case Keyboard.ESCAPE:
				System.exit(0);
		}
	}

	public override function onMousePress(x : Float, y : Float) : Void
	{
		SceneManager.get().goto("InGame");
	}

	public override function onKeyRelease(keyCode : UInt) : Void
	{

	}

}