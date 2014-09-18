package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;

	public class LevelShip extends Level
	{
		public var pfeil : MovieClip;
		public function LevelShip()
		{
			super("ROUTERGAME", PlayTheNetFX.GetLangString("WORLD_LEVEL_SHIP_TITLE"), PlayTheNetFX.GetLangString("WORLD_LEVEL_SHIP_DESC"), 5);
		}
		
		public override function EnablePfeil(enabled : Boolean)
		{
			pfeil.visible = enabled;
		}
	}
}