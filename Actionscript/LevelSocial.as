package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;

	public class LevelSocial extends Level
	{
		public var pfeil : MovieClip;
		public function LevelSocial()
		{
			super("SOCIALGAME",PlayTheNetFX.GetLangString("WORLD_LEVEL_SOCIAL_TITLE"), PlayTheNetFX.GetLangString("WORLD_LEVEL_SOCIAL_DESC"), 4);
		}
		
		public override function EnablePfeil(enabled : Boolean)
		{
			pfeil.visible = enabled;
		}
	}
}