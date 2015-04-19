package ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.ui.Keyboard;

class InGameScene extends Scene
{
	private var _level : Level;
	private var _levelNumber : Int = 0;

	// --------------------------------------------------------------------------
	// OVERRIDES SCENE
	// --------------------------------------------------------------------------

	public override function onEnter(source : Scene) : Void
	{
		_level = new Level(_levelNumber);
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