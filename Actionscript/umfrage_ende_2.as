package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import fl.controls.Button;
	import fl.controls.TextArea;
	
	public class umfrage_ende_2 extends MovieClip
	{
		public var btnDone : Button;
		public var txtGood : TextArea;
		public var txtBad : TextArea;
		
		
		var good:String = "";
		var bad:String = "";
		
		public function umfrage_ende_2()
		{
			super();
			
			btnDone.addEventListener(MouseEvent.CLICK, _onDoneClicked);
			
			txtGood.addEventListener(Event.CHANGE, function(e : Event):void {
				good = TextArea(e.target).text;
			});
			txtBad.addEventListener(Event.CHANGE, function(e : Event):void {
				bad = TextArea(e.target).text;
			});
		}
		
		
		function _onDoneClicked(e:MouseEvent)
		{
			PlayTheNetFX.EvalLogEvent("UMFRAGE", "ENDE_UMFRAGE_1", "good=" + good + "&bad=" + bad);
			dispatchEvent(new Event("UMFRAGE_FINISHED_END1", true, true));
			
		}
	}
}