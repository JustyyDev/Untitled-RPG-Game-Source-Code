package;

import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxGroup;
import StateTransitioner;

class PlayState extends FlxState {
	var tilemap:FlxTilemap;
	var collisionMap:FlxTilemap;
	var player:FlxSprite;
	var npcs:FlxGroup;
	var playerSpeed:Float = 60;

	override public function create() {
		super.create();

		// Simple generated tilemap (10x10, 16x16 tiles)
		tilemap = new FlxTilemap();
		var mapData = [];
		for (i in 0...10) {
			var row = [];
			for (j in 0...10) {
				row.push((i == 0 || j == 0 || i == 9 || j == 9) ? 1 : 0); // Border walls
			}
			mapData.push(row.join(","));
		}
		tilemap.loadMapFromCSV(mapData.join("\n"), null, 16, 16);
		add(tilemap);

		// Collision map (same as tilemap, but invisible)
		collisionMap = new FlxTilemap();
		collisionMap.loadMapFromCSV(mapData.join("\n"), null, 16, 16);
		collisionMap.visible = false;
		add(collisionMap);

		// Player (red square)
		player = new FlxSprite(32, 32);
		player.makeGraphic(16, 16, FlxColor.RED);
		add(player);

		// Sample NPC (blue square)
		npcs = new FlxGroup();
		var npc = new FlxSprite(80, 80);
		npc.makeGraphic(16, 16, FlxColor.BLUE);
		npcs.add(npc);
		add(npcs);

		FlxG.camera.follow(player);
		FlxG.camera.setScrollBounds(0, 0, tilemap.width, tilemap.height);
		FlxG.camera.deadzone.set(FlxG.width/4, FlxG.height/4, FlxG.width/2, FlxG.height/2);
		FlxG.camera.scroll.set(0, 0);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		var moveX = 0;
		var moveY = 0;
		if (FlxG.keys.pressed.LEFT) moveX -= 1;
		if (FlxG.keys.pressed.RIGHT) moveX += 1;
		if (FlxG.keys.pressed.UP) moveY -= 1;
		if (FlxG.keys.pressed.DOWN) moveY += 1;
		var len = Math.sqrt(moveX * moveX + moveY * moveY);
		if (len > 0) {
			var normX = moveX / len;
			var normY = moveY / len;
			player.velocity.x = normX * playerSpeed;
			player.velocity.y = normY * playerSpeed;
		} else {
			player.velocity.set(0, 0);
		}
		FlxG.collide(player, collisionMap);
		FlxG.collide(player, npcs);
	}
}