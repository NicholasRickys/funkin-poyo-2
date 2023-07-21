package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

using StringTools;

class Character extends FlxSprite {
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var barColor:FlxColor;

	public var holdTimer:Float = 0;

	public var camPos:Array<Float> = [130, 0];
	public var camZoom:Float = 1;

	public var maxHTimer:Float = 4;

	// FOR POYO LOL
	public var specialTransition:Bool = false;
	public var stunned:Bool = false;

	// for players bein on right side when they really a leftie
	public var nativelyPlayable:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false) {
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;
		antialiasing = true;

		switch (curCharacter) {
			case 'gf':
				frames = Paths.getSparrowAtlas('characters/GF_assets', 'shared');

				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);
				addOffset('scared', -2, -17);

				playAnim('danceRight');

				barColor = 0xFF;
			case 'whitty': // whitty reg (lofight,overhead)
				camZoom = 0.75;
				camPos = [300, -120];
				frames = Paths.getSparrowAtlas('WhittySprites', 'bonusWeek');
				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('singUP', 'Sing Up', 24);
				animation.addByPrefix('singRIGHT', 'Sing Right', 24);
				animation.addByPrefix('singDOWN', 'Sing Down', 24);
				animation.addByPrefix('singLEFT', 'Sing Left', 24);

				addOffset('idle', 0,0 );
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);
			case 'poyo':
				camZoom = 0.8;
				frames = Paths.getSparrowAtlas('characters/PoyoSprites', 'poyo');

				animation.addByPrefix('idle', 'poyo_boppin', 24, false);
				if (!isPlayer) {
					animation.addByPrefix('singLEFT', 'poyo_left', 24, false);
					animation.addByPrefix('singRIGHT', 'poyo_right', 24, false);
				} else {
					animation.addByPrefix('singRIGHT', 'poyo_left', 24, false);
					animation.addByPrefix('singLEFT', 'poyo_right', 24, false);
				}
				animation.addByPrefix('singDOWN', 'poyo_down', 24, false);
				animation.addByPrefix('singUP', 'poyo_up', 24, false);

				addOffset('idle');
				if (!isPlayer) {
					addOffset("singLEFT", 115, -10);
					addOffset("singRIGHT", -150, 18);
				} else {
					addOffset("singRIGHT", 115, -10);
					addOffset("singLEFT", -150, 18);
				}
				addOffset("singDOWN", 27, -20);
				addOffset("singUP", 30, 100);

				playAnim('idle');

				specialTransition = true;
				barColor = 0xFFCA5A6B;
				camPos = [200, -150];
			case 'nafri':
				frames = Paths.getSparrowAtlas('characters/nafri', 'nafri');

				animation.addByPrefix('idle', 'nafri Idle Dance', 15, false);
				if (!isPlayer) {
					animation.addByPrefix('singLEFT', 'nafri Sing Note LEFT', 15, false);
					animation.addByPrefix('singRIGHT', 'nafri Sing Note RIGHT', 15, false);
				} else {
					animation.addByPrefix('singRIGHT', 'nafri Sing Note LEFT', 15, false);
					animation.addByPrefix('singLEFT', 'nafri Sing Note RIGHT', 15, false);
				}
				animation.addByPrefix('singDOWN', 'nafri Sing Note DOWN', 15, false);
				animation.addByPrefix('singUP', 'nafri Sing Note UP', 15, false);

				addOffset('idle');
				addOffset('singLEFT');
				addOffset('singDOWN');
				addOffset('singUP');
				addOffset('singRIGHT');
				scale.set(0.7,0.7);
				updateHitbox();
			case 'bf':
				camZoom = 1;
				nativelyPlayable = true;
				frames = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				if (isPlayer) {
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singLEFT-miss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHT-miss', 'BF NOTE RIGHT MISS', 24, false);
				} else {
					animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singRIGHT-miss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singLEFT-miss', 'BF NOTE RIGHT MISS', 24, false);
				}
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUP-miss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singDOWN-miss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				if (isPlayer) {
					addOffset("singRIGHT", -38, -7);
					addOffset("singLEFT", 12, -6);
					addOffset("singRIGHT-miss", -30, 21);
					addOffset("singLEFT-miss", 12, 24);
				} else {
					addOffset("singLEFT", -38, -7);
					addOffset("singRIGHT", 12, -6);
					addOffset("singLEFT-miss", -30, 21);
					addOffset("singRIGHT-miss", 12, 24);
				}
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

				flipX = true;
				camPos = [200, -120];
				barColor = 0xFF31b0d1;
			case "banette":
				camZoom = 1;
				frames = Paths.getSparrowAtlas('characters/banette', 'rae');

				animation.addByPrefix('idle', 'banette Idle Dance', 15, false);
				animation.addByPrefix('singUP', 'banette Sing Note UP', 15, false);
				if (!isPlayer) {
					animation.addByPrefix('singLEFT', 'banette Sing Note LEFT', 15, false);
					animation.addByPrefix('singRIGHT', 'banette Sing Note RIGHT', 15, false);
				} else {
					animation.addByPrefix('singRIGHT', 'banette Sing Note LEFT', 15, false);
					animation.addByPrefix('singLEFT', 'banette Sing Note RIGHT', 15, false);
				}
				animation.addByPrefix('singDOWN', 'banette Sing Note DOWN', 15, false);
				// we just changed all the animations to fit the fps it was at
				// as we can see
				// it was sorta off center
				// and we HAAAATE off center
				// off to Stage.hx which can help us fix that bullshit

				addOffset('idle');
				addOffset('singLEFT');
				addOffset('singDOWN');
				addOffset('singUP');
				addOffset('singRIGHT');
				scale.set(0.7, 0.7);
				updateHitbox();
			case "rae":
				camZoom = 1;
				frames = Paths.getSparrowAtlas('characters/rae', 'rae');

				animation.addByPrefix('idle', 'rae Idle Dance', 15, false);
				animation.addByPrefix('singUP', 'rae Sing Note UP', 15, false);
				if (!isPlayer) {
					animation.addByPrefix('singLEFT', 'rae Sing Note LEFT', 15, false);
					animation.addByPrefix('singRIGHT', 'rae Sing Note RIGHT', 15, false);
				} else {
					animation.addByPrefix('singRIGHT', 'rae Sing Note LEFT', 15, false);
					animation.addByPrefix('singLEFT', 'rae Sing Note RIGHT', 15, false);
				}
				animation.addByPrefix('singDOWN', 'rae Sing Note DOWN', 15, false);
				// we just changed all the animations to fit the fps it was at
				// as we can see
				// it was sorta off center
				// and we HAAAATE off center
				// off to Stage.hx which can help us fix that bullshit

				addOffset('idle');
				addOffset('singLEFT');
				addOffset('singDOWN');
				addOffset('singUP');
				addOffset('singRIGHT');
				scale.set(0.8, 0.8);
				updateHitbox();
			case 'sarah':
				camZoom = 1;
				frames = Paths.getSparrowAtlas('characters/sarah', 'rae');

				animation.addByPrefix('idle', 'sarah Idle Dance', 15, false);
				animation.addByPrefix('singUP', 'sarah Sing Note UP', 15, false);
				if (!isPlayer) {
					animation.addByPrefix('singLEFT', 'sarah Sing Note LEFT', 15, false);
					animation.addByPrefix('singRIGHT', 'sarah Sing Note RIGHT', 15, false);
				} else {
					animation.addByPrefix('singRIGHT', 'sarah Sing Note LEFT', 15, false);
					animation.addByPrefix('singLEFT', 'sarah Sing Note RIGHT', 15, false);
				}
				animation.addByPrefix('singDOWN', 'sarah Sing Note DOWN', 15, false);
				// we just changed all the animations to fit the fps it was at
				// as we can see
				// it was sorta off center
				// and we HAAAATE off center
				// off to Stage.hx which can help us fix that bullshit

				addOffset('idle');
				addOffset('singLEFT');
				addOffset('singDOWN');
				addOffset('singUP');
				addOffset('singRIGHT');
				scale.set(0.6, 0.6);
				updateHitbox();
			default:
				if (!isPlayer)
				{
					curCharacter = 'poyo';
					camZoom = 0.8;
					frames = Paths.getSparrowAtlas('characters/PoyoSprites', 'poyo');

					animation.addByPrefix('idle', 'poyo_boppin', 24, false);
					if (!isPlayer) {
						animation.addByPrefix('singLEFT', 'poyo_left', 24, false);
						animation.addByPrefix('singRIGHT', 'poyo_right', 24, false);
					} else {
						animation.addByPrefix('singRIGHT', 'poyo_left', 24, false);
						animation.addByPrefix('singLEFT', 'poyo_right', 24, false);
					}
					animation.addByPrefix('singDOWN', 'poyo_down', 24, false);
					animation.addByPrefix('singUP', 'poyo_up', 24, false);

					addOffset('idle');
					if (!isPlayer) {
						addOffset("singLEFT", 115, -10);
						addOffset("singRIGHT", -150, 18);
					} else {
						addOffset("singRIGHT", 115, -10);
						addOffset("singLEFT", -150, 18);
					}
					addOffset("singDOWN", 27, -20);
					addOffset("singUP", 30, 100);

					playAnim('idle');

					specialTransition = true;
					barColor = 0xFFCA5A6B;
					camPos = [200, -150];
				}
				else
				{			
					camZoom = 1;
					nativelyPlayable = true;
					frames = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');

					animation.addByPrefix('idle', 'BF idle dance', 24, false);
					animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
					if (isPlayer) {
						animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
						animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
						animation.addByPrefix('singLEFT-miss', 'BF NOTE LEFT MISS', 24, false);
						animation.addByPrefix('singRIGHT-miss', 'BF NOTE RIGHT MISS', 24, false);
					} else {
						animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
						animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
						animation.addByPrefix('singRIGHT-miss', 'BF NOTE LEFT MISS', 24, false);
						animation.addByPrefix('singLEFT-miss', 'BF NOTE RIGHT MISS', 24, false);
					}
					animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
					animation.addByPrefix('singUP-miss', 'BF NOTE UP MISS', 24, false);
					animation.addByPrefix('singDOWN-miss', 'BF NOTE DOWN MISS', 24, false);
					animation.addByPrefix('hey', 'BF HEY', 24, false);

					animation.addByPrefix('firstDeath', "BF dies", 24, false);
					animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
					animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

					animation.addByPrefix('scared', 'BF idle shaking', 24);

					addOffset('idle', -5);
					addOffset("singUP", -29, 27);
					if (isPlayer) {
						addOffset("singRIGHT", -38, -7);
						addOffset("singLEFT", 12, -6);
						addOffset("singRIGHT-miss", -30, 21);
						addOffset("singLEFT-miss", 12, 24);
					} else {
						addOffset("singLEFT", -38, -7);
						addOffset("singRIGHT", 12, -6);
						addOffset("singLEFT-miss", -30, 21);
						addOffset("singRIGHT-miss", 12, 24);
					}
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", -29, 27);
					addOffset("singDOWNmiss", -11, -19);
					addOffset("hey", 7, 4);
					addOffset('firstDeath', 37, 11);
					addOffset('deathLoop', 37, 5);
					addOffset('deathConfirm', 37, 69);
					addOffset('scared', -4);

					playAnim('idle');

					flipX = true;
					camPos = [200, -120];
					barColor = 0xFF31b0d1;
				}
		}

		dance();

		if (isPlayer)
			flipX = !flipX;
	}

	override function update(elapsed:Float) {
		if (animation.curAnim != null) {
			holdTimer += elapsed;
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	public function dance() {
		switch (curCharacter) {
			case 'gf':
				if (!animation.curAnim.name.startsWith('hair')) {
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				}
			default:
				playAnim('idle');
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void {
		animation.play(AnimName, Force, Reversed, Frame);
		var offsetter:Int = 1;
		if ((nativelyPlayable && !isPlayer) || (!nativelyPlayable && isPlayer))
			offsetter = -1;

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName)) {
			offset.set(daOffset[0] * offsetter, daOffset[1]);
		} else
			offset.set(0, 0);

		if (curCharacter == 'gf') {
			if (AnimName == 'singLEFT') {
				danced = true;
			} else if (AnimName == 'singRIGHT') {
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN') {
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0) {
		animOffsets[name] = [x, y];
	}
}
