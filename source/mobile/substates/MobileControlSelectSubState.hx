package mobile.substates;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import mobile.objects.MobileControls.Config;
import mobile.flixel.FlxButton as UIButton;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.util.FlxGradient;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;
import options.ControlsSubState;

using StringTools;

class MobileControlSelectSubState extends MusicBeatSubstate
{
    var vpad:FlxVirtualPad;
    var hbox:FlxHitbox;
    var newhbox:FlxNewHitbox;
    public static var upPozition:FlxText;
    public static var downPozition:FlxText;
    public static var leftPozition:FlxText;
    public static var rightPozition:FlxText;
    public static var grpControls:FlxText;
    public static var leftArrow:FlxSprite;
    public static var rightArrow:FlxSprite;
    public static var tipText:FlxText;
    public static var titleText:Alphabet;
    public static var daChoice:String;
    public static var options:Array<String> = ['Pad-Right','Pad-Left','Pad-Custom','Duo','Hitbox','Keyboard'];
    var curSelected:Int = 0;
    var buttonistouched:Bool = false;
    var bindbutton:FlxButton;
    var config:Config;
    var extendConfig:Config;
    
    var bg:FlxBackdrop;
    var ui:FlxCamera;
    public static var exit:UIButton;
    public static var reset:UIButton;
    public static var keyboard:UIButton;
    public static var inControlsSubstate:Bool = false;

