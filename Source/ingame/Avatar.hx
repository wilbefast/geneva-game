import openfl.display.Sprite;
import motion.easing.Quad;
import motion.Actuate;


class Avatar extends Sprite
{
	private var _tile : Tile;
	private var _desiredTile : Tile = null;

	public function new(tile : Tile)
	{
		super();

		_tile = tile;

		graphics.beginFill(0xff0000);
		graphics.drawRect(-10, -10, 20, 20);
		graphics.endFill();
	}

	public function tryMove(newTile : Tile) : Bool
	{
		if(newTile == null)
			return false;

		if(isMoving())
			return false;

		_desiredTile = newTile;

		Actuate.tween (this, 0.5, { x: newTile.x, y: newTile.y }, false)
		.ease (Quad.easeOut)
		.onComplete (function() {
			_tile = _desiredTile;
			_desiredTile = null;	
		});
		
		return true;
	}

	public function getTile() : Tile
	{
		return _tile;
	}

	public function isMoving() : Bool
	{
		return (_desiredTile != null);
	}
}