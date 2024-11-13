package mobile.flixel;

//new
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
//old
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.geom.Matrix;

/**
 * A zone with 4 hint's (A hitbox).
 * It's really easy to customize the layout.
 *
 * @author Mihai Alexandru (M.A. Jigsaw)
 */
class FlxNewHitbox extends FlxSpriteGroup
{
	public var buttonLeft:FlxButton = new FlxButton(0, 0);
	public var buttonDown:FlxButton = new FlxButton(0, 0);
	public var buttonUp:FlxButton = new FlxButton(0, 0);
	public var buttonRight:FlxButton = new FlxButton(0, 0);
	
	public var buttonExtra1:FlxButton = new FlxButton(0, 0);
    public var buttonExtra2:FlxButton = new FlxButton(0, 0);
    public var buttonExtra3:FlxButton = new FlxButton(0, 0);
	public var buttonExtra4:FlxButton = new FlxButton(0, 0);
	public static var hitbox_hint:FlxSprite;

	/**
	 * Create the zone.
	 */
	public function new():Void
	{
		super();
        add(buttonLeft = createHint(0, 0, Std.int(FlxG.width / 4), Std.int(FlxG.height * 1), 0xFFC24B99));
		add(buttonDown = createHint(FlxG.width / 4, 0, Std.int(FlxG.width / 4), Std.int(FlxG.height * 1), 0xFF00FFFF));
		add(buttonUp = createHint(FlxG.width / 2, 0, Std.int(FlxG.width / 4), Std.int(FlxG.height * 1), 0xFF12FA05));
		add(buttonRight = createHint((FlxG.width / 2) + (FlxG.width / 4), 0, Std.int(FlxG.width / 4), Std.int(FlxG.height * 1), 0xFFF9393F));
		
		scrollFactor.set();
	}

	/**
	 * Clean up memory.
	 */
	override function destroy():Void
	{
		super.destroy();

		buttonLeft = null;
		buttonDown = null;
		buttonUp = null;
		buttonRight = null;
		
		buttonExtra1 = null;
		buttonExtra2 = null;
		buttonExtra3 = null;
		buttonExtra4 = null;
	}

	private function createHintGraphic(Width:Int, Height:Int, Color:Int = 0xFFFFFF):BitmapData
	{
	    var guh:Float = 0.7;
		var shape:Shape = new Shape();
		shape.graphics.beginFill(Color);
		shape.graphics.lineStyle(3, Color, 1);
		shape.graphics.drawRect(0, 0, Width, Height);
		shape.graphics.lineStyle(0, 0, 0);
		shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
		shape.graphics.endFill();
		shape.graphics.beginGradientFill(RADIAL, [Color, FlxColor.TRANSPARENT], [guh, 0], [0, 255], null, null, null, 0.5);
		shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
		shape.graphics.endFill();
		
		/*
		shape.graphics.lineStyle(10, Color, 1);
		shape.graphics.drawRect(0, 0, Width, Height);
		shape.graphics.endFill();
		*/

		var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	private function createHint(X:Float, Y:Float, Width:Int, Height:Int, Color:Int = 0xFFFFFF):FlxButton
	{
		var hint:FlxButton = new FlxButton(X, Y);
		hint.loadGraphic(createHintGraphic(Width, Height, Color));
		hint.solid = false;
		hint.immovable = true;
		hint.scrollFactor.set();
		hint.alpha = 0.00001;
		hint.onDown.callback = hint.onOver.callback = function()
		{
			if (hint.alpha != 0.7)
				hint.alpha = 0.7;
		}
		hint.onUp.callback = hint.onOut.callback = function()
		{
			if (hint.alpha != 0.00001)
				hint.alpha = 0.00001;
		}
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		return hint;
	}
}
