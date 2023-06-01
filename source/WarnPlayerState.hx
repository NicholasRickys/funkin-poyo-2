package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

class WarnPlayerState extends FlxState {
	var warningText:FlxText;
	var warningStr:String = "If you are prone to elipesy, VS Poyo Ultimate has a high chance to trigger seizures.\nWe don't have anyway to disable this as of right now.\nYou have been warned!";

	function create() {
		warningText = new FlxText(0,0,0,warningStr,FlxG.width);
		warningText.screenCenter();
	
		warningText.alpha = 0;
		warningText.alignment = FlxTextAlign.CENTER;
	
		add(warningText);
	
		FlxTween.tween(warningText, {alpha: 1}, 0.5, {
			onComplete: function() {
				new FlxTimer().start(5, ()->{
					FlxTween.tween(warningText, {alpha: 1}, 0.5, function() {
						onComplete: function() {
							FlxG.switchState(TitleState);
						}
					});
				});
			}
		});
	}
}