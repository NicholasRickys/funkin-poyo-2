package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class WarnPlayerState extends FlxState {
	var warningText:FlxText;
	// i know it says in honor of beans but we found out beans survived his offing
	// hes in a coma
	// but uhhhh he will be back soon!!!!!
	// hooraY!!!
	var warningStr:String = "In honor of Beans, a member who offed himself half a year ago.\n\nIf you are prone to elipesy,\nVS Poyo Ultimate has a high chance to trigger seizures.\nWe don't have anyway to disable this as of right now.\nYou have been warned!";
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