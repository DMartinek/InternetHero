package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class outro_social extends MovieClip
	{
		var bgMusic:Sound; 
		var bgMusicChannel: SoundChannel;
		public function outro_social()
		{
			addEventListener(Event.ADDED_TO_STAGE, _addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, _removedFromStage);
		}
		
		function _addedToStage(event:Event)
		{		
			bgMusic = new social_outro_bg();
			var bgMusicTransform = new SoundTransform(0.5, 0);
			bgMusicChannel = bgMusic.play(0, int.MAX_VALUE, bgMusicTransform);
		}
		
		function _removedFromStage(event:Event)
		{
			bgMusicChannel.stop();
			bgMusicChannel = null;
			bgMusic = null;
		}
	}
}