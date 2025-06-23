package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import PlayState;
import OptionsState;

class MainMenuState extends FlxState {
    private var character:FlxSprite;
    private var title:FlxText;
    private var menuItems:Array<FlxText>;
    private var selectionIndex:Int = 0;
    private var menuOptions:Array<String> = ["New Game", "Options", "Extras"];

    var backgroundmenu:FlxSprite;

    override public function create():Void {
        super.create();

        // actual background
        backgroundmenu = new FlxSprite(0, 0);
        backgroundmenu.loadGraphic("assets/images/titlescreen/background.png");
        backgroundmenu.scrollFactor.set(0, 0);
        backgroundmenu.antialiasing = true; // Optional: for better quality
        backgroundmenu.setGraphicSize(FlxG.width, FlxG.height); // Resize
        backgroundmenu.updateHitbox();
        add(backgroundmenu);

        // -- Character art on the left (stub for your asset) --
        character = new FlxSprite(50, FlxG.height / 2 - 100);
        character.loadGraphic("assets/images/titlescreen/character.png");
        character.scrollFactor.set(0, 0);
        character.antialiasing = true; // Optional: for better quality
        character.setGraphicSize(200, 200); // Resize to fit the menu
        character.updateHitbox();
        add(character);

        // -- Title text --
        title = new FlxText(20, 20, FlxG.width, "Untitled");
        title.setFormat(null, 48, FlxColor.WHITE, "left");
        add(title);

        // -- Menu items --
        menuItems = [];
        for (i in 0...menuOptions.length) {
            var item = new FlxText(
                FlxG.width * 0.6,
                150 + i * 40,
                FlxG.width * 0.4,
                menuOptions[i]
            );
            item.setFormat(null, 24, FlxColor.GRAY, "left");
            menuItems.push(item);
            add(item);
        }
        updateSelection();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Navigate menu
        if (FlxG.keys.justPressed.UP) {
            selectionIndex = (selectionIndex - 1 + menuItems.length) % menuItems.length;
            updateSelection();
        }
        if (FlxG.keys.justPressed.DOWN) {
            selectionIndex = (selectionIndex + 1) % menuItems.length;
            updateSelection();
        }
        // Confirm
        if (FlxG.keys.justPressed.ENTER) {
            activateOption();
        }
    }

    private function updateSelection():Void {
        for (i in 0...menuItems.length) {
            if (i == selectionIndex) {
                menuItems[i].setFormat(null, 24, FlxColor.WHITE, "left");
            } else {
                menuItems[i].setFormat(null, 24, FlxColor.GRAY, "left");
            }
        }
    }

    private function activateOption():Void {
        switch (selectionIndex) {
            case 0: // New Game
                FlxG.switchState(new PlayState());
            case 1: // Options
                FlxG.switchState(new OptionsState());
            case 2: // Extra
                trace("Extra selected");
        }
    }
}