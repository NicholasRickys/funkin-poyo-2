package;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import PlayState;

class Stage extends FlxTypedGroup<FlxSprite> {
	public var curStage:String = 'stage';
	public var BF_COORDS = [0,0];
	public var GF_COORDS = [0,0];
	public var DAD_COORDS = [0,0];
	public var VISIBLE_GF = true;
	public function new(stageName:String) {
		super();
		switch (stageName) {
			case 'alley':
				var bg:FlxSprite = new FlxSprite(-450, -300).loadGraphic(Paths.image('whittyBack', 'bonusWeek'));
				bg.scrollFactor.set(0.6, 1);
				var fg:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('whittyFront', 'bonusWeek'));
				add(bg);
				add(fg);

				DAD_COORDS[0] = -40;
				DAD_COORDS[1] = -5;
				BF_COORDS[0] = 710;
				BF_COORDS[1] = 100;
				VISIBLE_GF = false;
			case 'moneyscircle':
				var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('week2bg', 'poyo'));
				bg.antialiasing = true;
				add(bg);
				PlayState.instance.cameraZoom = 0.8;
				BF_COORDS[0] = 1631;
				BF_COORDS[1] = 1031;
				DAD_COORDS[0] = 690;
				DAD_COORDS[1] = 1031;
				VISIBLE_GF = false;
			default:
				var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bg', 'poyo'));
				bg.antialiasing = true;
				add(bg);
				BF_COORDS[0] = 1480;
				BF_COORDS[1] = 500;
				DAD_COORDS[0] = 700;
				DAD_COORDS[1] = 240;
				GF_COORDS[0] = 919;
				GF_COORDS[1] = 200;
		}
		curStage = stageName;
	}

	public function returnStageXYWH() {
		var width:Float = 0;
		var height:Float = 0;
		var x:Float = 0;
		var y:Float = 0;
		forEachAlive(function(spr:FlxSprite) {
			if (spr.x < x) x = spr.x;
			if (spr.y < y) y = spr.y;
			if (spr.width > width) width = spr.width;
			if (spr.height > height) height = spr.height;
		});
		return [x, y, width, height];
	}
}