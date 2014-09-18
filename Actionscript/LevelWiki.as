package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;

	public class LevelWiki extends Level
	{
		public var pfeil : MovieClip;
		public function LevelWiki()
		{
			super("WIKIGAME",PlayTheNetFX.GetLangString("WORLD_LEVEL_WIKI_TITLE"), PlayTheNetFX.GetLangString("WORLD_LEVEL_WIKI_DESC"), 3);
		}
		
		public override function EnablePfeil(enabled : Boolean)
		{
			pfeil.visible = enabled;
		}
	}
}