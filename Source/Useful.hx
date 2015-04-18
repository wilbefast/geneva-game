import openfl.display.DisplayObject;
import openfl.Lib;

class Useful
{
	public static function position(obj : DisplayObject, x : Float, y : Float)
	{
		if(x < 0 || x > 1 || y < 0 || y > 1)
			throw "Invalid position passed to Useful::position";
		obj.x = Lib.current.stage.stageWidth*x - obj.width*0.5;
		obj.y = Lib.current.stage.stageHeight*y - obj.height*0.5;
	}
}