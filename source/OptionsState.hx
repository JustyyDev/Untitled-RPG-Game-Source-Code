package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import MainMenuState;

class OptionsState extends FlxState {
	var bg:FlxSprite;

    override public function create():Void {
        super.create();
        
        // -- Background graphic --
        bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(20, 20, 40));
        add(bg);

        // Title
        var title = new FlxText(0, 40, FlxG.width, "Options");
        title.setFormat(null, 32, FlxColor.WHITE, "center");
        add(title);

        // Example option: Toggle Music
        var musicToggle = new FlxText(0, 120, FlxG.width, "Music: On");
        musicToggle.setFormat(null, 24, FlxColor.GRAY, "center");
        add(musicToggle);

        // Back button
        var backButton = new FlxButton(
            FlxG.width/2 - 40,
            FlxG.height - 100,
            "Back",
            onBack
        );
        add(backButton);
    }

    private function onBack():Void {
        FlxG.switchState(new MainMenuState());
    }
}