package
{
	import com.unity.IUnityContentHost;
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	

	public class Framework extends MovieClip
	{
		var mvcLogin : UILogin;
		var umfrageStart : umfrage_start;
		var umfrageMail : umfrage_mail;
		var umfrageTower : umfrage_tower;
		var umfrageEnde0 : umfrage_ende_1;
		var umfrageEnde1 : umfrage_ende_2;
		var scoreDisplay : score_mc;
		
		public function Framework()
		{
			super();
			
			PlayTheNetFX.STAGE = stage;
			
			scoreDisplay = new score_mc();
			addChild(scoreDisplay);
			scoreDisplay.x = 235;
			scoreDisplay.y = -70;
			scoreDisplay.stop();
			
			var lang:String = root.loaderInfo.parameters.lang as String;
			if(lang == null)
				lang = "german";
			
			PlayTheNetFX.LoadLanguagePack(lang, _onLanguageLoaded);
			
			PlayTheNetFX.PreLoadContent("intro.swf");
		}

		function _onLanguageLoaded(e:Event)
		{
			mvcLogin = new UILogin();
			addChild(mvcLogin);
			mvcLogin.x = 0;
			mvcLogin.y = 0;
			
			PlayTheNetFX.FillObjectTextWithLanguageStrings(mvcLogin);
			
			mvcLogin.addEventListener("CONTENT_FINISHED_UI", _onUILoggedIn);
		}

		function _onUILoggedIn(e:Event)
		{
			mvcLogin.removeEventListener("CONTENT_FINISHED_UI", _onUILoggedIn);
			removeChild(mvcLogin);
			mvcLogin = null;
			
			PlayTheNetFX.FetchGameProgress(_onFetchedGameProgress);
			PlayTheNetFX.EvalLogEvent("MISC", "LOGGED_IN", "");
			PlayTheNetFX.PreLoadContent("game_unity.swf", true);
		}
		
		function _onFetchedGameProgress(e:Event)
		{
			PlayTheNetFX.UpdateServerConfig(_onFetchedServerConfig);
		}
		
		function _onFetchedServerConfig(e:Event)
		{
			PlayTheNetFX.PreLoadContent("world.swf");
			stage.frameRate = 12;
			UmfrageStart();		
		}
		
		function UmfrageStart()
		{
			if(!PlayTheNetFX.UMFRAGE)
			{
				_onUmfrageStartFinished(null);
				return;
			}
			
			umfrageStart = new umfrage_start();
			addChild(umfrageStart);
			umfrageStart.addEventListener("UMFRAGE_FINISHED_START", _onUmfrageStartFinished);
		}
		
		function _onUmfrageStartFinished(e:Event)
		{
			if(e != null)
			{
				removeChild(umfrageStart);
			}
			PlayTheNetFX.DisplayPreLoaded("intro.swf", this, 2, ["CONTENT_FINISHED_INTRO"], [_IntroFinished]);		
			PlayTheNetFX.EnableSkipButton(this, "CONTENT_FINISHED_INTRO");	
		}
		
		function DisplayWorld()
		{
			stage.frameRate = 12;
			PlayTheNetFX.DisplayPreLoaded("world.swf", this, 2,["CONTENT_BEGINGAME_MAILGAME", "CONTENT_BEGINGAME_TOWERGAME", "CONTENT_BEGINGAME_WIFIGAME", "CONTENT_BEGINGAME_WIKIGAME", "CONTENT_BEGINGAME_SOCIALGAME", "CONTENT_BEGINGAME_ROUTERGAME"], [_MailGameBegan, _TowerGameBegan, _WifiGameBegan, _WikiGameBegan, _SocialGameBegan, _RouterGameBegan]);			
			PlayTheNetFX.UpdateServerConfig();
		}
		
		function _IntroFinished(e:Event)
		{
			trace("finished Intro");
			PlayTheNetFX.DisableSkipButton();
			PlayTheNetFX.HidePreLoaded("intro.swf");
			PlayTheNetFX.PreLoadContent("intro_mail.swf");
			PlayTheNetFX.PreLoadContent("intro_tower.swf");
			PlayTheNetFX.PreLoadContent("intro_wifi.swf");
			PlayTheNetFX.PreLoadContent("intro_wiki.swf");
			PlayTheNetFX.PreLoadContent("intro_social.swf");
			PlayTheNetFX.PreLoadContent("intro_router.swf");
			
			DisplayWorld();
		}
		
		
		// ------------------------------------------------------------------------------------------------------------
		// ----------------------------------- MAIL Game --------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------		
		function _MailGameBegan(e:Event)
		{
			PlayTheNetFX.UpdateServerConfig();
			PlayTheNetFX.HidePreLoaded("world.swf");
			PlayTheNetFX.PreLoadContent("game_mail.swf");
			stage.frameRate = 12;
			PlayTheNetFX.DisplayPreLoaded("intro_mail.swf", this, 2,["CONTENT_FINISHED_MAILINTRO"], [_MailIntroFinished]);
			PlayTheNetFX.EnableSkipButton(this, "CONTENT_FINISHED_MAILINTRO");
		}
		
		function _MailIntroFinished(e:Event)
		{
			PlayTheNetFX.DisableSkipButton();
			PlayTheNetFX.HidePreLoaded("intro_mail.swf");
			stage.frameRate = 24;
			PlayTheNetFX.PreLoadContent("outro_mail.swf");
			PlayTheNetFX.DisplayPreLoaded("game_mail.swf", this, 2,["CONTENT_FINISHED_MAILGAME"], [_MailGameFinished]);
		}
		
		function _MailGameFinished(e:Event)
		{
			PlayTheNetFX.PausePreLoaded("game_mail.swf");
			DisplayScore(_MailIntroFinished, _MailGameScoreSubmitted);
		}
		
		function _MailGameScoreSubmitted(e:Event)
		{
			UmfrageMail();
		}
		
		function UmfrageMail()
		{
			if(!PlayTheNetFX.UMFRAGE)
			{
				_onUmfrageMailFinished(null);
				return;
			}
			
			umfrageMail = new umfrage_mail();
			addChild(umfrageMail);
			umfrageMail.addEventListener("UMFRAGE_FINISHED_MAIL", _onUmfrageMailFinished);
		}
		
		function _onUmfrageMailFinished(e:Event)
		{
			if(e != null)
			{
				removeChild(umfrageMail);
			}
			PlayTheNetFX.HidePreLoaded("game_mail.swf");
			if(lastGameCanceled)
			{
				DisplayWorld();
			}
			else
			{
				PlayTheNetFX.SetGameProgress(1);
				stage.frameRate = 12;
				PlayTheNetFX.DisplayPreLoaded("outro_mail.swf", this, 2,["CONTENT_FINISHED_MAILOUTRO"], [_MailOutroFinished]);
				PlayTheNetFX.EnableSkipButton(this, "CONTENT_FINISHED_MAILOUTRO");
			}
		}

		function _MailOutroFinished(e:Event)
		{
			PlayTheNetFX.DisableSkipButton();
			PlayTheNetFX.HidePreLoaded("outro_mail.swf");
			DisplayWorld();
		}
		
		// ------------------------------------------------------------------------------------------------------------
		// ----------------------------------- TOWER Game -------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------	
		function _TowerGameBegan(e:Event)
		{
			PlayTheNetFX.UpdateServerConfig();
			PlayTheNetFX.HidePreLoaded("world.swf");
			//PlayTheNetFX.PreLoadContent("game_tower.swf", true);
			stage.frameRate = 12;
			PlayTheNetFX.DisplayPreLoaded("intro_tower.swf", this, 2,["CONTENT_FINISHED_TOWERINTRO"], [_TowerIntroFinished]);
			PlayTheNetFX.EnableSkipButton(this, "CONTENT_FINISHED_TOWERINTRO");
		}
		
		function _TowerIntroFinished(e:Event)
		{
			PlayTheNetFX.DisableSkipButton();
			PlayTheNetFX.HidePreLoaded("intro_tower.swf");
			PlayTheNetFX.PreLoadContent("outro_tower.swf");
			stage.frameRate = 24;
			PlayTheNetFX.DisplayPreLoadedUnity("game_unity.swf","Tower", this, 2,["CONTENT_FINISHED_TOWERGAME"], [_TowerGameFinished]);
		}
		
		function _TowerGameFinished(e:Event)
		{
			PlayTheNetFX.PausePreLoaded("game_unity.swf");
			DisplayScore(_TowerIntroFinished, _TowerGameScoreSubmitted);
		}

		
		function _TowerGameScoreSubmitted(e:Event)
		{
			UmfrageTower();
		}
		
		function UmfrageTower()
		{
			if(!PlayTheNetFX.UMFRAGE)
			{
				_onUmfrageTowerFinished(null);
				return;
			}
			
			umfrageTower = new umfrage_tower();
			addChild(umfrageTower);
			umfrageTower.addEventListener("UMFRAGE_FINISHED_TOWER", _onUmfrageTowerFinished);
		}
		
		function _onUmfrageTowerFinished(e:Event)
		{
			if(e != null)
			{
				removeChild(umfrageTower);
			}
			
			PlayTheNetFX.HidePreLoaded("game_unity.swf");
			if(lastGameCanceled)
			{
				DisplayWorld();
			}
			else
			{
				PlayTheNetFX.SetGameProgress(2);
				stage.frameRate = 12;
				PlayTheNetFX.DisplayPreLoaded("outro_tower.swf", this, 2,["CONTENT_FINISHED_TOWEROUTRO"], [_TrailerFinished]);
				PlayTheNetFX.EnableSkipButton(this, "CONTENT_FINISHED_TOWEROUTRO");
			}
		}
		
		function _TrailerFinished(e:Event)
		{
			UmfrageEnde0();
		}
		
		function UmfrageEnde0()
		{
			if(!PlayTheNetFX.UMFRAGE)
			{
				_onUmfrageEnde1Finished(null);
				return;
			}
			
			umfrageEnde0 = new umfrage_ende_1();
			addChild(umfrageEnde0);
			umfrageEnde0.addEventListener("UMFRAGE_FINISHED_END0", _onUmfrageEnde0Finished);
		}
		
		function _onUmfrageEnde0Finished(e:Event)
		{
			if(e != null)
			{
				removeChild(umfrageEnde0);
			}
			
			umfrageEnde1 = new umfrage_ende_2();
			addChild(umfrageEnde1);
			umfrageEnde1.addEventListener("UMFRAGE_FINISHED_END1", _onUmfrageEnde1Finished);
		}	
		function _onUmfrageEnde1Finished(e:Event)
		{
			if(e != null)
			{
				removeChild(umfrageEnde1);
			}
			
			PlayTheNetFX.DisableSkipButton();
			PlayTheNetFX.HidePreLoaded("outro_tower.swf");
			DisplayWorld();
		}
		
		
		// ------------------------------------------------------------------------------------------------------------
		// ----------------------------------- WIFI Game --------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------
		function _WifiGameBegan(e:Event)
		{
			PlayTheNetFX.UpdateServerConfig();
			PlayTheNetFX.HidePreLoaded("world.swf");
			PlayTheNetFX.PreLoadContent("game_wifi.swf");
			stage.frameRate = 12;
			PlayTheNetFX.DisplayPreLoaded("intro_wifi.swf", this, 2,["CONTENT_FINISHED_WIFIINTRO"], [_WifiIntroFinished]);
			PlayTheNetFX.EnableSkipButton(this, "CONTENT_FINISHED_WIFIINTRO");
		}
		
		function _WifiIntroFinished(e:Event)
		{
			PlayTheNetFX.DisableSkipButton();
			PlayTheNetFX.HidePreLoaded("intro_wifi.swf");
			PlayTheNetFX.PreLoadContent("outro_wifi.swf");
			stage.frameRate = 24;
			PlayTheNetFX.DisplayPreLoaded("game_wifi.swf", this, 2,["CONTENT_FINISHED_WIFIGAME"], [_WifiGameFinished]);
		}
		
		function _WifiGameFinished(e:Event)
		{
			PlayTheNetFX.PausePreLoaded("game_wifi.swf");
			DisplayScore(_WifiIntroFinished, _WifiGameScoreSubmitted);
		}
		
		function _WifiGameScoreSubmitted(e:Event)
		{
			PlayTheNetFX.HidePreLoaded("game_wifi.swf");
			if(lastGameCanceled)
			{
				DisplayWorld();
			}
			else
			{
				PlayTheNetFX.SetGameProgress(3);
				stage.frameRate = 12;
				PlayTheNetFX.DisplayPreLoaded("outro_wifi.swf", this, 2,["CONTENT_FINISHED_WIFIOUTRO"], [_WifiOutroFinished]); 
				PlayTheNetFX.EnableSkipButton(this, "CONTENT_FINISHED_WIFIOUTRO");
			}
		}
		
		function _WifiOutroFinished(e:Event)
		{
			PlayTheNetFX.DisableSkipButton();
			PlayTheNetFX.HidePreLoaded("outro_wifi.swf");
			DisplayWorld();
		}
	
		// ------------------------------------------------------------------------------------------------------------
		// ----------------------------------- WIKI Game --------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------
		function _WikiGameBegan(e:Event)
		{
			PlayTheNetFX.UpdateServerConfig();
			PlayTheNetFX.HidePreLoaded("world.swf");
			PlayTheNetFX.PreLoadContent("game_wiki.swf");
			stage.frameRate = 12;
			PlayTheNetFX.DisplayPreLoaded("intro_wiki.swf", this, 2,["CONTENT_FINISHED_WIKIINTRO"], [_WikiIntroFinished]);
			PlayTheNetFX.EnableSkipButton(this, "CONTENT_FINISHED_WIKIINTRO");
		}
		
		function _WikiIntroFinished(e:Event)
		{
			PlayTheNetFX.DisableSkipButton();
			PlayTheNetFX.HidePreLoaded("intro_wiki.swf");
			PlayTheNetFX.PreLoadContent("outro_wiki.swf");
			stage.frameRate = 24;
			PlayTheNetFX.DisplayPreLoaded("game_wiki.swf", this, 2,["CONTENT_FINISHED_WIKIGAME"], [_WikiGameFinished]);
		}
		
		function _WikiGameFinished(e:Event)
		{
			PlayTheNetFX.PausePreLoaded("game_wiki.swf");
			DisplayScore(_WikiIntroFinished, _WikiGameScoreSubmitted);
		}
		
		function _WikiGameScoreSubmitted(e:Event)
		{
			PlayTheNetFX.HidePreLoaded("game_wiki.swf");
			if(lastGameCanceled)
			{
				DisplayWorld();
			}
			else
			{
				PlayTheNetFX.SetGameProgress(4);
				stage.frameRate = 12;
				PlayTheNetFX.DisplayPreLoaded("outro_wiki.swf", this, 2,["CONTENT_FINISHED_WIKIOUTRO"], [_WikiOutroFinished]); 
				PlayTheNetFX.EnableSkipButton(this, "CONTENT_FINISHED_WIKIOUTRO");
			}
		}
		
		function _WikiOutroFinished(e:Event)
		{
			PlayTheNetFX.DisableSkipButton();
			PlayTheNetFX.HidePreLoaded("outro_wiki.swf");
			DisplayWorld();
		}
		
		// ------------------------------------------------------------------------------------------------------------
		// ----------------------------------- SOCIAL Game ------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------	
		function _SocialGameBegan(e:Event)
		{
			PlayTheNetFX.UpdateServerConfig();
			PlayTheNetFX.HidePreLoaded("world.swf");
			PlayTheNetFX.PreLoadContent("game_social.swf");
			stage.frameRate = 12;
			PlayTheNetFX.DisplayPreLoaded("intro_social.swf", this, 2,["CONTENT_FINISHED_SOCIALINTRO"], [_SocialIntroFinished]);
			PlayTheNetFX.EnableSkipButton(this, "CONTENT_FINISHED_SOCIALINTRO");
		}
		
		function _SocialIntroFinished(e:Event)
		{
			PlayTheNetFX.DisableSkipButton();
			PlayTheNetFX.HidePreLoaded("intro_social.swf");
			PlayTheNetFX.PreLoadContent("outro_social.swf");
			stage.frameRate = 24;
			PlayTheNetFX.DisplayPreLoaded("game_social.swf", this, 2,["CONTENT_FINISHED_SOCIALGAME"], [_SocialGameFinished]);
		}
		
		function _SocialGameFinished(e:Event)
		{
			PlayTheNetFX.PausePreLoaded("game_social.swf");
			DisplayScore(_SocialIntroFinished, _SocialGameScoreSubmitted);
		}
		
		function _SocialGameScoreSubmitted(e:Event)
		{
			PlayTheNetFX.HidePreLoaded("game_social.swf");
			if(lastGameCanceled)
			{
				DisplayWorld();
			}
			else
			{
				if(PlayTheNetFX.VERSION == 1)
				{
					PlayTheNetFX.SetGameProgress(3);
				}
				else
				{
					PlayTheNetFX.SetGameProgress(5);
				}
				stage.frameRate = 12;
				PlayTheNetFX.DisplayPreLoaded("outro_social.swf", this, 2,["CONTENT_FINISHED_SOCIALOUTRO"], [_SocialOutroFinished]); 
				PlayTheNetFX.EnableSkipButton(this, "CONTENT_FINISHED_SOCIALOUTRO");
			}
		}
		
		function _SocialOutroFinished(e:Event)
		{
			PlayTheNetFX.DisableSkipButton();
			PlayTheNetFX.HidePreLoaded("outro_social.swf");
			DisplayWorld();
		}
		
		// ------------------------------------------------------------------------------------------------------------
		// ----------------------------------- ROUTER Game ------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------	
		function _RouterGameBegan(e:Event)
		{
			PlayTheNetFX.UpdateServerConfig();
			PlayTheNetFX.HidePreLoaded("world.swf");
			stage.frameRate = 12;
			PlayTheNetFX.DisplayPreLoaded("intro_router.swf", this, 2,["CONTENT_FINISHED_ROUTERINTRO"], [_RouterIntroFinished]);
			PlayTheNetFX.EnableSkipButton(this, "CONTENT_FINISHED_ROUTERINTRO");
		}
		
		function _RouterIntroFinished(e:Event)
		{
			PlayTheNetFX.DisableSkipButton();
			PlayTheNetFX.HidePreLoaded("intro_router.swf");
			PlayTheNetFX.PreLoadContent("outro.swf");
			stage.frameRate = 24;
			PlayTheNetFX.DisplayPreLoadedUnity("game_unity.swf", "Routing", this, 2,["CONTENT_FINISHED_ROUTERGAME"], [_RouterGameFinished]);
		}
		
		function _RouterGameFinished(e:Event)
		{
			PlayTheNetFX.PausePreLoaded("game_unity.swf");
			DisplayScore(_RouterIntroFinished, _RouterGameScoreSubmitted);
		}
		
		function _RouterGameScoreSubmitted(e:Event)
		{
			PlayTheNetFX.HidePreLoaded("game_unity.swf");
			if(lastGameCanceled)
			{
				DisplayWorld();
			}
			else
			{
				if(PlayTheNetFX.VERSION == 1)
				{
					PlayTheNetFX.SetGameProgress(4);
				}
				else
				{
					PlayTheNetFX.SetGameProgress(6);
				}
				stage.frameRate = 12;
				PlayTheNetFX.DisplayPreLoaded("outro.swf", this, 2,["CONTENT_FINISHED_OUTRO"], [_RouterOutroFinished]); 
				PlayTheNetFX.EnableSkipButton(this, "CONTENT_FINISHED_OUTRO");
			}
		}
		
		function _RouterOutroFinished(e:Event)
		{
			PlayTheNetFX.DisableSkipButton();
			PlayTheNetFX.HidePreLoaded("outro.swf");
			DisplayWorld();
		}
		
		// ------------------------------------------------------------------------------------------------------------
		// ----------------------------------- Score Display ----------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------	
		
		static var displayOnRetryFunc : Function;
		static var displayOnContinueFunc : Function;
		static var lastGameCanceled : Boolean;
		
		function DisplayScore(onRetry : Function, onContinue : Function)
		{
			var tmpScore : int = PlayTheNetFX.GetLastScoreComplete();
			scoreDisplay.text_spiel.text = PlayTheNetFX.GetLastScoreGameText();	
			scoreDisplay.text_punkte.text = PlayTheNetFX.GetLastScore().toString();
			scoreDisplay.text_zeitbonus.text = PlayTheNetFX.GetLastTimeBonus().toString();
			scoreDisplay.text_bonus.text = PlayTheNetFX.GetLastBonus().toString();
			scoreDisplay.text_gesamtpunktzahl.text = tmpScore.toString();
			scoreDisplay.stern1.visible = tmpScore > 2500;
			scoreDisplay.stern2.visible = tmpScore > 5000;
			scoreDisplay.stern3.visible = tmpScore > 8000;
			scoreDisplay.langSCORE_POINTS.text = PlayTheNetFX.GetLangString("SCORE_POINTS");
			scoreDisplay.langSCORE_BONUS.text = PlayTheNetFX.GetLangString("SCORE_BONUS");
			scoreDisplay.langSCORE_TIMEBONUS.text = PlayTheNetFX.GetLangString("SCORE_TIMEBONUS");
			scoreDisplay.btnWorld.langSCORE_TOWORLD.text = PlayTheNetFX.GetLangString("SCORE_TOWORLD");
			scoreDisplay.btnRetry.langSCORE_AGAIN.text = PlayTheNetFX.GetLangString("SCORE_AGAIN");	
			
			lastGameCanceled = (tmpScore == 0);
			
			displayOnContinueFunc = onContinue;
			displayOnRetryFunc = onRetry;
			
			stage.addEventListener("SCORE_CONTINUE", onContinue);
			stage.addEventListener("SCORE_RETRY", onRetry);			
			stage.addEventListener("SCORE_CONTINUE", OnDisplayScoreEnded);
			stage.addEventListener("SCORE_RETRY", OnDisplayScoreEnded);
			scoreDisplay.gotoAndPlay(1);
			scoreDisplay.stern1.gotoAndPlay(1);
			scoreDisplay.stern2.gotoAndPlay(1);
			scoreDisplay.stern3.gotoAndPlay(1);
			
			addChild(scoreDisplay); // bring to front
		}
	
		function OnDisplayScoreEnded(event : Event)
		{
			scoreDisplay.gotoAndStop(0);		
			stage.removeEventListener("SCORE_CONTINUE", OnDisplayScoreEnded);
			stage.removeEventListener("SCORE_RETRY", OnDisplayScoreEnded);
			stage.removeEventListener("SCORE_CONTINUE", displayOnContinueFunc);
			stage.removeEventListener("SCORE_RETRY", displayOnRetryFunc);
		}

	}
}