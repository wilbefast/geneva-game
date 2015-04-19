import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.Assets;
import openfl.media.SoundTransform;

class Audio
{
	// --------------------------------------------------------------------------
	// SINGLETON
	// --------------------------------------------------------------------------

	private static var _instance : Audio;

	public static function get() : Audio
	{
		if(_instance == null)
			_instance = new Audio();
		return _instance;
	}

	private function new()
	{
		_music = new Map<String, SoundChannel>();
		_transform = new SoundTransform(1.0, 0.0);
	}

	// --------------------------------------------------------------------------
	// LOAD
	// --------------------------------------------------------------------------

	private var _music : Map<String, SoundChannel>;

	private static function _sound(name : String)
	{
		#if flash
			var sound = Assets.getSound("assets/" + name + ".mp3");
		#else 
			var sound = Assets.getSound("assets/" + name + ".ogg");
		#end

		if(sound == null)
			throw "Sound file not found '" + name + "'";
		return sound;
	}

	private function _playMusic(name : String, loop : Bool, 
		volume : Float, position : Float = 0.0)
	{
		var musicTransform = new SoundTransform(
			volume * _transform.volume, _transform.pan);

		if(musicTransform.volume > 0)
		{
			var musicChannel = _music[name];
			if(musicChannel != null)
				musicChannel.stop();
			_music[name] = _sound(name).play(position, 
				loop ? 0x3FFFFFFF : 0, musicTransform);
		}
	}

	public function playMusic(name : String, volume : Float = 1.0)
	{
		_playMusic(name, false, volume);
	}

	public function loopMusic(name : String, volume : Float = 1.0)
	{
		_playMusic(name, true, volume);
	}

	public function stopMusic(name : String)
	{
		if(!_music.exists(name))
			throw "No music of called '" + name + "' exists";
		_music[name].stop();
	}

	// --------------------------------------------------------------------------
	// VOLUME / MUTE
	// --------------------------------------------------------------------------

	var _transform : SoundTransform;

	public function setVolume(volume : Float)
	{
		if(volume < 0 || volume > 1)
			throw "Invalid volume " + volume;

		trace("Setting volume doesn't yet work for sounds already playing");
		if(volume == 0)
			for(m in _music)
				m.stop();

		_transform.volume = volume;

		/*
		for(name in _music.keys())
		{
			var m = _music[name];

			var p = m.soundTransform.pan;
			var v = m.soundTransform.volume;
			var t = m.position;
			_playMusic(name, false, v, t);
		}
		*/
	}

}