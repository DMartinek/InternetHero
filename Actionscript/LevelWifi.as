package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;

	public class LevelWifi extends Level
	{
		public var pfeil : MovieClip;
		public function LevelWifi()
		{
			super("WIFIGAME",PlayTheNetFX.GetLangString("WORLD_LEVEL_WIFI_TITLE"), PlayTheNetFX.GetLangString("WORLD_LEVEL_WIFI_DESC"), 2);
		}
		
		public override function EnablePfeil(enabled : Boolean)
		{
			pfeil.visible = enabled;
		}
}
}