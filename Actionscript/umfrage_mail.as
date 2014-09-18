package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.controls.TextArea;
	
	public class umfrage_mail extends MovieClip
	{
		public var btnDone : Button;
		public var cmbMailQuality:ComboBox;
		public var cmbMailDifficulty:ComboBox;
		public var txtGood : TextArea;
		public var txtBad : TextArea;
		
		var quality:String = null;
		var difficulty:String = null;
		var good:String = "";
		var bad:String = "";
		
		public function umfrage_mail()
		{
			super();
			
			btnDone.addEventListener(MouseEvent.CLICK, _onDoneClicked);
			
			cmbMailQuality.addEventListener(Event.CHANGE, function(e : Event):void {
				quality = ComboBox(e.target).selectedItem.data;
				CheckIfAllowed();
			});
			cmbMailDifficulty.addEventListener(Event.CHANGE, function(e : Event):void {
				difficulty = ComboBox(e.target).selectedItem.data;
				CheckIfAllowed();
			});			
			txtGood.addEventListener(Event.CHANGE, function(e : Event):void {
				good = TextArea(e.target).text;
			});
			txtBad.addEventListener(Event.CHANGE, function(e : Event):void {
				bad = TextArea(e.target).text;
			});
		}
		
		function CheckIfAllowed()
		{
			if(quality != null && quality != "" && difficulty != null && difficulty != "")
			{
				btnDone.visible = true;
			}
			else
			{
				btnDone.visible = false;
			}
		}
		
		
		function _onDoneClicked(e:MouseEvent)
		{
			PlayTheNetFX.EvalLogEvent("UMFRAGE", "MAIL_UMFRAGE", "quality=" + quality + "&difficulty=" + difficulty + "&good=" + good + "&bad=" + bad);
			dispatchEvent(new Event("UMFRAGE_FINISHED_MAIL", true, true));
			
		}
	}
}