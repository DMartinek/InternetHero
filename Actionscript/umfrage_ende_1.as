package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	
	public class umfrage_ende_1 extends MovieClip
	{
		public var btnDone : Button;
		public var cmbOverallQuality:ComboBox;
		public var cmbLook:ComboBox;
		public var cmbSound:ComboBox;
		public var rdbPlayFinishedTrue : RadioButton;
		public var rdbPlayFinishedFalse : RadioButton;
		public var rbGrp:RadioButtonGroup = new RadioButtonGroup("rbgPlayFinished"); 
		
		
		var quality:String = null;
		var look:String = null;
		var sound:String = null;
		var playFinished:String = null;
		
		public function umfrage_ende_1()
		{
			super();
			
			btnDone.addEventListener(MouseEvent.CLICK, _onDoneClicked);
			
			cmbOverallQuality.addEventListener(Event.CHANGE, function(e : Event):void {
				quality = ComboBox(e.target).selectedItem.data;
				CheckIfAllowed();
			});
			cmbLook.addEventListener(Event.CHANGE, function(e : Event):void {
				look = ComboBox(e.target).selectedItem.data;
				CheckIfAllowed();
			});	
			cmbSound.addEventListener(Event.CHANGE, function(e : Event):void {
				sound = ComboBox(e.target).selectedItem.data;
				CheckIfAllowed();
			});				
			rbGrp.addEventListener(MouseEvent.CLICK, function(e : MouseEvent):void {
				playFinished = e.target.selection.value;
				CheckIfAllowed();
			});
		}
		
		function CheckIfAllowed()
		{
			if(quality != null && quality != "" && look != null && look != "" && sound != null && sound != "" && playFinished != null && playFinished != "")
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
			PlayTheNetFX.EvalLogEvent("UMFRAGE", "ENDE_UMFRAGE_0", "quality=" + quality + "&look=" + look + "&sound=" + sound +"&playFinished=" + playFinished);
			dispatchEvent(new Event("UMFRAGE_FINISHED_END0", true, true));
			
		}
	}
}