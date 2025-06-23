package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class StateTransitioner {
    public static function transitionTo(nextState:Class<FlxState>, ?duration:Float = 0.7, ?color:Int = 0xFF000000) {
        var cam = FlxG.camera;
        var overlay = new FlxSprite(0, 0);
        overlay.makeGraphic(FlxG.width, FlxG.height, color);
        overlay.alpha = 0;
        overlay.scrollFactor.set(0, 0);
        FlxG.state.add(overlay);
        // Only do zoom-in and fade-in, then switch state
        FlxTween.tween(cam, { zoom: 1.3 }, duration, {
            ease: FlxEase.cubeIn,
            onUpdate: function(_) {
                overlay.alpha = Math.min(1, overlay.alpha + (1 / (duration * 60)));
            },
            onComplete: function(_) {
                cam.zoom = 1; // Reset zoom for new state
                FlxG.state.remove(overlay, true);
                FlxG.switchState(Type.createInstance(nextState, []));
            }
        });
    }
}
