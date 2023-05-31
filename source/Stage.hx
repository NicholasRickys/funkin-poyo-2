package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.math.FlxMath;

class Stage extends FlxSpriteGroup {
	public var curStage:String = 'stage';
	public var BF_COORDS = [0,0];
	public var GF_COORDS = [0,0];
	public var DAD_COORDS = [0,0];
	public var VISIBLE_GF = true;
	public function new(stageName:String) {
		super();
		switch (stageName) {
			case 'moneyscircle':
				var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bg', 'nafri'));
				bg.antialiasing = true;
				add(bg);
				PlayState.instance.cameraZoom = 0.8
				BF_COORDS[0] = 1631;
				BF_COORDS[1] = 1031;
				DAD_COORDS[0] = 690;
				DAD_COORDS[1] = 1029;
				GF_COORDS[0] = 0;
				GF_COORDS[1] = 0;
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
		curStage = stagename;
	}

	public function returnStageXYWH() {
		var width:Float = 0;
		var height:Float = 0;
		var x:Float = 0;
		var y:Float = 0;
		forEachAlive(function(spr:FlxSprite) {
			if (spr.x > x) x = spr.x;
			if (spr.y > y) y = spr.y;
			if (spr.width > width) width = spr.width;
			if (spr.height > height) height = spr.height;
		});
		return [x, y, width, height];
	}
}