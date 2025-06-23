package;

import backend.GameData;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import MainMenuState;
import StateTransitioner;

class OptionsState extends FlxState {
    var bg:FlxSprite;
    var title:FlxText;
    var menuItems:Array<FlxText>;
    var selectionIndex:Int = 0;
    var menuOptions:Array<String> = ["Music Volume", "SFX Volume", "Fullscreen", "Reset Save", "Back"];
    var values:Array<String>;

    override public function create():Void {
        super.create();
        GameData.load();
        values = [
            Std.string(Math.round(GameData.data.preferences.musicVolume * 100)) + "%",
            Std.string(Math.round(GameData.data.preferences.sfxVolume * 100)) + "%",
            GameData.data.preferences.fullscreen ? "On" : "Off",
            "",
            ""
        ];
        // Background
        bg = new FlxSprite(0, 0);
        bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(20, 20, 40));
        add(bg);
        // Title
        title = new FlxText(0, 40, FlxG.width, "Options");
        title.setFormat(null, 32, FlxColor.WHITE, "center");
        title.alpha = 0;
        title.y -= 30;
        add(title);
        FlxTween.tween(title, { alpha: 1, y: title.y + 30 }, 0.7, { ease: FlxEase.quadOut });
        // Menu items
        menuItems = [];
        for (i in 0...menuOptions.length) {
            var label = menuOptions[i] + (values[i] != "" ? ": " + values[i] : "");
            var item = new FlxText(FlxG.width * 0.2, 120 + i * 40, FlxG.width * 0.6, label);
            item.setFormat(null, 24, FlxColor.GRAY, "center");
            item.alpha = 0;
            item.x += 40;
            add(item);
            menuItems.push(item);
            FlxTween.tween(item, { alpha: 1, x: item.x - 40 }, 0.6, { startDelay: 0.3 + i * 0.12, ease: FlxEase.quadOut });
        }
        updateSelection();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (FlxG.keys.justPressed.UP) {
            selectionIndex = (selectionIndex - 1 + menuItems.length) % menuItems.length;
            updateSelection();
        }
        if (FlxG.keys.justPressed.DOWN) {
            selectionIndex = (selectionIndex + 1) % menuItems.length;
            updateSelection();
        }
        if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT) {
            handleAdjust(FlxG.keys.justPressed.RIGHT ? 1 : -1);
        }
        if (FlxG.keys.justPressed.ENTER) {
            activateOption();
        }
    }

    function updateSelection():Void {
        for (i in 0...menuItems.length) {
            if (i == selectionIndex) {
                menuItems[i].setFormat(null, 24, FlxColor.WHITE, "center");
            } else {
                menuItems[i].setFormat(null, 24, FlxColor.GRAY, "center");
            }
        }
    }

    function handleAdjust(dir:Int):Void {
        switch (selectionIndex) {
            case 0: // Music Volume
                var v = GameData.data.preferences.musicVolume + dir * 0.05;
                v = Math.max(0, Math.min(1, v));
                GameData.data.preferences.musicVolume = v;
                values[0] = Std.string(Math.round(v * 100)) + "%";
                menuItems[0].text = menuOptions[0] + ": " + values[0];
                GameData.saveData();
            case 1: // SFX Volume
                var v = GameData.data.preferences.sfxVolume + dir * 0.05;
                v = Math.max(0, Math.min(1, v));
                GameData.data.preferences.sfxVolume = v;
                values[1] = Std.string(Math.round(v * 100)) + "%";
                menuItems[1].text = menuOptions[1] + ": " + values[1];
                GameData.saveData();
            case 2: // Fullscreen
                if (dir != 0) {
                    GameData.data.preferences.fullscreen = !GameData.data.preferences.fullscreen;
                    values[2] = GameData.data.preferences.fullscreen ? "On" : "Off";
                    menuItems[2].text = menuOptions[2] + ": " + values[2];
                    GameData.saveData();
                }
            default:
        }
    }

    function activateOption():Void {
        switch (selectionIndex) {
            case 3: // Reset Save
                GameData.reset();
                for (i in 0...3) handleAdjust(0); // Refresh values
            case 4: // Back
                StateTransitioner.transitionTo(MainMenuState);
        }
    }
}