package ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.ui.Keyboard;

class InGameScene extends Scene
{
	private var _level : Level;

	private var _avatar : Avatar;

	// --------------------------------------------------------------------------
	// OVERRIDES SCENE
	// --------------------------------------------------------------------------

	public override function onEnter(source : Scene) : Void
	{
		_level = new Level(0);
		_avatar = _level.getAvatar();
		addChild(_level);
	}

	public override function onExit(destination : Scene) : Void
	{
		removeChild(_level);
		_avatar = null;
		_level = null;
	}

	public override function onUpdate(dt : Float) : Void
	{
		var d = Input.getDirection();

		var dx : Int = d.x < 0 ? Math.floor(d.x) : Math.ceil(d.x);
		var dy : Int = d.y < 0 ? Math.floor(d.y) : Math.ceil(d.y);
		if(dx != 0 || dy != 0)
			_avatar.tryMove(_avatar.getTile().getNeighbour(dx, dy));
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