interface Scene
{
	public function onEnter(source : Scene) : Void;
	public function onExit(destination : Scene) : Void;
	public function onUpdate(dt : Float) : Void;
	public function onKeyPress() : Void;
	public function onKeyRelease() : Void;
}