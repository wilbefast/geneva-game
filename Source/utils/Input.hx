import lime.math.Vector2;
import openfl.ui.Keyboard;
import openfl.Lib;
import openfl.events.KeyboardEvent;

class Input
{
	private static var _isPressed : Map<UInt, Bool>; 

	public static function listen()
	{
		_isPressed = new Map<UInt, Bool>();

		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, 
		function(e : KeyboardEvent) {
			_isPressed[e.keyCode] = true;
		});

		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, 
		function(e : KeyboardEvent) {
			_isPressed[e.keyCode] = false;
		});
	}

	public static function isPressed(keyCode : UInt) : Bool
	{
		var state = _isPressed.get(keyCode);
		return (state == null ? false : state);
	}

	public static function getDirection() : Vector2
	{
		var x = 0;
		var y = 0;
		if(isPressed(Keyboard.UP)) y--;
		if(isPressed(Keyboard.DOWN)) y++;
		if(isPressed(Keyboard.LEFT)) x--;
		if(isPressed(Keyboard.RIGHT)) x++;

		return new Vector2(x, y);
	}
}