package ;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.ui.Keyboard;
import openfl.system.System;

class TitleScene extends Scene 
{
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

	public override function onKeyRelease(keyCode : UInt) : Void
	{

	}

}