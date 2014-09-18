package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;

	public class LevelPost extends Level
	{
		public var pfeil : MovieClip;
		public function LevelPost()
		{
			super("MAILGAME", PlayTheNetFX.GetLangString("WORLD_LEVEL_MAIL_TITLE"), PlayTheNetFX.GetLangString("WORLD_LEVEL_MAIL_DESC"), 0);
		}
		
		public override function EnablePfeil(enabled : Boolean)
		{
			pfeil.visible = enabled;
		}
	}
}