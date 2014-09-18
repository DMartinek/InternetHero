package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class registrieren_btn extends MovieClip
	{
		public function registrieren_btn()
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
		}
	}
}