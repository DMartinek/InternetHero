package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	
	public class LevelKrankenhaus extends Level
	{
		public var pfeil : MovieClip;
		public function LevelKrankenhaus()
		{
			super("TOWERGAME", PlayTheNetFX.GetLangString("WORLD_LEVEL_TOWER_TITLE"), PlayTheNetFX.GetLangString("WORLD_LEVEL_TOWER_DESC"), 1);
		}
		
		public override function EnablePfeil(enabled : Boolean)
		{
			pfeil.visible = enabled;
		}
	}
}