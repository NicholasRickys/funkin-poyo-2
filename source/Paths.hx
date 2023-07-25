package;

import flixel.FlxG;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import openfl.display3D.textures.Texture;
import openfl.display.BitmapData;
import openfl.system.System;
import flash.geom.Rectangle;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;

using StringTools;

typedef JSONCharacter = {
	frames:Array<{
		filename:String,
		frame:{
			x:Int,
			y:Int,
			w:Int,
			h:Int
		},
		rotated:Bool,
		trimmed:Bool,
		spriteSourceSize:{
			x:Int,
			y:Int,
			w:Int,
			h:Int
		},
		sourceSize:{
			w:Int,
			h:Int
		}
	}>,
	meta:{
		app:String,
		version:String,
		image:String,
		format:String,
		size:{
			w:Int,
			h:Int
		},
		scale:String
	}
}

class Paths {
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	private static var currentTrackedAssets:Map<String, Map<String, Dynamic>> = ["textures" => [], "graphics" => [], "sounds" => []];
	private static var localTrackedAssets:Map<String, Array<String>> = ["graphics" => [], "sounds" => []];

	public static final extensions:Map<String, String> = ["image" => "png", "audio" => "ogg", "video" => "mp4"];

	public static var dumpExclusions:Array<String> = [];

	public static function excludeAsset(key:String):Void {
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

	public static function clearUnusedMemory():Void {
		for (key in currentTrackedAssets["graphics"].keys()) {
			@:privateAccess
			if (!localTrackedAssets["graphics"].contains(key)) {
				if (currentTrackedAssets["textures"].exists(key)) {
					var texture:Null<Texture> = currentTrackedAssets["textures"].get(key);
					texture.dispose();
					texture = null;
					currentTrackedAssets["textures"].remove(key);
				}

				var graphic:Null<FlxGraphic> = currentTrackedAssets["graphics"].get(key);
				OpenFlAssets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				graphic.destroy();
				currentTrackedAssets["graphics"].remove(key);
			}
		}

		for (key in currentTrackedAssets["sounds"].keys()) {
			if (!localTrackedAssets["sounds"].contains(key)) {
				OpenFlAssets.cache.removeSound(key);
				currentTrackedAssets["sounds"].remove(key);
			}
		}

		// run the garbage collector for good measure lmfao
		System.gc();
	}

	public static function clearStoredMemory():Void {
		FlxG.bitmap.dumpCache();

		@:privateAccess
		for (key in FlxG.bitmap._cache.keys()) {
			if (!currentTrackedAssets["graphics"].exists(key)) {
				var graphic:Null<FlxGraphic> = FlxG.bitmap._cache.get(key);
				OpenFlAssets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				graphic.destroy();
			}
		}

		for (key in OpenFlAssets.cache.getSoundKeys()) {
			if (!currentTrackedAssets["sounds"].exists(key))
				OpenFlAssets.cache.removeSound(key);
		}

		for (key in OpenFlAssets.cache.getFontKeys())
			OpenFlAssets.cache.removeFont(key);

		localTrackedAssets["sounds"] = localTrackedAssets["graphics"] = [];
	}

	static var currentLevel:String;

	static public function setCurrentLevel(name:String) {
		currentLevel = name.toLowerCase();
	}

	static public function getPath(file:String, type:AssetType, library:Null<String>) {
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null) {
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload") {
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String) {
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String) {
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String) {
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String) {
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String) {
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String) {
		return getPath('data/$key.json', TEXT, library);
	}

	inline static public function charJson(key:String, ?library:String) {
		return getPath('images/$key.json', TEXT, library);
	}

	inline static public function modchart(song:String, key:String, ?library:String) {
		return getPath('data/$song/$key.lua', TEXT, library);
	}

	static public function sound(key:String, ?library:String) {
		return returnSound('sounds', key, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String) {
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String) {
		return returnSound('music', key, library);
	}

	inline static public function video(key:String) {
		return 'assets/videos/$key';
	}

	inline static public function voices(song:String) {
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle':
				songLowercase = 'dadbattle';
		}
		return 'songs:assets/songs/${songLowercase}/Voices.$SOUND_EXT';
	}

	inline static public function P1voice(song:String) {
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle':
				songLowercase = 'dadbattle';
		}
		return 'songs:assets/songs/${songLowercase}/playerVoice.$SOUND_EXT';
	}

