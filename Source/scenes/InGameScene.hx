package ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.ui.Keyboard;

class InGameScene extends Scene
{
	private var _level : Level;

	// --------------------------------------------------------------------------
	// OVERRIDES SCENE
	// --------------------------------------------------------------------------

	public override function onEnter(source : Scene) : Void
	{
		_level = new Level(0);
		addChild(_level);
	}

	public override function onExit(destination : Scene) : Void
	{
		removeChild(_level);
		_level = null;
	}

	public override function onUpdate(dt : Float) : Void
	{
		_level.update(dt);
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