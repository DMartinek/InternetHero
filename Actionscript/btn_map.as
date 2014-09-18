package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class btn_map extends SimpleButton
	{
		public function btn_map(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
			addEventListener(MouseEvent.CLICK, buttonClick);
		}
		
		function buttonClick(e:MouseEvent) 
		{
			PlayTheNetFX.SubmitScore("MAILGAME", PlayTheNetFX.GetLangString("SCORE_CANCELED"), 0, 0, 0);
			stage.dispatchEvent(new Event("CONTENT_FINISHED_MAILGAME", true, true));
			(parent.getChildByName("progress") as MovieClip).alpha = 0;
			(parent.getChildByName("Bonus") as MovieClip).alpha = 0;
		}
	}
}