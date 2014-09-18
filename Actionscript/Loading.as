package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class Loading extends MovieClip
	{
		public var txtPercentage : TextField;
		public var mvcCircle : MovieClip;
		var lastPercent : int;
		public function Loading()
		{
			super();
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		function _onEnterFrame(event:Event)
		{
			mvcCircle.rotation += 3;
			var currentPercent : int = PlayTheNetFX.LoadScreenPercentage;
			txtPercentage.text = currentPercent.toString() + "%";
			
			if(lastPercent == 100)
			{
				this.visible = false;
			}
			else
			{
				this.visible = true;
			}
			
			lastPercent = currentPercent;
		}
	}
}