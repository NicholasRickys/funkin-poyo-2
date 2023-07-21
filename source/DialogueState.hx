package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import Character;
import Paths;

class DialogueState extends MusicBeatState
{
    //constants for me!
    static inline final POYO = 0;
    static inline final BF = 1;
    static inline final NOBODY = -1;

    var background:FlxBackdrop;
    var dialoguebox:FlxSprite;
    var textbox:FlxText;
    public var isDone:Bool = false;
    public var currentLine:Int = -1;
    public var charsInDiag:Array<Character> = [];
    public static var song:String = 'Summer-Sunset';
    public static var returnToMainMenu:Bool = false;
    public var dialogue:Array<Array<Dynamic>> = [];

    var WEEK1CHARS:Array<String> = ['summer-sunset', 'energizer', 'epic'];

    override public function create()
    {
        transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

        persistentDraw = persistentUpdate = true;

        background = new FlxBackdrop();
        background.loadGraphic(Paths.image('DIALOGUELOL', 'shared'));
        background.velocity.x = 32;
        background.velocity.y = 32;
        add(background);

        if (WEEK1CHARS.contains(song.toLowerCase()))
        {
            charsInDiag[POYO] = new Character(16, (FlxG.height / 2) - 300, 'poyo', false);
            charsInDiag[BF] = new Character(FlxG.width - 400, (FlxG.height / 2) - 300, 'bf', false);
            charsInDiag[BF].flipX = false;
        };

        for (char in charsInDiag)
        {
            add(char);
        }
    
        dialoguebox = new FlxSprite(0, FlxG.height / 2);
        dialoguebox.makeGraphic(FlxG.width, Std.int(FlxG.height / 2), 0xFF565656);
        add(dialoguebox);

        textbox = new FlxText();
        textbox.size = 32;
        textbox.wordWrap = true;
        textbox.x = 16;
        textbox.y = FlxG.height / 2 + 8;
        textbox.text = 'FUCKING SHITTER!';
        textbox.fieldWidth = (FlxG.width - 16 / 4);
        textbox.updateHitbox();
        add(textbox);

        changeLine();
        super.create();
    }

    override function update(elapsed)
    {
       if (controls.ACCEPT)
            changeLine();
       super.update(elapsed);
    }

    function characterBounce()
    {
        for (i in 0...charsInDiag.length)
        {
            var char = charsInDiag[i];
            if (i == GlobalVariables.songsWithDialogue[song.toLowerCase()][currentLine][0])
            {
                char.visible = true;
                char.dance();
                char.y += 10;
                FlxTween.tween(char, {y: char.y - 10}, 0.2, {ease: FlxEase.cubeOut});
            } 
            else
                char.visible = false;
        }
    }

    function changeLine()
    {
        var futureLine:Int = currentLine + 1;
        if (GlobalVariables.songsWithDialogue[song.toLowerCase()] != null
        && GlobalVariables.songsWithDialogue[song.toLowerCase()][futureLine] != null)
        {
            textbox.text = GlobalVariables.songsWithDialogue[song.toLowerCase()][futureLine][1];
            textbox.updateHitbox();
            currentLine = futureLine;
            characterBounce();
            trace(GlobalVariables.songsWithDialogue[song.toLowerCase()][currentLine][0]);
        }
        else
        {
            var state = returnToMainMenu ? new StoryMenuState() : new PlayState();
            if (returnToMainMenu)
                returnToMainMenu = false;

            FlxG.switchState(state);
        }
    }
}