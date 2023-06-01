package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

class WarnPlayerState extends FlxState {
	var warningText:FlxText;
	var warningStr:String = "If you are prone to elipesy, VS Poyo Ultimate has a high chance to trigger seizures.\nWe don't have anyway to disable this as of right now.\nYou have been warned!";

	override function create() {
		warningText = new FlxText(0,0,0,warningStr,FlxG.width);
		warningText.screenCenter();
	
		warningText.alpha = 0;
		warningText.alignment = FlxTextAlign.CENTER;
	
		add(warningText);
	
		FlxTween.tween(warningText, {alpha: 1}, 0.5, {
			onComplete: function(tween:FlxTween) {
				new FlxTimer().start(4, ()->{
					FlxTween.tween(warningText, {alpha: 0}, 0.5, {
						onComplete: function(tween:FlxTween) {
							FlxG.switchState(new TitleState());
						}
					});
				});
			}
		});
	}
}