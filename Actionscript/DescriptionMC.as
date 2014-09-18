package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class DescriptionMC extends MovieClip
	{
		public var txtTitle : TextField;
		public var txtText : TextField;
		var display: Boolean;
		
		public function DescriptionMC()
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
				if(this.alpha < 1)
				{
					this.alpha += 0.2;
				}
				else
				{
					this.alpha = 1;
				}
			}
			else
			{
				if(this.alpha > 0)
				{
					this.alpha -= 0.2;
				}
				else
				{
					this.alpha = 0;
				}
			}
		}
	}
}