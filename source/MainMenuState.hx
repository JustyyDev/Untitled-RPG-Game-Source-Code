package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxCamera;
import PlayState;
import OptionsState;

class MainMenuState extends FlxState {
    private var character:FlxSprite;
    private var title:FlxText;
    private var menuItems:Array<FlxText>;
    private var selectionIndex:Int = 0;
    private var menuOptions:Array<String> = ["New Game", "Options", "Extras"];
    private var backgroundmenu:FlxSprite;
    private var cam:FlxCamera;

    override public function create():Void {
        super.create();

        // Camera setup for smooth pan-in
        cam = new FlxCamera();
        cam.bgColor = 0xFF000000;
        FlxG.cameras.reset(cam);
        cam.scroll.set(-FlxG.width, 0); // Start off-screen left
        FlxTween.tween(cam.scroll, { x: 0 }, 1.2, { ease: FlxEase.cubeOut });

        // Background
        backgroundmenu = new FlxSprite(0, 0);
        backgroundmenu.loadGraphic("assets/images/titlescreen/titlescreenbg.png");
        backgroundmenu.scrollFactor.set(0, 0);
        backgroundmenu.antialiasing = true;
        backgroundmenu.setGraphicSize(FlxG.width, FlxG.height);
        backgroundmenu.updateHitbox();
        backgroundmenu.alpha = 0;
        add(backgroundmenu);
        FlxTween.tween(backgroundmenu, { alpha: 1 }, 1, { startDelay: 0.2 });

        // Character art
        character = new FlxSprite(50, FlxG.height / 2 - 100);
        character.loadGraphic("assets/images/titlescreen/character.png");
        character.scrollFactor.set(0, 0);
        character.antialiasing = true;
        character.setGraphicSize(200, 200);
        character.updateHitbox();
        character.alpha = 0;
        character.y += 40;
        add(character);
        FlxTween.tween(character, { alpha: 1, y: character.y - 40 }, 0.8, { startDelay: 0.5, ease: FlxEase.quadOut });

        // Title text
        title = new FlxText(20, 20, FlxG.width, "Untitled");
        title.setFormat(null, 48, FlxColor.WHITE, "left");
        title.alpha = 0;
        title.y -= 30;
        add(title);
        FlxTween.tween(title, { alpha: 1, y: title.y + 30 }, 0.7, { startDelay: 0.7, ease: FlxEase.quadOut });

        // Menu items
        menuItems = [];
        for (i in 0...menuOptions.length) {
            var item = new FlxText(
                FlxG.width * 0.6,
                150 + i * 40,
                FlxG.width * 0.4,
                menuOptions[i]
            );
            item.setFormat(null, 24, FlxColor.GRAY, "left");
            item.alpha = 0;
            item.x += 40;
            add(item);
            menuItems.push(item);
            // Staggered fade-in
            FlxTween.tween(item, { alpha: 1, x: item.x - 40 }, 0.6, { startDelay: 1 + i * 0.15, ease: FlxEase.quadOut });
        }
        updateSelection();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Menu navigation
        if (FlxG.keys.justPressed.UP) {
            selectionIndex = (selectionIndex - 1 + menuItems.length) % menuItems.length;
            updateSelection();
        }
        if (FlxG.keys.justPressed.DOWN) {
            selectionIndex = (selectionIndex + 1) % menuItems.length;
            updateSelection();
        }
        if (FlxG.keys.justPressed.ENTER) {
            activateOption();
        }
    }

    private function updateSelection():Void {
        for (i in 0...menuItems.length) {
            if (i == selectionIndex) {
                menuItems[i].setFormat(null, 24, FlxColor.WHITE, "left");
                FlxTween.tween(menuItems[i], { x: FlxG.width * 0.6 - 10 }, 0.15, { type: FlxTweenType.ONESHOT, ease: FlxEase.cubeOut });
            } else {
                menuItems[i].setFormat(null, 24, FlxColor.GRAY, "left");
                FlxTween.tween(menuItems[i], { x: FlxG.width * 0.6 }, 0.15, { type: FlxTweenType.ONESHOT, ease: FlxEase.cubeOut });
            }
        }
    }

    private function activateOption():Void {
        switch (selectionIndex) {
            case 0:
                FlxG.switchState(new PlayState())   ;
            case 1:
                FlxG.switchState(new OptionsState());
            case 2:
                trace("Extra selected");
        }
    }
}