package ;

import openfl.display.Sprite;

class Main extends Sprite 
{
	public function new () 
	{
		super ();

		// Set up the input manager
		Input.listen();

		// Set up the scene manager
		var scenes = SceneManager.get();
		scenes.set("Title", new TitleScene());
		scenes.set("InGame", new InGameScene());
		scenes.set("Fail", new FailScene());
		addChild(scenes);
	}
}