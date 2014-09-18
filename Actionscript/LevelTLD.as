package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	
	public class LevelTLD extends Level
	{
		public function LevelTLD()
		{
			super("TLD",PlayTheNetFX.GetLangString("WORLD_LEVEL_TLD_TITLE"), PlayTheNetFX.GetLangString("WORLD_LEVEL_TLD_DESC"), 2);
		}
		
		public override function EnablePfeil(enabled : Boolean)
		{
		}
	}
}