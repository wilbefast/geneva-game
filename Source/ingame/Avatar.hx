import openfl.display.Sprite;
import motion.easing.Quad;
import motion.Actuate;
import openfl.display.Bitmap;
import openfl.Assets;

class Avatar extends GameObject
{
	private var _desiredTile : Tile = null;

	private var _life : Float = 1.0;

	public function new(tile : Tile)
	{
		super(tile);

		/*
		graphics.beginFill(0xff0000);
		graphics.drawRect(-10, -10, 20, 20);
		graphics.endFill();
		*/
		var img = new Bitmap(
			Assets.getBitmapData("assets/avatar_n.png"));
		var centre = new Sprite();
		centre.x = -img.width*0.5;
		centre.y = -img.height*0.75;
		addChild(centre);
		centre.addChild(img);
	}

	public function tryMove(newTile : Tile) : Int
	{
		if(newTile == null)
			return 0;

		if(isMoving())
			return 0;

		if(!newTile.isWalkable())
			return 0;

		var moveCost = newTile.moveCost() + _tile.moveCost();

		_desiredTile = newTile;
		Actuate.tween (this, moveCost*Level.STEP_DURATION, 
			{ x : newTile.x, y : newTile.y }, false)
		.ease(Quad.easeOut)
		.onComplete (function() {
			_tile = _desiredTile;
			_onEnter(_tile);
			_desiredTile = null;
		});
		
		return Math.floor(moveCost);
	}

	private function _onEnter(t : Tile)
	{
		var g = t.getGas();
		if(g <= 0)
			_life = Math.min(1.0, _life + 0.2);
		else
		{
			_life -= g;
			if(_life <= 0.0)
				SceneManager.get().onEvent("lose");
		}

		switch(t.getType())
		{
			case Exit:
				SceneManager.get().onEvent("win");

			case _:
		}
	}

	public function isMoving() : Bool
	{
		return (_desiredTile != null);
	}
}