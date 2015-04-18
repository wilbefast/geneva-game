package ;

import openfl.display.Sprite;

class Main extends Sprite 
{
	public function new () 
	{
		super ();

		var scenes = SceneManager.get();
		scenes.set("Title", new TitleScene());
		scenes.set("InGame", new InGameScene());
		scenes.set("Fail", new FailScene());

		addChild(scenes);
	}
}