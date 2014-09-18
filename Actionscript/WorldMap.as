package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class WorldMap extends MovieClip
	{
		var bgMusic:Sound; 
		var bgMusicChannel: SoundChannel;
		
		public function WorldMap()
		{
			super();
			PlayTheNetFX.FillObjectTextWithLanguageStrings(this);
			addEventListener(Event.ADDED_TO_STAGE, _addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, _removedFromStage);
		}
		
		function _addedToStage(event:Event)
		{		
			bgMusic = new karte_bg();
			var volume : SoundTransform = new SoundTransform(0.3,0); 
			bgMusicChannel = bgMusic.play(0, int.MAX_VALUE, volume);
		}
		
		function _removedFromStage(event:Event)
		{
			bgMusicChannel.stop();
			bgMusicChannel = null;
			bgMusic = null;
		}
	}
}