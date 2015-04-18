package ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;

class Main extends Sprite 
{
	var title : TitleScene;
	var game : GameScene;
	var fail : FailScene;

	public function new () 
	{
		super ();

		var scenes = SceneManager.get();
		scenes.set("Title", new TitleScene());
		scenes.set("Game", new GameScene());
		scenes.set("Fail", new FailScene());
	}
}