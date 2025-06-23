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
import StateTransitioner;
import flixel.sound.FlxSound;

class MainMenuState extends FlxState {
    private var title:FlxText;
    private var menuItems:Array<FlxText>;
    private var selectionIndex:Int = 0;
    private var menuOptions:Array<String> = ["New Game", "Options", "Extras"];
    private var backgroundmenu:FlxSprite;
    private var cam:FlxCamera;
    private var music:FlxSound;
    private var lastBeatTime:Float = 0;
    private var beatInterval:Float = 0.5; // Default, will try to auto-detect
    private var menuBop:Float = 0;
    public static inline var FONT:String = "assets/fonts/vcr.ttf";

    // Add orbPointer as a class variable
    private var orbPointer:FlxSprite;

    override public function create():Void {
        super.create();

        // Camera setup for smooth pan-in and zoom
        cam = new FlxCamera();
        cam.bgColor = 0xFF000000;
        cam.zoom = 1.15;
        FlxG.cameras.reset(cam);
        cam.scroll.set(-FlxG.width, 0); // Start off-screen left
        FlxTween.tween(cam.scroll, { x: 0 }, 1.2, { ease: FlxEase.cubeOut });

        // Background
        backgroundmenu = new FlxSprite(0, 0);
        if (openfl.Assets.exists("assets/images/titlescreen/titlescreenbg.png")) {
            backgroundmenu.loadGraphic("assets/images/titlescreen/titlescreenbg.png");
        } else {
            backgroundmenu.makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
        }
        // Make background image fill the screen, always anchored to (0,0)
        backgroundmenu.scale.set(1, 1);
        backgroundmenu.setGraphicSize(FlxG.width, FlxG.height);
        backgroundmenu.x = 0;
        backgroundmenu.y = 0;
        backgroundmenu.updateHitbox();
        backgroundmenu.scrollFactor.set(0, 0);
        backgroundmenu.alpha = 0;
        add(backgroundmenu);
        FlxTween.tween(backgroundmenu, { alpha: 1 }, 1, { startDelay: 0.2 });

        // Fancy rotated black rectangle behind menu items
        var menuBG = new FlxSprite(FlxG.width * 0.57, 120);
        menuBG.makeGraphic(Math.ceil(FlxG.width * 0.41), 320, FlxColor.BLACK);
        menuBG.alpha = 0;
        menuBG.angle = -7;
        menuBG.scrollFactor.set(0, 0);
        add(menuBG);
        // Tween in: fade and slide from right
        menuBG.x += 80;
        FlxTween.tween(menuBG, { alpha: 0.7, x: menuBG.x - 80 }, 0.7, { startDelay: 0.9, ease: FlxEase.cubeOut });

        // Title text (above menu, right side)
        title = new FlxText(FlxG.width * 0.6, 80, FlxG.width * 0.35, "Untitled RPG Game");
        title.setFormat(null, 48, FlxColor.WHITE, "center");
        title.alpha = 0;
        add(title);
        FlxTween.tween(title, { alpha: 1 }, 0.7, { startDelay: 1.0, ease: FlxEase.quadOut });

        // Character at bottom left
        var character = new FlxSprite(0, FlxG.height - 384);
        if (openfl.Assets.exists("assets/images/titlescreen/character.png")) {
            character.loadGraphic("assets/images/titlescreen/character.png");
        } else {
            character.makeGraphic(384, 384, FlxColor.RED);
        }
        character.setGraphicSize(384, 384);
        character.updateHitbox();
        character.scrollFactor.set(0, 0);
        character.alpha = 0;
        add(character);
        FlxTween.tween(character, { alpha: 1 }, 1, { startDelay: 1.0, ease: FlxEase.quadOut });

        // Menu items (right side) with orb pointer only (no buttonBGs)
        menuItems = [];
        orbPointer = new FlxSprite(0, 0);
        orbPointer.makeGraphic(32, 32, FlxColor.YELLOW);
        orbPointer.scrollFactor.set(0, 0);
        orbPointer.alpha = 0;
        orbPointer.setGraphicSize(24, 24);
        add(orbPointer);
        FlxTween.tween(orbPointer, { alpha: 1 }, 0.7, { startDelay: 1.2, ease: FlxEase.cubeOut });
        for (i in 0...menuOptions.length) {
            var item = new FlxText(
                FlxG.width * 0.6,
                180 + i * 64,
                FlxG.width * 0.35,
                menuOptions[i]
            );
            item.setFormat(null, 32, FlxColor.GRAY, "center");
            item.alpha = 0;
            item.x += 40;
            add(item);
            menuItems.push(item);
            FlxTween.tween(item, { alpha: 1, x: item.x - 40 }, 0.6, { startDelay: 1.2 + i * 0.15, ease: FlxEase.cubeOut });
        }
        updateSelection();

        // Play menu music
        music = FlxG.sound.load("assets/music/yourend.mp3", 1, true, true);
        music.play();
        // BPM is 200, but song feels slower, so use half-time (100 BPM)
        beatInterval = 60 / 100; // 0.6s per beat (half of 200 BPM)
        lastBeatTime = music.time / 1000; // seconds
        menuBop = 0;
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

        // Softly move background with menu selection
        var targetY = 0.0 + (selectionIndex * 10); // Adjust 10 for more/less movement
        backgroundmenu.y += (targetY - backgroundmenu.y) * 0.08;

        // Beat detection (simple: fixed interval, or tap to set BPM)
        var curTime = music.time / 1000; // seconds
        if (curTime - lastBeatTime >= beatInterval) {
            lastBeatTime += beatInterval;
            menuBop = 1;
        }
        // Smoothly decay bop
        menuBop *= 0.85;
        // Apply bop to menuBG and menu items only
        var menuBG = null;
        for (sprite in members) if (Std.isOfType(sprite, FlxSprite) && sprite != backgroundmenu) menuBG = cast sprite;
        if (menuBG != null) {
            menuBG.scale.y = 1 + 0.04 * menuBop;
            menuBG.scale.x = 1 - 0.01 * menuBop;
        }
        // Bop menu items
        for (item in menuItems) {
            item.scale.y = 1 + 0.04 * menuBop;
            item.scale.x = 1 - 0.01 * menuBop;
        }
    }

    // updateSelection as a normal method
    private function updateSelection():Void {
        for (i in 0...menuItems.length) {
            if (i == selectionIndex) {
                menuItems[i].setFormat(null, 32, FlxColor.WHITE, "center");
                orbPointer.x = menuItems[i].x - 36;
                orbPointer.y = menuItems[i].y + 8;
                orbPointer.visible = true;
            } else {
                menuItems[i].setFormat(null, 32, FlxColor.GRAY, "center");
            }
        }
    }

    private function activateOption():Void {
        switch (selectionIndex) {
            case 0:
                StateTransitioner.transitionTo(PlayState);
            case 1:
                StateTransitioner.transitionTo(OptionsState);
            case 2:
                trace("Extra selected");
        }
    }
}