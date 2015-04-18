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
		var title = new Bitmap(Assets.getBitmapData("assets/title.png"));
		Position.relative(title, 0.5, 0.5);

		addChild(title);
	}


	// --------------------------------------------------------------------------
	// OVERRIDES SCENE
	// --------------------------------------------------------------------------

	public override function onEnter(source : Scene) : Void
	{

	}

	public override function onExit(destination : Scene) : Void
	{

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