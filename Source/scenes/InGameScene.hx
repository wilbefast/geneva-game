package ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.ui.Keyboard;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.Assets;
import motion.Actuate;

class InGameScene extends Scene
{
	private var _level : Level;
	private var _levelNumber : Int = 0;

	// --------------------------------------------------------------------------
	// OVERRIDES SCENE
	// --------------------------------------------------------------------------

	public override function onEnter(source : Scene) : Void
	{
		if(source != this)
		{
			// Loop the game music
			Audio.get().playMusic("music");

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
		}

		// Load level
		_level = new Level(_levelNumber);
		addChild(_level);
		_level.x = (width - _level.width)*0.5;
		_level.y = (height - _level.height)*0.5;
	}

	public override function onExit(destination : Scene) : Void
	{
		if(destination != this)
			// Stop the game music
			Audio.get().stopMusic("music");

		removeChild(_level);
		_level = null;
	}

#if debug
	private var _capture_gif : Bool = false;
#end

	public override function onUpdate(dt : Float) : Void
	{
		_level.update(dt);

#if debug
		if(_capture_gif)
			Screenshot.capture(_level);
#end

	}

	public override function onKeyPress(keyCode : UInt) : Void
	{
		switch(keyCode)
		{
			case Keyboard.ESCAPE:
				SceneManager.get().goto("Title");

#if debug
			case Keyboard.ENTER:
				onEvent("win");

			case Keyboard.BACKSPACE:
				onEvent("lose");

			case Keyboard.SPACE:
				_capture_gif = !_capture_gif;
#end
		}
	}

	public override function onKeyRelease(keyCode : UInt) : Void
	{

	}

	public override function onEvent(name : String) : Void
	{
		switch(name)
		{
			case "win":
				_levelNumber++;
				onExit(this);
				onEnter(this);

			case "lose":
				onExit(this);
				onEnter(this);

			case _:
		}
	}
}