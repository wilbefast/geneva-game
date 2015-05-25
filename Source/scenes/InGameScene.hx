package ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.ui.Keyboard;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.PixelSnapping;
import openfl.Assets;
import motion.Actuate;

class InGameScene extends Scene
{
	private var _level : Level;
	private var _levelNumber : Int = 0;

	private var _rain : Bitmap;

	// --------------------------------------------------------------------------
	// OVERRIDES SCENE
	// --------------------------------------------------------------------------

	public override function onEnter(source : Scene) : Void
	{
		// Add background
		var background = new Bitmap(
			Assets.getBitmapData("assets/background.png"),
			PixelSnapping.ALWAYS);
		addChild(background);
		
		// Load level
		_level = new Level(_levelNumber);
		addChild(_level);
		/*
		var scale = Math.min(
			Lib.current.stage.width / _level.width,
			Lib.current.stage.height / _level.height);
		_level.scaleX = scale;
		_level.scaleY = scale;
*/
		// Loop the game music
		if(source != this)
			Audio.get().playMusic("music");

/*
		// Add the vignette to the level
		var vignette = new Bitmap(
			Assets.getBitmapData("assets/vignette.png"),
			PixelSnapping.ALWAYS);
		vignette.scaleX = _level.width/vignette.width;
		vignette.scaleY = _level.height/vignette.height;
		addChild(vignette);
*/

		// Add the rain
		var rain_source = [ 
			Assets.getBitmapData("assets/rain1.png"),
			Assets.getBitmapData("assets/rain2.png"),
			Assets.getBitmapData("assets/rain3.png")];
		_rain = new Bitmap(rain_source[0], PixelSnapping.ALWAYS);
		addChild(_rain);
		var _rain_i = 0;
		function _cycleRain()
		{
			Actuate.timer(0.1).onComplete(function() {
				if(_level != null)
				{
					if(_level.isStepping())
					{
						_rain_i = (_rain_i + 1) % 3;
						_rain.bitmapData = rain_source[_rain_i];
					}
					_cycleRain();
				}
			});
		}
		_cycleRain();

		// Position level
		_level.x = (width - _level.width)*0.5;
		_level.y = (height - _level.height)*0.5;
/*
		vignette.x = _level.x - 16;
		vignette.y = _level.y - 24;
*/
	}

	public override function onExit(destination : Scene) : Void
	{
		if(destination != this)
			// Stop the game music
			Audio.get().stopMusic("music");

		removeChild(_rain);
		_rain = null;

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
			Screenshot.capture(this);
#end

	}

	public override function onKeyPress(keyCode : UInt) : Void
	{
		switch(keyCode)
		{
			case Keyboard.ESCAPE:
				SceneManager.get().goto("Title");

#if debug
			case Keyboard.SHIFT:
				onEvent("win");

			case Keyboard.BACKSPACE:
				onEvent("lose");

			case Keyboard.CAPS_LOCK:
				_capture_gif = !_capture_gif;
#end
		}
	}

	public override function onKeyRelease(keyCode : UInt) : Void
	{

	}

	public override function onEvent(name : String, 
		?args : Dynamic) : Void
	{
		switch(name)
		{
			case "win":
				_levelNumber++;
				if(Assets.getBitmapData(
					Level.levelFilename(_levelNumber)) == null)
				{
					_levelNumber = 0;
					SceneManager.get().goto("Title");
				}
				else
				{
					onExit(this);
					onEnter(this);
				}

			case "lose":
				onExit(this);
				onEnter(this);
				
			case _:
		}
	}
}