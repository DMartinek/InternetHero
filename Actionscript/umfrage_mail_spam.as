package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import fl.controls.Button;
	import fl.controls.CheckBox;
	
	public class umfrage_mail_spam extends MovieClip
	{
		public var btnDone : Button;
		public var chkUnknownSender:CheckBox;
		public var chkStrangeContent:CheckBox;
		public var chkLink : CheckBox;
		public var chkAttachment : CheckBox;
		public var chkNotSure : CheckBox;
		
		var unknownSender:Boolean = false;
		var strangeContent:Boolean = false;
		var link:Boolean = false;
		var attachment:Boolean = false;
		var notSure:Boolean = false;
		
		public var MailID : String;
		
		public function umfrage_mail_spam()
		{
			super();
			
			btnDone.addEventListener(MouseEvent.CLICK, _onDoneClicked);
			
			chkUnknownSender.addEventListener(Event.CHANGE, function(e : Event):void {
				unknownSender = CheckBox(e.target).selected;
				CheckIfAllowed();
			});
			chkStrangeContent.addEventListener(Event.CHANGE, function(e : Event):void {
				strangeContent = CheckBox(e.target).selected;
				CheckIfAllowed();
			});
			chkLink.addEventListener(Event.CHANGE, function(e : Event):void {
				link = CheckBox(e.target).selected;
				CheckIfAllowed();
			});
			chkAttachment.addEventListener(Event.CHANGE, function(e : Event):void {
				attachment = CheckBox(e.target).selected;
				CheckIfAllowed();
			});
			chkNotSure.addEventListener(Event.CHANGE, function(e : Event):void {
				notSure = CheckBox(e.target).selected;
				CheckIfAllowed();
			});
		}
		
		function CheckIfAllowed()
		{
			if(unknownSender || strangeContent || link || attachment || notSure)
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
			PlayTheNetFX.EvalLogEvent("UMFRAGE", "MAIL_SPAM_UMFRAGE", "id=" + MailID + "&unknownSender=" + unknownSender + "&strangeContent=" + strangeContent + "&link=" + link + "&attachment=" + attachment+ "&notSure=" + notSure);
			dispatchEvent(new Event("UMFRAGE_FINISHED_MAIL_SPAM", true, true));
			
		}
	}
}