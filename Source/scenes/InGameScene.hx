package ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.ui.Keyboard;
import openfl.Assets;
import openfl.media.Sound;
import openfl.media.SoundChannel;

class InGameScene extends Scene
{
	private var _level : Level;
	private var _levelNumber : Int = 0;

	private var _music : Sound;
	private var _music_channel :SoundChannel;

	// --------------------------------------------------------------------------
	// OVERRIDES SCENE
	// --------------------------------------------------------------------------

	public override function onEnter(source : Scene) : Void
	{
		if(source != this && _music == null && _music_channel == null)
		{
			// Play music
			#if flash
				_music = Assets.getSound("assets/music.mp3");
			#else 
				_music = Assets.getSound("assets/music.ogg");
			#end
			function _loopMusic(_) : Void
			{
				_music_channel = _music.play();
				_music_channel.addEventListener(Event.SOUND_COMPLETE, _loopMusic);
			}
			_loopMusic(null);
		}

		// Load level
		_level = new Level(_levelNumber);
		addChild(_level);
	}

	public override function onExit(destination : Scene) : Void
	{
		if(destination != this && _music != null && _music_channel != null)
		{
			_music_channel.stop();
			_music_channel = null;
			_music = null;
		}
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