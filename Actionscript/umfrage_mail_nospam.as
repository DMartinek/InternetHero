package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import fl.controls.Button;
	import fl.controls.CheckBox;
	
	public class umfrage_mail_nospam extends MovieClip
	{
		public var btnDone : Button;
		public var chkNothingSuspicious:CheckBox;
		public var chkNotSure : CheckBox;
		
		var nothingSuspicious:Boolean = false;
		var notSure:Boolean = false;
		
		public var MailID : String;
		
		public function umfrage_mail_nospam()
		{
			super();
			
			btnDone.addEventListener(MouseEvent.CLICK, _onDoneClicked);
			
			chkNothingSuspicious.addEventListener(Event.CHANGE, function(e : Event):void {
				nothingSuspicious = CheckBox(e.target).selected;
				CheckIfAllowed();
			});

			chkNotSure.addEventListener(Event.CHANGE, function(e : Event):void {
				notSure = CheckBox(e.target).selected;
				CheckIfAllowed();
			});
		}
		
		function CheckIfAllowed()
		{
			if(nothingSuspicious || notSure)
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
			PlayTheNetFX.EvalLogEvent("UMFRAGE", "MAIL_NOSPAM_UMFRAGE", "id=" + MailID + "&nothingSuspicious=" + nothingSuspicious + "&notSure=" + notSure);
			dispatchEvent(new Event("UMFRAGE_FINISHED_MAIL_NOSPAM", true, true));
			
		}
	}
}