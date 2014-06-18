package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;
import flixel.group.FlxTypedGroup;

/**
 * A class for the starfield
 */
class StarField extends FlxObject {
	private static var NUM_STARS:UInt = 75;
	private var _stars:FlxTypedGroup<FlxSprite>;
	
	/**
	 * @param   ang This is the angle that the starField will be rotating (in degrees)
	 * @param   speedMultiplier
	 */
	public function new(ang:Float = 90, speedMultiplier:Float = 4):Void {          
		angle = ang;
		_stars = new FlxTypedGroup<FlxSprite>(NUM_STARS);
		 
		var radang:Float = angle * Math.PI / 180;
		var cosang:Float = Math.cos(radang);
		var sinang:Float = Math.sin(radang);
		 
		for (i in 0...NUM_STARS) {
			var str:FlxSprite = new FlxSprite(Math.random() * FlxG.width, Math.random() * FlxG.height);
			var vel:Float = Math.random() * -16 * speedMultiplier;
			 
			// change the transparency of the star based on it's velocity
			var transp:UInt = (Math.round(16 * (-vel / speedMultiplier) - 1) << 24);
			 
			str.makeGraphic(2, 2, 0x00ffffff | transp);
			str.velocity.x = cosang * vel;
			str.velocity.y = sinang * vel;
			_stars.add(str);
		}
		
		super();
	}
	
	/**
	 * Rotate the starField
	 * @param   howMuch Input the amount of rotation in degrees
	 */
	public function rotate(howMuch:Float = 1):Void {
		for (i in 0...NUM_STARS) {
			var str:FlxSprite = _stars.members[i];
			var velVector:FlxVector = new FlxVector(str.velocity.x, str.velocity.y);
			
			velVector.rotateByDegrees(howMuch);
		
			str.velocity = velVector;
		}
	}
	 
	override public function update():Void {
		_stars.update();
		 
		for (i in 0..._stars.members.length) {
			var star:FlxSprite = _stars.members[i];
			if (star.x > FlxG.width) {
				star.x = 0;
			} else if (star.x < 0) {
				star.x = FlxG.width;
			}
			if (star.y > FlxG.height) {
				star.y = 0;
			} else if (star.y < 0) {
				star.y = FlxG.height;
			}
		}
	}
	
	override public function draw():Void {
		_stars.draw();
	}
}
/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{	
	// state
	// 0 = stopped
	// 1 = rotate CW
	// -1 = rotate CCW
	private var state:UInt = 1;
	private var starField:StarField;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		starField = new StarField(45);
		add(starField);
		
		var title = new FlxText(0, 0, FlxG.width, "HaxeFlixel");
		title.setFormat(null, 42, 0xeeeeee, "center");

		add(title);
		
		var butStop = new FlxButton(10, 10, "Stop rotation", function() { state = 0; } );
		add(butStop);
		
		var butRotateCCW = new FlxButton(10, 50, "Rotate CCW", function() { state = -1; } );
		add(butRotateCCW);
		
		var butRotateCW = new FlxButton(10, 90, "Rotate CW", function() { state = 1; } );
		add(butRotateCW);
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		starField.rotate(cast(state,Float));
	}	
}