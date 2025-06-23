package backend;

import flixel.util.FlxSave;

class GameData {
    public static var saveKey:String = "untitled_rpg_save";
    public static var save:FlxSave = new FlxSave();
    public static var data:Dynamic = {
        keybinds: {
            up: "UP",
            down: "DOWN",
            left: "LEFT",
            right: "RIGHT",
            action: "Z",
            menu: "X"
        },
        preferences: {
            musicVolume: 1.0,
            sfxVolume: 1.0,
            fullscreen: false
        },
        progress: {
            lastMap: "start",
            playerX: 32,
            playerY: 32
        }
    };

    public static function saveData() {
        save.bind(saveKey);
        for (field in Reflect.fields(data)) {
            Reflect.setField(save.data, field, Reflect.field(data, field));
        }
        save.flush();
    }

    public static function load() {
        save.bind(saveKey);
        if (save.data != null) {
            data = save.data;
        }
    }

    public static function reset() {
        save.bind(saveKey);
        save.erase();
        data = {
            keybinds: {
                up: "UP",
                down: "DOWN",
                left: "LEFT",
                right: "RIGHT",
                action: "Z",
                menu: "X"
            },
            preferences: {
                musicVolume: 1.0,
                sfxVolume: 1.0,
                fullscreen: false
            },
            progress: {
                lastMap: "start",
                playerX: 32,
                playerY: 32
            }
        };
        saveData();
    }
}
