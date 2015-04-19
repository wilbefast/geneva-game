package ;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.ui.Keyboard;
import openfl.system.System;
import openfl.media.Sound;
import openfl.media.SoundChannel;

class TitleScene extends Scene 
{
	private var _music_channel : SoundChannel;

	public function new()
	{
		super();

		// title
		addChild(new Bitmap(
			Assets.getBitmapData("assets/title.png")));
	}


	// --------------------------------------------------------------------------
	// OVERRIDES SCENE
	// --------------------------------------------------------------------------

	public override function onEnter(source : Scene) : Void
	{
		// Play music
		#if flash
			var music = Assets.getSound("assets/title_music.mp3");
		#else 
			var music = Assets.getSound("assets/title_music.ogg");
		#end
		_music_channel = music.play();
	}

	public override function onExit(destination : Scene) : Void
	{
		_music_channel.stop();
		_music_channel = null;
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

	public override function onKeyRelease(keyCode : UInt) : Void
	{

	}

}