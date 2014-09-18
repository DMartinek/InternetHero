package
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public class btnPauseSocial extends SimpleButton
	{
		public function btnPauseSocial(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
			addEventListener(MouseEvent.CLICK, buttonClick);
		}
		
		function buttonClick(e:MouseEvent) 
		{
			
		}
	}
}