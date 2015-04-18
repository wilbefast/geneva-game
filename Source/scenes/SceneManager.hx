import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.KeyboardEvent;


class SceneManager
{
	// --------------------------------------------------------------------------
	// SINGLETON
	// --------------------------------------------------------------------------

	private var _current : Scene = null;

	private static var _instance : SceneManager;

	private function new()
	{
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, 
		function(e : KeyboardEvent) {
			if(_current != null)
				_current.onKeyPress();
		});

		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, 
		function(e : KeyboardEvent) {
			if(_current != null)
				_current.onKeyPress();
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
		if(_current != null)
			_current.onExit(next);
		next.onEnter(_current);
		_current = next;
	}

	public function goto(sceneName : String)
	{
		var scene = _all.get(sceneName);
		if(scene == null)
			throw "Invalid scene name passed to SceneManager::goto";
		_goto(scene);
	}
}