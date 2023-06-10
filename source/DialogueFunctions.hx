package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;

class DialogueFunctions {
	var diagText:FlxText;
	public final function newDiag(diag:String, cam:FlxCamera) {
		if (diagText == null) {
			diagText = new FlxText(FlxG.width / 2, FlxG.height - 32, 0, 'test');
			add(diagText);
			diagText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			diagText.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		} else {
			diagText.text = 'test 2';
		}
	}
}