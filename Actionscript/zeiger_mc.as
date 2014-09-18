package
{
	import com.univie.ptn.PlayTheNetFX;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class zeiger_mc extends MovieClip
	{
		var currentProgress = -1;
		
		public function zeiger_mc()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		function _onAddedToStage(event : Event)
		{
			if(PlayTheNetFX.GetGameProgress() > (currentProgress+1))
			{	
				currentProgress = PlayTheNetFX.GetGameProgress();
				gotoAndPlay("etappe" + (currentProgress+1));
			}
		}
	}
}