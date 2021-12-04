package;

#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end
import haxe.Json;
import haxe.format.JsonParser;
import Song;

using StringTools;

typedef StageFile = {
	var directory:String;
	var defaultZoom:Float;
	var isPixelStage:Bool;

	var boyfriend:Array<Dynamic>;
	var girlfriend:Array<Dynamic>;
	var opponent:Array<Dynamic>;
}

class StageData {
	public static var forceNextDirectory:String = null;
	public static function loadDirectory(SONG:SwagSong) {
		var stage:String = '';
		if(SONG.stage != null) {
			stage = SONG.stage;
		} else if(SONG.song != null) {
			switch (SONG.song.toLowerCase().replace(' ', '-'))
			{
				case 'frenzy' | 'owgh' | 'fandemonium-beta':
					stage = 'street-1';
				case 'nightfall':
					stage = 'street-2-nightfall';
				case 'fandemonium':
					stage = 'street-3-fandemonium';
				default:
					stage = 'stage';
			}
		} else {
			stage = 'stage';
		}

		forceNextDirectory = getStageFile(stage).directory;
	}

	public static function getStageFile(stage:String):StageFile {
		var rawJson:String = null;
		var path:String = Paths.getPreloadPath('stages/' + stage + '.json');

		#if MODS_ALLOWED
		var modPath:String = Paths.modFolders('stages/' + stage + '.json');
		if(FileSystem.exists(modPath)) {
			rawJson = File.getContent(modPath);
		} else {
			rawJson = File.getContent(path);
		}
		#else
		rawJson = Assets.getText(path);
		#end
		return cast Json.parse(rawJson);
	}
}