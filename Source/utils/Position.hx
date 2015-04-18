import openfl.display.DisplayObject;
import openfl.Lib;

class Position
{
	public static function relative(obj : DisplayObject, x : Float, y : Float)
	{
		if(x < 0 || x > 1 || y < 0 || y > 1)
			throw "Invalid position passed to Position::relative";
		obj.x = Lib.current.stage.stageWidth*x;
		obj.y = Lib.current.stage.stageHeight*y;
	}

	public static function absolute(obj : DisplayObject, x : Float, y : Float)
	{
		obj.x = x;
		obj.y = y;
	}
}