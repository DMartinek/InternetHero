package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class btnMapSocial extends SimpleButton
	{
		public function btnMapSocial(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
			addEventListener(MouseEvent.CLICK, buttonClick);
		}
		
		function buttonClick(e:MouseEvent) 
		{
			PlayTheNetFX.SubmitScore("SOCIALGAME", PlayTheNetFX.GetLangString("SCORE_CANCELED"), 0, 0, 0);
			stage.dispatchEvent(new Event("CONTENT_FINISHED_SOCIALGAME", true, true));
		}
	}
}