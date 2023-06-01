package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class WarnPlayerState extends FlxState {
	var warningText:FlxText;
	var warningStr:String = "In honor of Beans\n\nIf you are prone to elipesy, VS Poyo Ultimate has a high chance to trigger seizures.\nWe don't have anyway to disable this as of right now.\nYou have been warned!";
	var letsWait:FlxTimer;

	override function create() {
		warningText = new FlxText(0,0,0,warningStr,FlxG.width);
	
		warningText.alignment = FlxTextAlign.CENTER;
		warningText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(warningText);
		warningText.screenCenter();

		letsWait = new FlxTimer().start(5, function(tmr:FlxTimer):Void {
			FlxG.switchState(new TitleState());
		});
	}
}