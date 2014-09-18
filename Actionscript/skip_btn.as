package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class skip_btn extends SimpleButton
	{
		var TargetEvent: String;
		
		public function skip_btn(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);

			addEventListener( MouseEvent.CLICK, _onClick );
		}
		
		public function SetEventTarget(targetEvent: String)
		{
			TargetEvent = targetEvent;
		}
		
		private function _onClick( event:MouseEvent ):void 
		{
			stage.dispatchEvent(new Event(TargetEvent, true, true));
		}
	}
}