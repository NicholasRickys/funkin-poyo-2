package;

import Controls.Device;
import lime.ui.Gamepad;
import Controls.Control;
import Character;
import sys.io.File;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class DialogueBox extends MusicBeatSubstate {
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = ['bf:test', 'dad:breh'];

	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:Character;
	var portraitRight:Character;

	var bgFade:FlxSprite;

	public function new(bfName:String = 'poyo', dadName:String = 'poyo', gfName:String = 'poyo') {
		super();

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFF000000);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		FlxTween.tween(bgFade, {alpha: 0.5}, 0.83);

		box = new FlxSprite(0, FlxG.height / 2).makeGraphic(Std.int(FlxG.width), Std.int(FlxG.height / 2), 0xFF000000);

		portraitLeft = new Character(40, FlxG.height / 2 - 100, dadName);
		portraitLeft.scrollFactor.set();
		portraitLeft.screenCenter(Y);
		add(portraitLeft);

		portraitRight = new Character(FlxG.width - 40, FlxG.height / 2 - 100, bfName);
		portraitRight.scrollFactor.set();
		portraitRight.x -= portraitLeft.width;
		portraitRight.screenCenter(Y);
		add(portraitRight);

		add(box);

		portraitLeft.dance();
		portraitRight.dance();

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'PhantomMuff 1.5';
		swagDialogue.color = 0xFFFFFFFF;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float) {
		if (dialogueOpened && !dialogueStarted) {
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.BACK)
			stopDialogue();

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
			continueDialogue();

		for (touch in FlxG.touches.list) {
			if (touch.justPressed)
				continueDialogue();
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function continueDialogue() {
		remove(dialogue);
				
		FlxG.sound.play(Paths.sound('clickText'), 0.8);

		if (dialogueList[1] == null && dialogueList[0] != null) {
			if (!isEnding) {
				isEnding = true;

				new FlxTimer().start(0.2, function(tmr:FlxTimer) {
					box.alpha -= 1 / 5;
					bgFade.alpha -= 1 / 5 * 0.7;
					portraitLeft.visible = false;
					portraitRight.visible = false;
					swagDialogue.alpha -= 1 / 5;
				}, 5);

				new FlxTimer().start(1.2, function(tmr:FlxTimer) {
					finishThing();
					kill();
				});
			}
		} else {
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}
	}

	function stopDialogue()  {
		remove(dialogue);

		if (!isEnding) {
			isEnding = true;

			new FlxTimer().start(0.2, function(tmr:FlxTimer) {
				box.alpha -= 1 / 5;
				bgFade.alpha -= 1 / 5 * 0.7;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				swagDialogue.alpha -= 1 / 5;
				dropText.alpha = swagDialogue.alpha;
			}, 5);

			new FlxTimer().start(1.2, function(tmr:FlxTimer) {
				finishThing();
				kill();
			});
		}
	}

	function startDialogue():Void {
		cleanDialog();
        
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter) {
			case 'dad':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitLeft.visible) {
					swagDialogue.color = FlxColor.RED;

					portraitLeft.frames = Paths.getSparrowAtlas('dialogue/dadDialogue', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'Dialogue Enter', 24, false);
					portraitLeft.screenCenter(X);

					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitRight.visible) {
					swagDialogue.color = FlxColor.BLUE;
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'gf':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitLeft.visible) {
					swagDialogue.color = FlxColor.RED;

					portraitLeft.frames = Paths.getSparrowAtlas('dialogue/gfDialogue', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'Dialogue Enter', 24, false);
					portraitLeft.screenCenter(X);

					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void {
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[0];
		dialogueList[0] = splitName[1];
	}
}