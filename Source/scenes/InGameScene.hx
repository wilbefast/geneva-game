package ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.ui.Keyboard;

class InGameScene extends Scene
{
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
			case Keyboard.ESCAPE:
				SceneManager.get().goto("Title");
		}
	}

	public override function onKeyRelease(keyCode : UInt) : Void
	{

	}
}