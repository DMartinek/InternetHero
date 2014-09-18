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
	
	public class umfrage_start extends MovieClip
	{
		public var btnDone : Button;
		public var rdbGenderMale : RadioButton;
		public var rdbGenderFemale : RadioButton;
		public var rbGrp:RadioButtonGroup = new RadioButtonGroup("rbgGender"); 
		public var cmbAge:ComboBox;
		public var cmbFrequency:ComboBox;
		
		var gender:String = null;
		var age:String = null;
		var frequency:String = null;
		
		public function umfrage_start()
		{
			super();
			
			btnDone.addEventListener(MouseEvent.CLICK, _onDoneClicked);
			
			rbGrp.addEventListener(MouseEvent.CLICK, function(e : MouseEvent):void {
				gender = e.target.selection.value;
				CheckIfAllowed();
			});
			cmbAge.addEventListener(Event.CHANGE, function(e : Event):void {
				age = ComboBox(e.target).selectedItem.data;
				CheckIfAllowed();
			});
			cmbFrequency.addEventListener(Event.CHANGE, function(e : Event):void {
				frequency = ComboBox(e.target).selectedItem.data;
				CheckIfAllowed();
			});
		}
		
		function CheckIfAllowed()
		{
			if(gender != null && age != null && age != "" && frequency != null && frequency != "")
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
			PlayTheNetFX.EvalLogEvent("UMFRAGE", "START_UMFRAGE", "gender=" + gender + "&age=" + age + "&frequency=" + frequency);
			dispatchEvent(new Event("UMFRAGE_FINISHED_START", true, true));
			
		}
	}
}