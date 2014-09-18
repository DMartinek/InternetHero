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
	
	public class umfrage_tower extends MovieClip
	{
		public var btnDone : Button;
		public var cmbMailQuality:ComboBox;
		public var cmbMailDifficulty:ComboBox;
		public var cmbTowerSpeed:ComboBox;
		public var txtGood : TextArea;
		public var txtBad : TextArea;
		
		var quality:String = null;
		var difficulty:String = null;
		var speed:String = null;
		var good:String = null;
		var bad:String = null;
		
		public function umfrage_tower()
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
			cmbTowerSpeed.addEventListener(Event.CHANGE, function(e : Event):void {
				speed = ComboBox(e.target).selectedItem.data;
				CheckIfAllowed();
			});				
			txtGood.addEventListener(Event.CHANGE, function(e : Event):void {
				good = TextArea(e.target).text;
				CheckIfAllowed();
			});
			txtBad.addEventListener(Event.CHANGE, function(e : Event):void {
				bad = TextArea(e.target).text;
				CheckIfAllowed();
			});
		}
		
		function CheckIfAllowed()
		{
			if(quality != null && quality != "" && difficulty != null && difficulty != "" && speed != null && speed != "")
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
			PlayTheNetFX.EvalLogEvent("UMFRAGE", "TOWER_UMFRAGE", "quality=" + quality + "&difficulty=" + difficulty + "&speed=" + speed +"&good=" + good + "&bad=" + bad);
			dispatchEvent(new Event("UMFRAGE_FINISHED_TOWER", true, true));
			
		}
	}
}