    override public function create():Void
    {
        super.create();
        
        #if desktop FlxG.mouse.visible = true; #end

        // Transparent background and UI
        bg = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true,
            FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255)),
            FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255))));
        bg.velocity.set(40, 40);
        bg.alpha = 0;
        bg.antialiasing = true;
        FlxTween.tween(bg, {alpha: 0.45}, 0.3, {
            ease: FlxEase.quadOut,
            onComplete: (twn:FlxTween) ->
            {
                FlxTween.tween(ui, {alpha: 1}, 0.2, {ease: FlxEase.circOut});
            }
        });
        add(bg);

        ui = new FlxCamera();
        ui.bgColor.alpha = 0;
        ui.alpha = 0;
        FlxG.cameras.add(ui, false);

        config = new Config('saved-controls');
        curSelected = config.getcontrolmode();

        extendConfig = new Config('saved-extendControls');

        titleText = new Alphabet(75, 60, " Mobile Controls", true);
        titleText.scaleX = 0.6;
        titleText.scaleY = 0.6;
        titleText.alpha = 0.4;
        titleText.cameras = [ui];
        add(titleText);

        vpad = new FlxVirtualPad(RIGHT_FULL, controlExtend, 0.75, true);
        vpad.alpha = 0;
        vpad.cameras = [ui];
        add(vpad);

        hbox = new FlxHitbox(0.75, true);
        hbox.visible = false;
        hbox.cameras = [ui];
        add(hbox);

        newhbox = new FlxNewHitbox();
        newhbox.visible = false;
        newhbox.cameras = [ui];
        add(newhbox);
        
        grpControls = new FlxText(0, 100, 0, '', 32);
		grpControls.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, true);
		grpControls.borderSize = 3;
		grpControls.borderQuality = 1;
		grpControls.screenCenter(X);
		add(grpControls);

        leftArrow = new FlxSprite(grpControls.x - 60, grpControls.y - 25);
		leftArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		leftArrow.animation.addByPrefix('idle', 'arrow left');
		leftArrow.animation.play('idle');
		add(leftArrow);

		rightArrow = new FlxSprite(grpControls.x + grpControls.width + 10, grpControls.y - 25);
		rightArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.play('idle');
		add(rightArrow);

        upPozition = new FlxText(10, FlxG.height - 204, 0,"Button Up X:" + vpad.buttonUp.x +" Y:" + vpad.buttonUp.y, 16);
        upPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        upPozition.borderSize = 2;
        upPozition.cameras = [ui];
        add(upPozition);

        downPozition = new FlxText(10, FlxG.height - 184, 0,"Button Down X:" + vpad.buttonDown.x +" Y:" + vpad.buttonDown.y, 16);
        downPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        downPozition.borderSize = 2;
        downPozition.cameras = [ui];
        add(downPozition);

        leftPozition = new FlxText(10, FlxG.height - 164, 0,"Button Left X:" + vpad.buttonLeft.x +" Y:" + vpad.buttonLeft.y, 16);
        leftPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        leftPozition.borderSize = 2;
        leftPozition.cameras = [ui];
        add(leftPozition);

        rightPozition = new FlxText(10, FlxG.height - 144, 0,"Button RIght x:" + vpad.buttonRight.x +" Y:" + vpad.buttonRight.y, 16);
        rightPozition.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        rightPozition.borderSize = 2;
        rightPozition.cameras = [ui];
        add(rightPozition);
        
        tipText = new FlxText(10, FlxG.height - 24, 0, 'Press Exit & Save to Go Back to Options Menu', 16);
        tipText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        tipText.borderSize = 2;
        tipText.scrollFactor.set();
        tipText.cameras = [ui];
        add(tipText);

        exit = new UIButton(0, 35, "Exit & Save", () ->
        {
            save();
            FlxG.sound.play(Paths.sound('cancelMenu'));
            close();
        });
        exit.color = FlxColor.LIME;
        exit.setGraphicSize(Std.int(exit.width) * 3);
        exit.updateHitbox();
        exit.x = FlxG.width - exit.width - 70;
        exit.label.setFormat(Paths.font('vcr.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
        exit.label.fieldWidth = exit.width;
        exit.label.x = ((exit.width - exit.label.width) / 2) + exit.x;
        exit.label.offset.y = -10;
        exit.cameras = [ui];
        add(exit);
        
        reset = new UIButton(exit.x, exit.height + exit.y + 20, "Reset", () ->
		{
			changeSelection(0); // realods the current control mode ig?
			FlxG.sound.play(Paths.sound('cancelMenu'));
		});
		reset.color = FlxColor.RED;
		reset.setGraphicSize(Std.int(reset.width) * 3);
		reset.updateHitbox();
		reset.label.setFormat(Paths.font('vcr.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		reset.label.fieldWidth = reset.width;
		reset.label.x = ((reset.width - reset.label.width) / 2) + reset.x;
		reset.label.offset.y = -10;
		reset.cameras = [ui];
		add(reset);
		
		keyboard = new UIButton(exit.x, exit.height + exit.y + 20, "Keyboard", () ->
		{
			save();
			removeVirtualPad();
			leftArrow.visible = rightArrow.visible = grpControls.visible = exit.visible = reset.visible = keyboard.visible = upPozition.visible = downPozition.visible = leftPozition.visible = rightPozition.visible = tipText.visible = false;
			titleText.text = 'Controls';
			inControlsSubstate = true;
			openSubState(new ControlsSubState());
		});
		keyboard.color = FlxColor.GRAY;
		keyboard.setGraphicSize(Std.int(keyboard.width) * 3);
		keyboard.updateHitbox();
		keyboard.label.setFormat(Paths.font('vcr.ttf'), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		keyboard.label.fieldWidth = keyboard.width;
		keyboard.label.x = ((keyboard.width - keyboard.label.width) / 2) + keyboard.x;
		keyboard.label.offset.y = -10;
		keyboard.cameras = [ui];
		add(keyboard);

        changeSelection(0);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(FlxG.mouse.overlaps(leftArrow) && FlxG.mouse.justPressed)
        {
            changeSelection(-1);
        }
        else if (FlxG.mouse.overlaps(rightArrow) && FlxG.mouse.justPressed)
        {
            changeSelection(1);
        }
        trackbutton();
    }

    function changeSelection(change:Int = 0)
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = options.length - 1;
        if (curSelected >= options.length)
            curSelected = 0;

        grpControls.text = options[curSelected];
		grpControls.screenCenter(X);

		leftArrow.x = grpControls.x - 60;
		rightArrow.x = grpControls.x + grpControls.width + 10;

        buttonistouched = false;

        daChoice = options[Math.floor(curSelected)];

        switch (daChoice)
        {
            case 'Pad-Right':
                reset.visible = false;
                keyboard.visible = true;
                remove(vpad);
                vpad = new FlxVirtualPad(RIGHT_FULL, NONE, 0.75, true);
                add(vpad);
                loadcustom(false);
            case 'Pad-Left':
                reset.visible = false;
                keyboard.visible = true;
                remove(vpad);
                vpad = new FlxVirtualPad(FULL, NONE, 0.75, true);
                add(vpad);
                loadcustom(false);
            case 'Pad-Custom':
                reset.visible = true;
                keyboard.visible = false;
                remove(vpad);
                vpad = new FlxVirtualPad(RIGHT_FULL, controlExtend, 0.75, true);
                add(vpad);
                loadcustom(true);
            case 'Duo':
                reset.visible = false;
                keyboard.visible = true;
                remove(vpad);
                vpad = new FlxVirtualPad(DUO, NONE, 0.75, true);
                add(vpad);
                loadcustom(false);
            case 'Hitbox':
                reset.visible = false;
                keyboard.visible = true;
                vpad.alpha = 0;
            case 'Keyboard':
                reset.visible = false;
                keyboard.visible = true;
                remove(vpad);
                vpad.alpha = 0;
        }

        if (daChoice != "Hitbox")
        {
            hbox.visible = false;
            newhbox.visible = false;
        }
        else
        {
            newhbox.visible = true;
        }

        if (daChoice != "Pad-Custom")
        {
            upPozition.visible = false;
            downPozition.visible = false;
            leftPozition.visible = false;
            rightPozition.visible = false;
        }
        else
        {
            upPozition.visible = true;
            downPozition.visible = true;
            leftPozition.visible = true;
            rightPozition.visible = true;
        }
    }

    function trackbutton()
    {
        daChoice = options[Math.floor(curSelected)];

        if (daChoice == 'Pad-Custom')
        {
            if (buttonistouched)
            {
                if (bindbutton.justReleased && FlxG.mouse.justReleased)
                {
                    bindbutton = null;
                    buttonistouched = false;
                }
                else 
                {
                    movebutton(bindbutton);
                    setbuttontexts();
                }
            }
            else 
            {
                if (vpad.buttonUp.justPressed) {
                    movebutton(vpad.buttonUp);
                }

                if (vpad.buttonDown.justPressed) {
                    movebutton(vpad.buttonDown);
                }

                if (vpad.buttonRight.justPressed) {
                    movebutton(vpad.buttonRight);
                }

                if (vpad.buttonLeft.justPressed) {
                    movebutton(vpad.buttonLeft);
                }
            }
        }
    }

    function movebutton(button:UIButton)
    {
        button.x = FlxG.mouse.x - vpad.buttonUp.width / 2;
        button.y = FlxG.mouse.y - vpad.buttonUp.height / 2;
        bindbutton = button;
        buttonistouched = true;
    }

    function setbuttontexts()
    {
        upPozition.text = "Button Up X:" + vpad.buttonUp.x +" Y:" + vpad.buttonUp.y;
        downPozition.text = "Button Down X:" + vpad.buttonDown.x +" Y:" + vpad.buttonDown.y;
        leftPozition.text = "Button Left X:" + vpad.buttonLeft.x +" Y:" + vpad.buttonLeft.y;
        rightPozition.text = "Button Right x:" + vpad.buttonRight.x +" Y:" + vpad.buttonRight.y;
    }

    function save()
    {
        config.setcontrolmode(curSelected);
        daChoice = options[Math.floor(curSelected)];

        if (daChoice == 'Pad-Custom')
        {
            config.savecustom(vpad);
            extendConfig.savecustom(vpad);
        }
    }

    function loadcustom(needFix:Bool):Void
    {
        if (needFix)
        {
            vpad = config.loadcustom(vpad);	
            vpad = extendConfig.loadcustom(vpad);
        }
        else
        {
            vpad = extendConfig.loadcustom(vpad);
        }
    }
}