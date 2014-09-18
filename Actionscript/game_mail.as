package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.getTimer;
	
	public class game_mail extends MovieClip
	{
		var bgMusic:Sound; 
		var bgMusicChannel: SoundChannel;

		public function game_mail()
		{
			addEventListener(Event.ADDED_TO_STAGE, _addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, _removedFromStage);
		}
			
		function _addedToStage(event:Event)
		{		
			MailWindow.StartTime = getTimer();
			MailWindow.ScoreOverall = 0;
			MailWindow.CurrentMailID = 0;
			MailWindow.ScoreCorrect = 0;
			MailWindow.ScoreBonus = 0;
			MailWindow.BonusStage = 0;
			
			MailWindow.LoadMails();
			progress.alpha = 1;
			
			Bonus.alpha = 0;
			Bonus.gotoAndStop(1);
			Bonus.kettenbonus.zaehler.gotoAndStop(1);
			
			var window : MailWindow = new MailWindow();
			MailWindow.LastMailWindow = window;
			var tmpMat : Matrix = new Matrix();
			tmpMat.translate(480,90);
			window.transform.matrix = tmpMat;
			MailWindow.StartTransform = tmpMat;
			addChild(window);
			
			bgMusic = new BackgroundMusic();
			bgMusicChannel = bgMusic.play(0, int.MAX_VALUE);
			bgMusicChannel.soundTransform = new SoundTransform(0.5,0);
			
			progress.gotoAndStop(1);
		}
		
		function _removedFromStage(event:Event)
		{
			if(MailWindow.LastMailWindow != null)
				removeChild(MailWindow.LastMailWindow);
			
			bgMusicChannel.stop();
			bgMusicChannel = null;
			bgMusic = null;
		}
	}
}