	inline static public function P2voice(song:String) {
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle':
				songLowercase = 'dadbattle';
		}
		return 'songs:assets/songs/${songLowercase}/enemyVoice.$SOUND_EXT';
	}

	inline static public function inst(song:String) {
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle':
				songLowercase = 'dadbattle';
		}
		return 'songs:assets/songs/${songLowercase}/Inst.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String, useGL:Bool = true):FlxGraphic {
		var returnAsset:FlxGraphic = returnGraphic(key, library, useGL ? FlxG.save.data.useGL : false);
		return returnAsset;
	}

	inline static public function imageIcon(key:String, ?library:String) {
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String) {
		return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String) {
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String) {
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	public static function returnGraphic(key:String, ?library:String, ?useGL:Bool = false) {
		var path:String = getPath('images/$key.png', IMAGE, library);
		if (OpenFlAssets.exists(path)) {
			if (!currentTrackedAssets["graphics"].exists(path)) {
				var graphic:FlxGraphic;
				var bitmapData:BitmapData = OpenFlAssets.getBitmapData(path);

				if (useGL) {
					var texture:Texture = FlxG.stage.context3D.createTexture(bitmapData.width, bitmapData.height, BGRA, true);
					texture.uploadFromBitmapData(bitmapData);
					currentTrackedAssets["textures"].set(path, texture);

					bitmapData.disposeImage();
					bitmapData.dispose();
					bitmapData = null;

					graphic = FlxGraphic.fromBitmapData(BitmapData.fromTexture(texture), false, path);
				} else
					graphic = FlxGraphic.fromBitmapData(bitmapData, false, path);

				graphic.persist = true;
				currentTrackedAssets["graphics"].set(path, graphic);
			}

			localTrackedAssets["graphics"].push(path);
			return currentTrackedAssets["graphics"].get(path);
		}

		return null;
	}

	public static function returnSound(path:String, key:String, ?library:String) {
		var file:String = getPath(path == 'songs' ? '$key.$SOUND_EXT' : '$path/$key.$SOUND_EXT', SOUND, path == 'songs' ? path : library);
		if (OpenFlAssets.exists(file)) {
			if (!currentTrackedAssets["sounds"].exists(file))
				currentTrackedAssets["sounds"].set(file, OpenFlAssets.getSound(file));

			localTrackedAssets["sounds"].push(file);
			return currentTrackedAssets["sounds"].get(file);
		}

		FlxG.log.error('oh no $file is returning null NOOOO');
		return null;
	}

	// custom shit lol
	inline static public function getJSONChar(key:String, ?library:String) {
		var rawJson = OpenFlAssets.getText(charJson(key, library)).trim();
		while (!rawJson.endsWith("}")) {
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}
		trace(rawJson);
		return fromJSON(image(key, library), rawJson);
	}

	static function fromJSON(source:FlxGraphicAsset, json:String):FlxAtlasFrames
	{
		var parsedJson:JSONCharacter = haxe.Json.parse(json);
		var graphic:FlxGraphic = FlxG.bitmap.add(source);
		if (graphic == null)
			return null;
		// No need to parse data again
		var frames:FlxAtlasFrames = FlxAtlasFrames.findFrame(graphic);
		if (frames != null)
			return frames;

		if (graphic == null || xml == null)
			return null;

		frames = new FlxAtlasFrames(graphic);

		for (frame in parsedJson.frames)
		{
			var rect = FlxRect.get(frame.frame.x, frame.frame.y, frame.frame.w,
				frame.frame.h);

			var size = if (frame.trimmed)
			{
				new Rectangle(frame.spriteSourceSize.x, frame.spriteSourceSize.y, frame.spriteSourceSize.w,
					frame.spriteSourceSize.h);
			}
			else
			{
				new Rectangle(0, 0, rect.width, rect.height);
			}

			var angle = frame.rotated ? FlxFrameAngle.ANGLE_NEG_90 : FlxFrameAngle.ANGLE_0;

			var offset = FlxPoint.get(size.left, size.top);
			var sourceSize = FlxPoint.get(size.width, size.height);

			if (frame.rotated && !frame.trimmed)
				sourceSize.set(size.height, size.width);

			frames.addAtlasFrame(rect, sourceSize, offset, frame.filename, angle, false, false);
		}

		return frames;
	}
}
