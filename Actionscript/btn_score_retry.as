package
{
	import com.univie.ptn.PlayTheNetFX;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class btn_score_retry extends MovieClip
	{
		public function btn_score_retry()
		{
			buttonMode = true;
			addEventListener(Event.ADDED_TO_STAGE, _addedToStage);
			addEventListener(MouseEvent.MOUSE_OVER, overListener);
			addEventListener(MouseEvent.MOUSE_OUT, outListener);
			addEventListener(MouseEvent.CLICK, clickListener);
			
			mouseChildren = false;
			mouseEnabled = true;
		}
		
		function _addedToStage(event:Event)
		{			
			gotoAndStop(1);
		}
		
		function overListener(e:MouseEvent):void{
			gotoAndStop(2);
		}
		function outListener(e:MouseEvent):void{
			gotoAndStop(1);
		}
		function clickListener(e:MouseEvent):void{
			gotoAndStop(3);
			stage.dispatchEvent(new Event("SCORE_RETRY", true, true));
		}
	}
}