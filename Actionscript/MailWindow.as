package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	//import flashx.textLayout.formats.LeadingModel;
	
	public class MailWindow extends MovieClip
	{
		public static var StartTime : int;
		public static var MailCount: int = 20;
		public static var MailCountOnlySpam: int = 10;
		public static var CurrentMailID : int = 0;
		public static var ScoreCorrect : int = 0;
		public static var ScoreBonus : int = 0;
		public static var ScoreOverall : int = 0;
		public static var BonusStage : int = 0;
		public static var MaximumBonusStage : int = 10;
		public static var LastMailWindow : MailWindow = null;
		public var windowInstance : MovieClip;
		public var isSpam : Boolean;
		public var mailID : String;
		public var SpamType : String;
		
		public static var StartTransform : Matrix;
		static var mails: Array = [];
		var umfrageSpam : umfrage_mail_spam;
		var umfrageNoSpam : umfrage_mail_nospam;
		
		public function MailWindow()
		{
			super();
			this.stop();
			
			useHandCursor = true;
			buttonMode = true;
			mouseChildren = false;
			
			FillMailWithData();
			
			addEventListener(Event.ADDED_TO_STAGE, _addedToStage);

		}
		
		function _addedToStage(event:Event)
		{		
			// arms will not be readily added to the stage when this is called the first time...
			if(parent.getChildByName("fingers") != null && parent.getChildByName("arms") != null)
			{
				(parent.getChildByName("fingers") as MovieClip).play();
				(parent.getChildByName("arms") as MovieClip).play();						
			}
		}
		
		function startDragging(event:MouseEvent) 
		{
			var boundsRect:Rectangle = new Rectangle (65, StartTransform.ty, 750, 0);
			this.startDrag(false, boundsRect);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, liveDrag);
			// stop drag
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
		}
		
		function stopDragging(event:MouseEvent) 
		{
			var bonus = (parent.getChildByName("Bonus") as MovieClip);
			var hasMovedToSpam : Boolean = false;
			var hasMovedToWrong : Boolean = false;
			
			this.stopDrag();
			var createNewMail : Boolean = false;
			if (this.x < 300) 
			{
				createNewMail = true;
				var tmpDiscard : windowDiscard_mc = new windowDiscard_mc();
				MovieClip(root).addChildAt(tmpDiscard, 4);
				hasMovedToSpam = true;
				
				if(isSpam)
				{
					PlayTheNetFX.EvalLogEvent("mail", "mail_correct", "id=" + mailID);
					ScoreCorrect++;
					BonusStage++;
					if(BonusStage > MaximumBonusStage)
						BonusStage = MaximumBonusStage;
					
					if(BonusStage > 1)
					{
						bonus.alpha = 1;
						bonus.kettenbonus.zaehler.gotoAndStop(BonusStage - 1);
						bonus.play();
					}
					
					ScoreOverall += 3000/MailCount;
					ScoreBonus += BonusStage * 30
				}
				else if(BonusStage != 0)
				{
					hasMovedToWrong = true;
				}
			}
			else if (this.x > 600) 
			{
				createNewMail = true;
				var tmpSending : letter_mc = new letter_mc();
				MovieClip(root).addChildAt(tmpSending, 4);
				
				
				if(!isSpam)
				{
					PlayTheNetFX.EvalLogEvent("mail", "mail_correct", "id=" + mailID);
					ScoreCorrect++;
					BonusStage++;
					if(BonusStage > MaximumBonusStage)
						BonusStage = MaximumBonusStage;
					if(BonusStage > 1)
					{
						bonus.alpha = 1;
						bonus.kettenbonus.zaehler.gotoAndStop(BonusStage - 1);
						bonus.play();
					}
					PlayTheNetFX.DisplayInfoPopupPing(this.parent, 1, "Gut gemacht!", null);
					ScoreOverall += 3000/MailCount;
					ScoreBonus += BonusStage * 30
				}
				else if(BonusStage != 0)
				{	
					hasMovedToWrong = true;
				}
			}
			else 
			{
				transform.matrix = StartTransform;
			}
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, liveDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);

			if(createNewMail)
			{	
				// Set progress
				var progressMC:MovieClip = (parent.getChildByName("progress") as MovieClip);
				progressMC.gotoAndStop(CurrentMailID+1);
				
				if(hasMovedToWrong)
				{
					(progressMC.getChildByName("mail" + CurrentMailID) as MovieClip).gotoAndStop(1);
				}
				else
				{
					(progressMC.getChildByName("mail" + CurrentMailID) as MovieClip).gotoAndStop(2);
				}
				
				if(CurrentMailID == MailCount)
				{
					LastMailWindow = null;
					var score : int = ScoreOverall;
					var timeBonus : int = Math.max(0, 3000 - (getTimer() - StartTime) / 200);
					PlayTheNetFX.SubmitScore("MAILGAME", PlayTheNetFX.GetLangString("GAME_MAIL_SCORETEXT") + ScoreCorrect.toString() + " " + PlayTheNetFX.GetLangString("SCORE_OF") + " " + MailCount.toString(), score, timeBonus, ScoreBonus);
					stage.dispatchEvent(new Event("CONTENT_FINISHED_MAILGAME", true, true));
					(parent.getChildByName("progress") as MovieClip).alpha = 0;
					(parent.getChildByName("Bonus") as MovieClip).alpha = 0;
				}
				else
				{
					var tmpMail : MailWindow = new MailWindow();
					tmpMail.transform.matrix = StartTransform;
					parent.addChild(tmpMail);
					LastMailWindow = tmpMail;
					
//					if(PlayTheNetFX.UMFRAGE && Math.random() < 0.3){
//						if(hasMovedToSpam)
//						{
//							umfrageSpam = new umfrage_mail_spam();
//							umfrageSpam.MailID = mailID;
//							umfrageSpam.addEventListener("UMFRAGE_FINISHED_MAIL_SPAM", function(e : Event):void 
//								{
//									umfrageSpam.parent.removeChild(umfrageSpam);
//								});
//							parent.addChild(umfrageSpam);
//						}
//						else
//						{
//							umfrageNoSpam = new umfrage_mail_nospam();
//							umfrageNoSpam.MailID = mailID;
//							umfrageNoSpam.addEventListener("UMFRAGE_FINISHED_MAIL_NOSPAM", function(e : Event):void 
//								{
//								umfrageNoSpam.parent.removeChild(umfrageNoSpam);
//								});
//							parent.addChild(umfrageNoSpam);
//						}
//					}
					
					if(hasMovedToWrong)
					{
						PlayTheNetFX.EvalLogEvent("mail", "mail_wrong", "id=" + mailID);
						bonus.kettenbonus.gotoAndPlay("kettenbonus_break");
						if(SpamType == "Attachment")
						{
							PlayTheNetFX.DisplayInfoPopupPing(this.parent, 3, "Achte auf unbekannte Dateien im Anhang!", null);		
						}
						else if(SpamType == "Data")
						{
							PlayTheNetFX.DisplayInfoPopupPing(this.parent, 3, "Gib keine persönliche Daten an Andere weiter!", null);		
						}
						else if(SpamType == "Link")
						{
							PlayTheNetFX.DisplayInfoPopupPing(this.parent, 3, "Achte auf unbekannte Links!", null);		
						}
						else if(SpamType == "Scam")
						{
							PlayTheNetFX.DisplayInfoPopupPing(this.parent, 3, "Vertraue keiner E-Mail deren Absender du nicht kennst!", null)	
						}
						BonusStage = 0;
					}
				}
				
				parent.removeChild(this);
			}
		}		
		
		function liveDrag(event:MouseEvent) : void 
		{
			var dist : Number = 1.0 - Math.abs(this.x - 450)/450.0;
			
			if(dist < 0.5)
				dist = 0.5;
			
			this.scaleX = dist;
			this.scaleY = dist;

		}
		
		public static function LoadMails()
		{
			var arrRealSource: Array = [];
			var arrSpamSource: Array = [];
			for (var k:int = 0; k < 30; k++){
				arrRealSource.push(k);
				arrSpamSource.push(k);
			}
			
			var arrReal:Array = [];
			var arrSpam:Array = [];
			while (arrRealSource.length > 0) {
				arrReal.push(arrRealSource.splice(Math.round(Math.random() * (arrRealSource.length - 1)), 1)[0]);
			}
			while (arrSpamSource.length > 0) {
				arrSpam.push(arrSpamSource.splice(Math.round(Math.random() * (arrSpamSource.length - 1)), 1)[0]);
			}
			
			var mailsSource:Array = [];
			for (var i:int = 0; i < MailCount; i++){
				var mail:Object = new Object();
				var id:int = 0;
				if(i < MailCountOnlySpam){
					id = arrSpam[i];
					mail.Text = PlayTheNetFX.GetLangString("GAME_MAIL_SPAM_TEXT_" + id);
					mail.Subject = PlayTheNetFX.GetLangString("GAME_MAIL_SPAM_SUBJECT_" + id);
					mail.Sender = PlayTheNetFX.GetLangString("GAME_MAIL_SPAM_SENDER_" + id);
					mail.Attachment = PlayTheNetFX.GetLangString("GAME_MAIL_SPAM_ATTACHMENT_" + id);
					mail.ID = id;
					mail.Spam = true;
					mail.Type = PlayTheNetFX.GetLangString("GAME_MAIL_SPAM_INFO_" + id);
				}else{
					id = arrReal[i - MailCountOnlySpam];
					mail.Text = PlayTheNetFX.GetLangString("GAME_MAIL_REAL_TEXT_" + id);
					mail.Subject = PlayTheNetFX.GetLangString("GAME_MAIL_REAL_SUBJECT_" + id);
					mail.Sender = PlayTheNetFX.GetLangString("GAME_MAIL_REAL_SENDER_" + id);
					mail.Attachment = PlayTheNetFX.GetLangString("GAME_MAIL_REAL_ATTACHMENT_" + id);
					mail.ID = id;
					mail.Spam = false;
					mail.Type = "";
				}
				mailsSource.push(mail);
			}
			
			while (mailsSource.length > 0) {
				mails.push(mailsSource.splice(Math.round(Math.random() * (mailsSource.length - 1)), 1)[0]);
			}
		}
		
		public function FillMailWithData()
		{
			
			var mail : Object = mails[CurrentMailID];
			windowInstance.txtMailText.text = mail.Text as String;
			windowInstance.txtMailSubject.text = mail.Subject as String;
			windowInstance.txtMailSender.text = mail.Sender as String;
			windowInstance.txtMailAttachment.text = mail.Attachment as String;
			windowInstance.Attachment.visible = ((windowInstance.txtMailAttachment.text) != "");
			mailID = mail.ID as String;
			isSpam = mail.Spam as Boolean;
			SpamType = mail.Type as String;
			
			
			this.gotoAndPlay(1);
			CurrentMailID++;
	
			addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
		}
		
		
	}
}