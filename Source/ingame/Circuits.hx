import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.display.Sprite;
import openfl.Assets;

class Circuits
{
	// --------------------------------------------------------------------------
	// SINGLETON
	// --------------------------------------------------------------------------

	private static var _instance : Circuits;

	public static function get() : Circuits
	{
		if(_instance == null)
			_instance = new Circuits();
		return _instance;
	}

	private function new()
	{
		reset();
	}

	private var _circuits : Map<UInt, Bool>;
 
	// --------------------------------------------------------------------------
	// QUERY
	// --------------------------------------------------------------------------

	public function isOn(circuit : UInt) : Bool
	{
		return _circuits[circuit];
	}

	// --------------------------------------------------------------------------
	// INIT
	// --------------------------------------------------------------------------

	var _doorOpen : BitmapData;
	var _doorClosed:  BitmapData;
	var _switchOn : BitmapData;
	var _switchOff : BitmapData;

	public function reset()
	{
		_circuits = new Map<UInt, Bool>();
		_doors = new Map<UInt, List<Bitmap>>();
		_switches = new Map<UInt, List<Bitmap>>();

		_doorOpen = Assets.getBitmapData(
			"assets/doorOpen.png");
		_doorClosed = Assets.getBitmapData(
			"assets/doorClosed.png");
		_switchOn = Assets.getBitmapData(
			"assets/switch_on.png");
		_switchOff = Assets.getBitmapData(
			"assets/switch_off.png");		
	}

	private var _doors : Map<UInt, List<Bitmap>>;

	public function registerDoor(t : Tile, circuit : UInt)
	{
		// sprite
		var img = new Bitmap(_doorClosed, PixelSnapping.ALWAYS);
		if(Std.random(2) == 0)
			img.scaleX = -1;
		else
			img.scaleX = 1;
		img.x = -img.width*0.5;
		img.y = -img.height*0.5;
		t.addChild(img);

		// memorise
		if(!_doors.exists(circuit))
			_doors[circuit] = new List<Bitmap>();
		_doors[circuit].push(img);
	}

	private var _switches : Map<UInt, List<Bitmap>>;

	public function registerSwitch(t : Tile, circuit : UInt)
	{
		// sprite
		var img = new Bitmap(_switchOff, PixelSnapping.ALWAYS);
		if(Std.random(2) == 0)
			img.scaleX = -1;
		else
			img.scaleX = 1;
		img.x = -img.width*0.5;
		img.y = -img.height*0.5;
		t.addChild(img);

		// memorise
		if(!_switches.exists(circuit))
			_switches[circuit] = new List<Bitmap>();
		_switches[circuit].push(img);
	}


	// --------------------------------------------------------------------------
	// MODIFY
	// --------------------------------------------------------------------------

	public function switchCircuit(circuit : UInt) : Bool
	{
		// memorise circuit state
		var newValue = switch(_circuits[circuit])
		{
			case (null | false): true;
			case true: false;
		}
		_circuits[circuit] = newValue;

		// update sprites
		for(img in _doors[circuit])
			img.bitmapData = newValue ? _doorOpen : _doorClosed;

		for(img in _switches[circuit])
			img.bitmapData = newValue ? _switchOn : _switchOff;

		return newValue;
	}
}