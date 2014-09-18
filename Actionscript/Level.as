package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	public class Level extends MovieClip
	{
		var LevelName : String;
		var LevelNamePublic : String;
		var LevelTextPublic : String;
		var MinProgress : int;
		var FirstFrame : Boolean;
		
		public function Level(levelName : String, levelNamePublic : String, levelTextPublic: String, minimumProgress : int)
		{
			super();
			LevelName = levelName;
			LevelNamePublic = levelNamePublic;
			LevelTextPublic = levelTextPublic;
			
			MinProgress = minimumProgress;
			
			//addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
			addEventListener(Event.ENTER_FRAME, _onFrameEntered);
			
			FirstFrame = true;
		}
		
		function _onFrameEntered(event : Event)
		{
			var gameProgress: int = PlayTheNetFX.GetGameProgress();
			//if(FirstFrame)
			{
				if(gameProgress == MinProgress)
				{
					EnablePfeil(true);
				}
				else
				{
					EnablePfeil(false);
				}
				
				if(gameProgress >= MinProgress)
				{
					parent.getChildByName("clouds_" + MinProgress).visible = false;
					this.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
					addEventListener(MouseEvent.CLICK, _onClick);
					buttonMode = true;
				}
				else
				{		
					parent.getChildByName("clouds_" + MinProgress).visible = true;
					this.transform.colorTransform = new ColorTransform(0.27, 0.27, 0.27, 1, 126, 138, 155, 0);
				}	
			}
			
			FirstFrame = false;
		}

		
		public virtual function EnablePfeil(enabled : Boolean)
		{
			
		}
		
		function _onMouseOver(event : MouseEvent)
		{
			var levelDescription : DescriptionMC = (parent.getChildByName("Description") as DescriptionMC);
			levelDescription.txtTitle.text = LevelNamePublic;
			levelDescription.txtText.text = LevelTextPublic;
			levelDescription.Display();

			if(LevelName != "TLD")
			{
				PlayTheNetFX.FetchHighscores(LevelName, _onHighScoresFetched);
				var highscoreDisplay : Highscore = (parent.getChildByName("highscore") as Highscore);
				highscoreDisplay.txtFirstRank.text = "";
				highscoreDisplay.txtFirstScore.text = "";
				highscoreDisplay.txtFirstName.text = "";
				highscoreDisplay.txtMyselfRank.text = "";
				highscoreDisplay.txtMyselfScore.text = "";
				highscoreDisplay.txtMyselfName.text = "";
				highscoreDisplay.Display();
			}
			else
			{
				levelDescription.stern1.visible = false;
				levelDescription.stern2.visible = false;
				levelDescription.stern3.visible = false;
			}
			
		}
		
		function _onHighScoresFetched ( event : Event)
		{
			var score : Object = PlayTheNetFX.GetHighScore(LevelName);
			var highscoreDisplay : Highscore = (parent.getChildByName("highscore") as Highscore);
			var levelDescription : DescriptionMC = (parent.getChildByName("Description") as DescriptionMC);
			
			highscoreDisplay.txtFirstRank.text = "";
			highscoreDisplay.txtFirstScore.text = "";
			highscoreDisplay.txtFirstName.text = "";
			highscoreDisplay.txtMyselfRank.text = "";
			highscoreDisplay.txtMyselfScore.text = "";
			highscoreDisplay.txtMyselfName.text = "";
			
			if(score != null)
			{
				if(score.topThree != null)
				{
					for (var j:int = 0; j < score.topThree.length; j++) 
					{
						highscoreDisplay.txtFirstRank.appendText((j+1).toString());
						highscoreDisplay.txtFirstRank.appendText(".\n");
						highscoreDisplay.txtFirstScore.appendText(score.topThree[j].score);
						highscoreDisplay.txtFirstScore.appendText("\n");
						highscoreDisplay.txtFirstName.appendText(score.topThree[j].name);
						highscoreDisplay.txtFirstName.appendText("\n");
					}
				}
				
				if(score.self != null)
				{
					for (var i:int = 0; i < score.self.length; i++) 
					{
						highscoreDisplay.txtMyselfRank.appendText(score.self[i].rank);
						highscoreDisplay.txtMyselfRank.appendText(".\n");
						highscoreDisplay.txtMyselfScore.appendText(score.self[i].score);
						highscoreDisplay.txtMyselfScore.appendText("\n");
						highscoreDisplay.txtMyselfName.appendText(score.self[i].name);
						highscoreDisplay.txtMyselfName.appendText("\n");
					}
					
					levelDescription.stern1.visible = score.self[0].score > 2500;
					levelDescription.stern2.visible = score.self[0].score > 5000;
					levelDescription.stern3.visible = score.self[0].score > 8000;
					highscoreDisplay.stern1.visible = score.self[0].score > 2500;
					highscoreDisplay.stern2.visible = score.self[0].score > 5000;
					highscoreDisplay.stern3.visible = score.self[0].score > 8000;
				}
			}
		}
		
		function _onMouseOut(event : MouseEvent)
		{
			(parent.getChildByName("highscore") as Highscore).Hide();
			(parent.getChildByName("Description") as DescriptionMC).Hide();
		}
		
		function _onClick(eventObject:MouseEvent) 
		{			
			//removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			stage.dispatchEvent(new Event("CONTENT_BEGINGAME_" + LevelName, true, true));
		}
	}
}