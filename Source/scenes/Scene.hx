import openfl.display.Sprite;

class Scene extends Sprite
{
	public function onEnter(source : Scene) : Void
	{
		// override me
	}

	public function onExit(destination : Scene) : Void
	{
		// override me
	}

	public function onUpdate(dt : Float) : Void
	{
		// override me
	}

	public function onKeyPress(keyCode : UInt) : Void
	{
		// override me
	}

	public function onKeyRelease(keyCode : UInt) : Void
	{
		// override me
	}

	public function onMousePress(x : Float, y : Float) : Void
	{
		// override me
	}

	public function onMouseRelease(x : Float, y : Float) : Void
	{
		// override me
	}

	public function onEvent(name : String, ?args : Dynamic) : Void
	{
		// override me
	}

}