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
	private var _img_n_flooded : BitmapData;
	private var _img_s_flooded : BitmapData;
	private var _img_e_flooded : BitmapData;
	private var _img_w_flooded : BitmapData;


	public function new(tile : Tile)
	{
		super(tile);

		_img_n = Assets.getBitmapData("assets/avatar_n.png");
		_img_s = Assets.getBitmapData("assets/avatar_s.png");
		_img_e = Assets.getBitmapData("assets/avatar_e.png");
		_img_w = Assets.getBitmapData("assets/avatar_w.png");
		_img_n_flooded = Assets.getBitmapData(
			"assets/avatar_n_flooded.png");
		_img_s_flooded = Assets.getBitmapData(
			"assets/avatar_s_flooded.png");
		_img_e_flooded = Assets.getBitmapData(
			"assets/avatar_e_flooded.png");
		_img_w_flooded = Assets.getBitmapData(
			"assets/avatar_w_flooded.png");

		_img = new Bitmap(_img_s, PixelSnapping.ALWAYS);
		var centre = new Sprite();
		centre.x = -_img.width*0.5;
		centre.y = -_img.height*0.75;
		addChild(centre);
		centre.addChild(_img);
	}

	public function isDead()
	{
		return (_life <= 0);
	}

	public function tryMove(newTile : Tile) : Int
	{
		if(_life <= 0)
			return 0;

		if(newTile == null)
			return 0;

		if(isMoving())
			return 0;

		if(newTile == _tile.getNorth())
		{	
			if(newTile.getType() == Flooded)
				_img.bitmapData = _img_n_flooded;
			else	
				_img.bitmapData = _img_n;
		}
		else if(newTile == _tile.getSouth())
		{	
			if(newTile.getType() == Flooded)
				_img.bitmapData = _img_s_flooded;
			else	
				_img.bitmapData = _img_s;
		}
		else if(newTile == _tile.getEast())
		{	
			if(newTile.getType() == Flooded)
				_img.bitmapData = _img_e_flooded;
			else	
				_img.bitmapData = _img_e;
		}
		else if(newTile == _tile.getWest())
		{	
			if(newTile.getType() == Flooded)
				_img.bitmapData = _img_w_flooded;
			else	
				_img.bitmapData = _img_w;
		}

		if(!newTile.isWalkable())
			return 1;

		var moveCost = newTile.moveCost() + _tile.moveCost();
		
		var delay = moveCost*Level.STEP_DURATION;

		_onStartEntering(newTile, delay);

		_desiredTile = newTile;

		// Move
		Actuate.tween (this, delay, 
			{ x : newTile.x, y : newTile.y }, false)
		.ease(Quad.easeOut)
		.onComplete (function() {
			_tile = _desiredTile;
			_onFinishEntering(_tile);
			_desiredTile = null;
		});

		// Bounce
		var _base_y = _img.y;
		Actuate.update(function(t : Float) {
			scaleY = 0.9 + 0.1*Math.cos(8 * t * Math.PI);
			_img.y = _base_y + 2*Math.sin(8 * t * Math.PI);
		}, delay, [0], [1]);

		// Report cost
		return Math.floor(moveCost);
	}

	private function _onStartEntering(t : Tile, delay : Float)
	{
		var g = t.getGas();
		if(g <= 0)
			_life = Math.min(1.0, _life + 0.2);
		else
		{
			_life -= 2*g;
			if(_life <= 0.0)
				Actuate.tween(this, 1.0,
					{ scaleX : 0, scaleY : 0}, false)
				.onComplete(function() {
					SceneManager.get().onEvent("lose");
				});
				
		}

		switch(t.getType())
		{
			case Exit:
				Actuate.tween(this, delay,
					{ scaleX : 0, scaleY : 0}, false);

			case _:
		}
	}

	private function _onFinishEntering(t : Tile)
	{

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