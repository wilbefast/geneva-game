import openfl.display.Sprite;
import motion.easing.Quad;
import motion.Actuate;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.Assets;

class Avatar extends GameObject
{
	private var _desiredTile : Tile = null;

	private var _life : Float = 1.0;

	private var _img : Bitmap;
	private var _img_n : BitmapData;
	private var _img_s : BitmapData;
	private var _img_e : BitmapData;
	private var _img_w : BitmapData;

	public function new(tile : Tile)
	{
		super(tile);

		/*
		graphics.beginFill(0xff0000);
		graphics.drawRect(-10, -10, 20, 20);
		graphics.endFill();
		*/

		_img_n = Assets.getBitmapData("assets/avatar_n.png");
		_img_s = Assets.getBitmapData("assets/avatar_s.png");
		_img_e = Assets.getBitmapData("assets/avatar_e.png");
		_img_w = Assets.getBitmapData("assets/avatar_w.png");

		_img = new Bitmap(_img_s, PixelSnapping.ALWAYS);
		var centre = new Sprite();
		centre.x = -_img.width*0.5;
		centre.y = -_img.height*0.75;
		addChild(centre);
		centre.addChild(_img);
	}

	public function tryMove(newTile : Tile) : Int
	{
		if(newTile == null)
			return 0;

		if(isMoving())
			return 0;

		if(newTile == _tile.getNorth())
			_img.bitmapData = _img_n;
		else if(newTile == _tile.getSouth())
			_img.bitmapData = _img_s;
		else if(newTile == _tile.getEast())
			_img.bitmapData = _img_e;
		else if(newTile == _tile.getWest())
			_img.bitmapData = _img_w;

		if(!newTile.isWalkable())
			return 1;

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
			_life -= 2*g;
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