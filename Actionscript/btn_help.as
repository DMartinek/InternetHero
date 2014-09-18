package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class btn_help extends SimpleButton
	{
		public function btn_help(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
			
			addEventListener(MouseEvent.CLICK, buttonClick);
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		function buttonClick(e:MouseEvent) {
			parent.getChildByName("tutorial_0").visible = true;
			PlayTheNetFX.DoAfterSomeTime(function(){
				parent.getChildByName("tutorial_0").visible = false;
				parent.getChildByName("tutorial_1").visible = true;
			}, 5);
			PlayTheNetFX.DoAfterSomeTime(function(){
				parent.getChildByName("tutorial_1").visible = false;
				parent.getChildByName("tutorial_2").visible = true;
			}, 10);
			PlayTheNetFX.DoAfterSomeTime(function(){
				parent.getChildByName("tutorial_2").visible = false;
			}, 15);
		}
		
		function enterFrame(e:Event)
		{
			parent.addChild(parent.getChildByName("tutorial_0"));
			parent.addChild(parent.getChildByName("tutorial_1"));
			parent.addChild(parent.getChildByName("tutorial_2"));
		}
	}
}