package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class Highscore extends MovieClip
	{
		public var txtMyself : TextField;
		public var txtFirst : TextField;
		var display: Boolean;
		
		public function Highscore()
		{
			super();
			
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		public function Display() : void
		{
			display = true;
		}
		
		public function Hide() : void
		{
			display = false;
		}
		
		function _onEnterFrame(event:Event)
		{
			if(display)
			{
				if(y < 70)
				{
					y = (y+70)/2;
				}
				else
				{
					y = 70;
				}
			}
			else
			{
				if(y > -300)
				{
					y -= 100;
				}
				else
				{
					y = -300;
				}
			}
		}
	}
}