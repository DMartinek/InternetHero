package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class puzzleteilAnimated extends MovieClip
	{
		
		var startPos: Point = new Point(600,107);
		var targetPos: Point = new Point(169.35, 523.65);
		
		public function puzzleteilAnimated()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			
			x = startPos.x;
			y = startPos.y;
		}
		
		function _onAddedToStage(e:Event)
		{
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		function _onEnterFrame(e:Event)
		{
			if(Math.abs(x-targetPos.x) < 1 && Math.abs(y-targetPos.y) < 1)
			{
				stage.dispatchEvent(new Event("MOOD_POST_CORRECT"));
				parent.removeChild(this);
				removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			}
			else
			{
				x = (targetPos.x+x)*0.5;
				y = (targetPos.y+y)*0.5;
			}
		}
	}
}