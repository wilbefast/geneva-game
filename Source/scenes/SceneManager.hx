import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import haxe.Timer;

class SceneManager extends Sprite
{
	// --------------------------------------------------------------------------
	// SINGLETON
	// --------------------------------------------------------------------------

	private var _current : Scene = null;

	private static var _instance : SceneManager;

	private var _lastTick : Float = 0.0;

	private function new()
	{
		super();

		// Key pressed
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, 
		function(e : KeyboardEvent) {
			if(_current != null)
				_current.onKeyPress(e.keyCode);
		});

		// Key released
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, 
		function(e : KeyboardEvent) {
			if(_current != null)
				_current.onKeyRelease(e.keyCode);
		});

		// Update
		_lastTick = Timer.stamp();
		Lib.current.stage.addEventListener(Event.ENTER_FRAME,
		function(e : Event) {
			var thisTick = Timer.stamp();
			if(_current != null)
				_current.onUpdate(thisTick - _lastTick);
			_lastTick = thisTick;
		});
	}

	public static function get()
	{
		if(_instance == null)
			_instance = new SceneManager();
		return _instance;
	}

	// --------------------------------------------------------------------------
	// NAVIGATION
	// --------------------------------------------------------------------------

	private var _all = new Map<String, Scene>();

	public function set(name : String, scene : Scene)
	{
		_all.set(name, scene);
		if(_current == null)
			_goto(scene);
	}

	private function _goto(next : Scene)
	{
		addChild(next);
		if(_current != null)
			_current.onExit(next);
		next.onEnter(_current);
		if(_current != null)
			removeChild(_current);
		_current = next;

		Position.relative(_current, 0.5, 0.5);
	}

	public function goto(sceneName : String)
	{
		var scene = _all.get(sceneName);
		if(scene == null)
			throw "Invalid scene name passed to SceneManager::goto";
		_goto(scene);
	}

	public function onEvent(name : String)
	{
		if(_current != null)
			_current.onEvent(name);
	}
}