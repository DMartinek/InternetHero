package com.univie.ptn
{
	import com.unity.IUnityContent;
	import com.unity.IUnityContentHost;
	import com.unity.UnityContentLoader;
	import com.unity.UnityLoaderParams;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class PlayTheNetFX
	{
		public static var VERSION : int = 2;
		public static var DOMAIN : String = "ENTER_DOMAIN_HERE";		
		public static var DOMAIN_LOGIN : String = "../server/login.php";
		public static var DOMAIN_REGISTER : String = "../server/register.php";
		public static var DOMAIN_GETPOSTS : String = "../server/getRandomPosts.php";
		public static var DOMAIN_SETSCORE : String = "../server/setScore.php";
		public static var DOMAIN_GETSCORE : String = "../server/getScore.php";
		public static var DOMAIN_SETPROGRESS : String = "../server/setProgress.php";
		public static var DOMAIN_GETPROGRESS : String = "../server/getProgress.php";
		public static var DOMAIN_CONTENT : String = "";
		public static var DOMAIN_SETLOGDATA : String = "../server/setLogData.php";
		public static var DOMAIN_SERVER_CONFIG : String = "../server/getServerConfig.php";
		public static var DOMAIN_SERVER_LANGPACK : String = "./lang/";

		public static var STAGE : Stage;
		public static var UMFRAGE : Boolean = true;
		
		public static var USERNAME : String;
		
		public static var IsLoggedIn : Boolean;
		public static var IsRegisteredSuccessfully : Boolean;
		public static var Username : String;
	    static var preLoadedContentIDs:Dictionary = new Dictionary();
		static var preLoadedContent:Object = new Object();
		public static var LoadScreenPercentage : int = 0;
		static var GameProgress : int = 0;
		
		public static var ServerSettings = new Object();
		
		static var languageText : Object;
		static var languageSoundFinished : Boolean;
		static var languageSoundFinishedHandler : Function;
		static var languageSound : Object;
		static var loadedPosts : Object;
		
		static var date:Date = new Date();	
		
		public static function LogIn(username: String, password : String, onLoggedInListener : Function)
		{
			USERNAME = username;
			Username = username;
			
			var request : URLRequest = new URLRequest(DOMAIN_LOGIN);
			request.method = URLRequestMethod.POST; 
			
			var urlVar : URLVariables = new URLVariables();
			urlVar["username"] = username;
			urlVar["password"] = password;
			request.data = urlVar;
			
			var loader : URLLoader = new URLLoader(); 
			loader.dataFormat = URLLoaderDataFormat.TEXT; 
			loader.addEventListener(Event.COMPLETE, _LogInCompleted); 
			loader.addEventListener(Event.COMPLETE, onLoggedInListener); 
			loader.load(request); 
			
			
		}
		static function _LogInCompleted(event:Event)
		{
			var tmpLoader : URLLoader = URLLoader(event.target); 
			tmpLoader.dataFormat = URLLoaderDataFormat.TEXT;
			var data : Object = JSON.parse(tmpLoader.data);
			IsLoggedIn = data["loggedIn"] as Boolean;
			GameProgress = data["progress"] as int;
		}

		
		public static function Register(username: String, password : String, onRegisteredListener : Function)
		{
			var request : URLRequest = new URLRequest(DOMAIN_REGISTER);
			request.method = URLRequestMethod.POST; 
			
			var urlVar : URLVariables = new URLVariables();
			urlVar["username"] = username;
			urlVar["password"] = password;
			request.data = urlVar;
			
			var loader : URLLoader = new URLLoader(); 
			loader.dataFormat = URLLoaderDataFormat.TEXT; 
			loader.addEventListener(Event.COMPLETE, _RegisterCompleted); 
			loader.addEventListener(Event.COMPLETE, onRegisteredListener);
			loader.load(request); 
		}
		
		static function _RegisterCompleted(event:Event)
		{
			var tmpLoader : URLLoader = URLLoader(event.target); 
			tmpLoader.dataFormat = URLLoaderDataFormat.TEXT;
			var data : Object = JSON.parse(tmpLoader.data);
			IsRegisteredSuccessfully = data["successful"] as Boolean;
		}
		
		public static function UpdateServerConfig(onUpdatedListener : Function = null)
		{
			date = new Date();
			var request : URLRequest = new URLRequest(DOMAIN_SERVER_CONFIG + "?tick=" + date.getTime());
			request.method = URLRequestMethod.POST; 
			
			var loader : URLLoader = new URLLoader(); 
			loader.dataFormat = URLLoaderDataFormat.TEXT; 
			loader.addEventListener(Event.COMPLETE, _onServerConfigUpdated);
			if(onUpdatedListener!= null)
			{
				loader.addEventListener(Event.COMPLETE, onUpdatedListener); 
			}
			loader.load(request); 
		}
		
		static function _onServerConfigUpdated(event:Event)
		{
			var tmpLoader : URLLoader = URLLoader(event.target); 
			tmpLoader.dataFormat = URLLoaderDataFormat.TEXT;
			var data : Object = JSON.parse(tmpLoader.data);
			UMFRAGE = data["survey"] as Boolean;
		}

		public static function LoadLanguagePack(language : String, onLoadedListener : Function = null)
		{
			CurrentLanguage = language;
			date = new Date();
			var request : URLRequest = new URLRequest(DOMAIN_SERVER_LANGPACK + language + ".json?tick=" + date.getTime());
			request.method = URLRequestMethod.POST; 
			onLanguageLoadedListener = onLoadedListener;
			
			var loader : URLLoader = new URLLoader(); 
			loader.dataFormat = URLLoaderDataFormat.TEXT; 
			loader.addEventListener(Event.COMPLETE, _onLoadedLanguagePack);
			loader.load(request); 	
			
		}
		
		static var CurrentLanguage = "";
		static var SoundsToLoad : int = 0;
		static var SoundsLoaded : int = 0;
		static var onLanguageLoadedListener : Function = null
		static function _onLoadedLanguagePackSound(e : Event)
		{
			SoundsLoaded++;
			
			if(SoundsLoaded >= SoundsToLoad)
			{
				onLanguageLoadedListener(e);
			}
			
			LoadScreenPercentage = (SoundsLoaded / SoundsToLoad) * 100;
		}

		static function _onErrorLanguagePackSound(e : Event)
		{
			SoundsLoaded++;
			
			if(SoundsLoaded >= SoundsToLoad)
			{
				onLanguageLoadedListener(e);
			}
			
			LoadScreenPercentage = (SoundsLoaded / SoundsToLoad) * 100;
		}
		
		static function _onLoadedLanguagePack(e : Event)
		{
			var tmpLoader : URLLoader = URLLoader(e.target); 
			tmpLoader.dataFormat = URLLoaderDataFormat.TEXT;
			languageText = JSON.parse(tmpLoader.data) as Object;
			
			trace("Loading sounds:");
			
			SoundsToLoad = 0;
			SoundsLoaded = 0;
			languageSound = new Object();
			for(var prop2:String in languageText) {
				if(languageText[prop2].spoken == "yes"){
					SoundsToLoad++;
				}
			}
			
			// For each ID try loading a sound with the same name.
			for(var prop:String in languageText) {
				//trace(prop);
				if(languageText[prop].spoken == "yes"){
					languageSound[prop] = new Sound();
					languageSound[prop].addEventListener(Event.COMPLETE, _onLoadedLanguagePackSound); 
					languageSound[prop].addEventListener(IOErrorEvent.IO_ERROR, _onErrorLanguagePackSound); 
					 
					var req:URLRequest = new URLRequest(DOMAIN_SERVER_LANGPACK + CurrentLanguage + "/" + prop + ".mp3"); 
					languageSound[prop].load(req);
				}
			}
			
			// Test only!
			//onLanguageLoadedListener(e);
		}
		
		public static function GetLangString(id:String):String
		{
			if(languageText != null && languageText.hasOwnProperty(id))
			{
				var tmp:String = languageText[id].text as String;
				if(tmp == null){
					return "";
				}
				return tmp;
			}
			else
			{
				return "NOT FOUND!";
			}
		}
		
		public static function SetLangText(target:TextField, playSound:Boolean = true)
		{
			if(target.name.length > 3)
			{
				if(target.name.substr(0,4) == "lang")
				{
					var tmpID : String = target.name.substring(4);
					if(languageText != null && languageText.hasOwnProperty(tmpID))
					{
						target.text = languageText[tmpID].text as String;
					}
					else
					{
						target.text = "NOT FOUND!";
					}
					
					languageSoundFinished = true;
					
					if(playSound)
					{
						if(languageSound.hasOwnProperty(tmpID))
						{
							try {
								languageSoundFinishedHandler = null;
								languageSoundFinished = false;
								var channel:SoundChannel = languageSound[tmpID].play();
								channel.addEventListener(Event.SOUND_COMPLETE, _OnLanguageSoundFinishedPlaying); 
								//trace("Playing sound " + tmpID);
							}
							catch(error:Error){
								languageSoundFinished = true;
							}
						}
					}
				}
			}
		}
		
		public static function _OnLanguageSoundFinishedPlaying(e : Event)
		{
			languageSoundFinished = true;
			if(languageSoundFinishedHandler != null)
			{
				languageSoundFinishedHandler();
			}
		}
		
		public static function ContinueIfLanguageSoundFinished(OnPause : Function, OnContinue : Function)
		{
			languageSoundFinishedHandler = OnContinue;
			if(languageSoundFinished){
				OnContinue();
			}
			else{
				OnPause();
			}
		}
		
		public static function FillObjectTextWithLanguageStrings(parent:DisplayObjectContainer)
		{
			for (var i:int = 0; i < parent.numChildren; i++) 
			{
				var tmpChild : DisplayObject = parent.getChildAt(i);
				if(tmpChild is TextField)
				{
					if(tmpChild.name.length > 3)
					{
						if(tmpChild.name.substr(0,4) == "lang")
						{
							var tmpID : String = tmpChild.name.substring(4);
							if(languageText != null && languageText.hasOwnProperty(tmpID))
							{
								TextField(tmpChild).text = languageText[tmpID].text as String;
							}
							else
							{
								TextField(tmpChild).text = "NOT FOUND!";
							}
						}
					}
				}
				
				if(tmpChild is DisplayObjectContainer)
				{
					FillObjectTextWithLanguageStrings(DisplayObjectContainer(tmpChild));
				}
			}
			
		}
		
		
		public static function PreLoadContent(contentID : String, isUnity : Boolean = false)
		{
			if(!preLoadedContent.hasOwnProperty(contentID))
			{
				var content: PreloadContent = new PreloadContent();
				content.ID = contentID;
				content.isUnity = isUnity;
				preLoadedContent[contentID] = content;
				
				trace("Preload started for: " + content.ID);
				
				if(isUnity)
				{			
					content.unityContentHost = new PlayTheNetUnityHost(content);
//					
//					preLoadedContentIDs[content.unityContentHost.unityContentLoader] = contentID;
//					content.loader = content.unityContentHost.unityContentLoader;
					
					var params:UnityLoaderParams = new UnityLoaderParams(false,960,600,true);
					var unityContentLoader : UnityContentLoader = new UnityContentLoader(DOMAIN_CONTENT + contentID  + "?tick=" + date.getTime(), content.unityContentHost, params, false);
					unityContentLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _onPreLoadProgress);
					unityContentLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadCompleted);
					unityContentLoader.loadUnity();
					
					content.loader = unityContentLoader;
					content.unityContentHost.unityContentLoader = unityContentLoader;
					preLoadedContentIDs[unityContentLoader] = contentID;
				}
				else
				{
					Security.allowDomain(DOMAIN);
					var preLoader : URLLoader = new URLLoader();
					
					date = new Date();
					preLoader.addEventListener(Event.COMPLETE, _onPreLoadCompleted);
					preLoader.addEventListener(ProgressEvent.PROGRESS, _onPreLoadProgress);
					preLoader.dataFormat = URLLoaderDataFormat.BINARY;
					preLoader.load(new URLRequest(DOMAIN_CONTENT + contentID  + "?tick=" + date.getTime()));
					
					content.loader = preLoader;
					preLoadedContentIDs[preLoader] = contentID;
				}
			}
		}

		static function _onPreLoadCompleted(e:Event)
		{
			var loader : URLLoader = e.target as URLLoader;
			var content : PreloadContent = preLoadedContent[preLoadedContentIDs[loader]];
			content.completion = 100;
			
			trace("Preload completed for: " + content.ID);
			
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null );
			var swfLoader : Loader = new Loader();
			swfLoader.name = content.ID;
			swfLoader.loadBytes(loader.data, loaderContext);
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadCompleted);
			swfLoader.contentLoaderInfo.addEventListener(Event.INIT, _onPreLoadInit);
			content.SWFloader = swfLoader;
			trace("Created SWF loader for: " + content.ID);
		}
		
		// MovieClip propotype function that stop all running clips (current and inside clips)
		MovieClip.prototype.stopAllClips = function():void {
			var mc:MovieClip = this;
			var n:int = mc.numChildren;
			mc.stop();
			/*for (var i:int=0; i<n; i++) {
				var clip:MovieClip = mc.getChildAt(i) as MovieClip;
				if (clip) {
					clip.stop();
					clip.stopAllClips();
				}
			}*/
		}
		
		MovieClip.prototype.restartAllClips = function():void {
			var mc:MovieClip = this;
			var n:int = mc.numChildren;
			
			
			if(mc.hasOwnProperty("scenes") && mc.scenes.length > 0 && mc.scenes[0].name)
			{
				mc.gotoAndPlay(0, mc.scenes[0].name);
			}
			else
			{
				mc.gotoAndPlay(0);
			}
		
			
			/*for (var i:int=0; i<n; i++) {
				var clip:MovieClip = mc.getChildAt(i) as MovieClip;
				if (clip) {
					clip.restartAllClips();
				}
			}*/
		}
		
		static function _onPreLoadInit(e:Event)
		{
			var li : LoaderInfo = LoaderInfo(e.target);
			var loader : Loader = li.loader;
			li.removeEventListener(Event.INIT, _onPreLoadInit);
			var mvc : MovieClip = loader.content as MovieClip;
			mvc.stopAllClips();	
			
			trace("Preload initialized and mvc stopped for: " + loader.name);
		}
		
		static function _onLoadCompleted(e:Event)
		{
			var li : LoaderInfo = LoaderInfo(e.target);
			var loader : Loader = li.loader as Loader;
			var content : PreloadContent = preLoadedContent[loader.name];
			
			if(content == null)
			{
				content = preLoadedContent[preLoadedContentIDs[loader]];
			}
			
			content.content = loader.content;
			if(!content.isUnity)
			{
				content.isLoaded = true;
				trace("Loading completed for: " + content.ID);
				
				LoadCompleted(content);
			}
			else
			{
				content.unityContentHost.ContentUnity = IUnityContent(content.content); // 
				content.content.setContentHost((IUnityContentHost)(content.unityContentHost));
				trace("ContentHost has been set for: " + content.ID);
			}
		}
		
		public static function LoadCompleted(content : PreloadContent)
		{
			if(content.parent && content.isNeeded)
			{
				var mvc : MovieClip = content.parent.addChildAt(content.content as MovieClip, content.priority) as MovieClip;			
				var i : int = 0;
				for each (var eventName:String in content.onFinishedEventNames) 
				{
					mvc.stage.addEventListener(eventName, content.onFinished[i], false, 0, true);
					i++;
				}		
				
				if(mvc.scenes.length > 0 && !content.isUnity)
				{
					mvc.restartAllClipsScene(mvc.scenes[0].name);
				}
				else
				{
					mvc.restartAllClips();
				}	
				trace("Added directly after load : " + content.ID);
				
				if(content.isUnity)
				{
					content.unityContentHost.ContentUnity.sendMessage("Main", "LoadLevel" + content.unityGameName);
					trace("Unity: Loaded level " + content.unityGameName + " directly after load!");
				}
			}
			else // if already added to stage and not isNeeded
			{
				if(content.isUnity)
				{
					content.unityContentHost.ContentUnity.sendMessage("Main","LoadLevel" + content.unityGameName);
					trace("Unity: Loaded level " + content.unityGameName + " directly after load in else!");
				}
			}
		}
		
		static function _onPreLoadProgress(e:ProgressEvent)
		{
			var loader : URLLoader = e.target as URLLoader;
			var content : PreloadContent = null;
			if(loader != null)
			{
				content = preLoadedContent[preLoadedContentIDs[loader]];
				content.completion = int((e.bytesLoaded / e.bytesTotal) * 100);
				LoadScreenPercentage = content.completion;
			}
			
			var loaderUnity : UnityContentLoader = e.target as UnityContentLoader;
			if(loaderUnity != null)
			{
				content = preLoadedContent[preLoadedContentIDs[loaderUnity]];
				content.completion = int((e.bytesLoaded / e.bytesTotal) * 100);
				LoadScreenPercentage = content.completion;
			}
		}		
		
		
		public static function GetPreLoadStatus(contentID : String) : int
		{
			return preLoadedContent[contentID].completion;
		}
		
		public static function DisplayPreLoaded(contentID : String, parent : DisplayObjectContainer, priority : int, onFinishedEventNames:Array, onFinishedFunctions : Array)
		{
			HidePreLoaded(contentID);
			
			var content : PreloadContent = preLoadedContent[contentID];
			
			content.parent = parent;
			content.priority = priority;	
			content.onFinishedEventNames = onFinishedEventNames;
			content.onFinished = onFinishedFunctions;
			content.isNeeded = true;
			
			if(content.isLoaded)
			{
				var mvc : MovieClip = parent.addChildAt(content.content as MovieClip, priority) as MovieClip;
				var i : int = 0;
				for each (var eventName:String in onFinishedEventNames) 
				{
					mvc.stage.addEventListener(eventName, onFinishedFunctions[i], false, 0, true);
					i++;
				}

				mvc.restartAllClips();

				
				trace("Added : " + contentID);
			}
		}
		
		public static function DisplayPreLoadedUnity(contentID : String, gameID : String, parent : DisplayObjectContainer, priority : int, onFinishedEventNames:Array, onFinishedFunctions : Array)
		{
			HidePreLoaded(contentID);
			
			var content : PreloadContent = preLoadedContent[contentID];
			
			content.parent = parent;
			content.priority = priority;	
			content.onFinishedEventNames = onFinishedEventNames;
			content.onFinished = onFinishedFunctions;
			content.unityGameName = gameID;
			
			if(true)
			{
				content.isNeeded = false;
				var mvc : MovieClip = parent.addChildAt(content.content as MovieClip, priority) as MovieClip;
				var i : int = 0;
				for each (var eventName:String in onFinishedEventNames) 
				{
					mvc.stage.addEventListener(eventName, onFinishedFunctions[i], false, 0, true);
					i++;
				}
				
				if(mvc.scenes.length > 0 && !content.isUnity)
				{
					mvc.gotoAndPlay(0, mvc.scenes[0].name);
				}
				else
				{
					mvc.gotoAndPlay(0);
				}
				
				
				if(content.unityContentHost.ContentUnity != null && content.unityContentHost.isLoaded)
				{
					// This seems to cause a "functiontable function with index 0 called" error that stalls the player
					content.unityContentHost.ContentUnity.sendMessage("Main","LoadLevel" + content.unityGameName);
					trace("Unity: Loaded level " + content.unityGameName);
				}
				
				trace("Added : " + contentID);
				
			}
		}
		
		public static function HidePreLoaded(contentID : String)
		{
			if(preLoadedContent.hasOwnProperty(contentID))
			{
				var content : PreloadContent = preLoadedContent[contentID];
				
				if(content.content == null || content.parent == null  || content.content.parent == null)
				{	
					trace("Returned for " + contentID);
					return;
				}
				else if(!content.isUnity)
				{
					if((content.content.parent as Loader) != null)
					{
						trace("Returned for " + contentID);
						return;
					}
				}
				
				var i : int = 0;
				for each (var eventName:String in content.onFinishedEventNames) 
				{
					content.content.parent.stage.removeEventListener(eventName, content.onFinished[i]);
					i++;
				}

				try { 
					var mvc:MovieClip = content.content as MovieClip;
					mvc.stop();
					if(content.isUnity)
					{
						content.content.parent.removeChild(content.content);
						trace("!!!Removed Unity: " + contentID);
					}
					else
					{
						content.content.parent.removeChild(mvc);
					}
				} 
				catch (myError:Error) { 
					
				} 
				
				trace("Removed : " + contentID);
				
			}
		}

		public static function PausePreLoaded(contentID : String)
		{
			var mvc : MovieClip = preLoadedContent[contentID].content;
			mvc.stop();
		}
		
		
		public static function LoadSocialPostsFromServer(onLoadingFinished : Function) :  void
		{
			date = new Date();
			var request : URLRequest = new URLRequest(DOMAIN_GETPOSTS + "?tick=" + date.getTime());
			request.method = URLRequestMethod.POST; 
			
			var loader : URLLoader = new URLLoader(); 
			loader.dataFormat = URLLoaderDataFormat.TEXT; 
			loader.addEventListener(Event.COMPLETE, _onSocialPostsLoaded);
			loader.addEventListener(Event.COMPLETE, onLoadingFinished);
			loader.load(request); 
		}
		
		static function _onSocialPostsLoaded(e:Event): void
		{
			var tmpLoader : URLLoader = URLLoader(e.target); 
			tmpLoader.dataFormat = URLLoaderDataFormat.TEXT;
			loadedPosts = JSON.parse(tmpLoader.data);
		}
		
		public static function GetSocialPosts() : Object
		{
			return loadedPosts;
		}
		
		static var HighScores : Object = new Object();
		
		static var ScoreGame : String;
		static var ScoreGameText : String;
		static var Score : int;
		static var TimeBonus : int;
		static var BonusScore : int;
		static var CompleteScore : int;
		static var LastGameWasCanceled : Boolean = false;
		public static function SubmitScore(gameName:String, gameText:String, score:int, timeBonus:int, bonus:int)
		{
			ScoreGame = gameName;
			ScoreGameText = gameText;
			Score = score;
			BonusScore = bonus;
			TimeBonus = timeBonus;
			CompleteScore = score + timeBonus + bonus;
			
			// Don't submit score when user cancelled game.
			if(CompleteScore == 0)
			{
				LastGameWasCanceled = true;
				return;
			}
			else
			{
				LastGameWasCanceled = false;
			}
			
			date = new Date();
			var request : URLRequest = new URLRequest(DOMAIN_SETSCORE + "?tick=" + date.getTime());
			request.method = URLRequestMethod.POST; 
			
			var urlVar : URLVariables = new URLVariables();
			urlVar["game"] = gameName;
			urlVar["score"] = CompleteScore;
			request.data = urlVar;
			
			var loader : URLLoader = new URLLoader(); 
			loader.dataFormat = URLLoaderDataFormat.TEXT; 
			loader.addEventListener(Event.COMPLETE, _onScoreSubmitted);
			loader.load(request); 
		}
		
		public static function GetLastScoreGame() : String
		{
			return ScoreGame;
		}
		public static function GetLastScoreGameText() : String
		{
			return ScoreGameText;
		}
		public static function GetLastScore() : int
		{
			return Score;
		}
		public static function GetLastBonus() : int
		{
			return BonusScore;
		}
		public static function GetLastTimeBonus() : int
		{
			return TimeBonus;
		}
		
		public static function GetLastScoreComplete() : int
		{
			return CompleteScore;
		}
		
		static function _onScoreSubmitted(event:Event)
		{
			trace("Score submitted to server.");
		}		
		
		public static function FetchHighscores(gameName:String, onCompletedHandler:Function)
		{
			date = new Date();
			var request : URLRequest = new URLRequest(DOMAIN_GETSCORE + "?tick=" + date.getTime());
			request.method = URLRequestMethod.POST; 
			
			var urlVar : URLVariables = new URLVariables();
			urlVar["game"] = gameName;
			request.data = urlVar;
			
			var loader : URLLoader = new URLLoader(); 
			loader.dataFormat = URLLoaderDataFormat.TEXT; 
			loader.addEventListener(Event.COMPLETE, _onHighScoresFetched);
			loader.addEventListener(Event.COMPLETE, onCompletedHandler);
			loader.load(request); 
		}
		
		static function _onHighScoresFetched(event : Event)
		{
			var tmpLoader : URLLoader = URLLoader(event.target); 
			tmpLoader.dataFormat = URLLoaderDataFormat.TEXT;
			var loadedScores = JSON.parse(tmpLoader.data);
			HighScores[loadedScores.game] = loadedScores;
		}
		
		public static function GetHighScore(gameName:String) : Object
		{
			if(HighScores.hasOwnProperty(gameName))
			{
				return HighScores[gameName];
			}
			else
			{
				return null;
			}
		}
		
		
		public static function EvalLogEvent(gameName: String, eventID : String, data: String)
		{
			
			var request : URLRequest = new URLRequest(DOMAIN_SETLOGDATA);
			request.method = URLRequestMethod.POST; 
			
			date = new Date();
			var timestamp:Number = date.getTime();
			
			var urlVar : URLVariables = new URLVariables();
			urlVar["timestamp"] = timestamp;
			urlVar["game"] = gameName;
			urlVar["event"] = eventID;
			urlVar["data"] = data;
			request.data = urlVar;
			
			var loader : URLLoader = new URLLoader(); 
			loader.dataFormat = URLLoaderDataFormat.TEXT; 
			loader.addEventListener(Event.COMPLETE, _onScoreSubmitted);
			loader.load(request); 
		}
		
		static var btnSkip : skip_btn;
		public static function EnableSkipButton(parent: DisplayObjectContainer, skipEvent : String)
		{
			if(btnSkip == null)
			{
				btnSkip = new skip_btn();
				btnSkip.x = 870;
				btnSkip.y = 580;
				btnSkip.width = 100;
				btnSkip.height = 43.80;
			}
			
			btnSkip.SetEventTarget(skipEvent);
			parent.addChild(btnSkip);
		}

		public static function DisableSkipButton()
		{
			// Check if button exists and is added to stage.
			if(btnSkip != null && btnSkip.parent != null)
			{
				btnSkip.parent.removeChild(btnSkip);
			}
		}
		
		static var pingPopup : pingEntry;
		public static function DisplayInfoPopupPing(parent : DisplayObjectContainer, duration : int, text : String, sound : flash.media.Sound)
		{
			if(pingPopup == null || pingPopup.parent == null)
			{
				pingPopup = new pingEntry();
				pingPopup.x = 862.4;
				pingPopup.y = -200;
				pingPopup.width = 100;
				pingPopup.height = 120.6;
				pingPopup.Text = text;
				pingPopup.play();
				parent.addChild(pingPopup);
				
				if(sound != null)
				{
					sound.play();
				}
				
				var t:Timer = new Timer(duration * 1000, 1);
				t.addEventListener(TimerEvent.TIMER, function(e : TimerEvent):void {
					pingPopup.play();
				});
				t.start();
			}
		}
		
		public static function DoAfterSomeTime(thingToDo:Function, time:Number)
		{
			var t:Timer = new Timer(time * 1000, 1);
			t.addEventListener(TimerEvent.TIMER, function(e : TimerEvent):void {
				thingToDo();
			});
			t.start();
		}
		
		public static function FetchGameProgress(onCompletedHandler:Function)
		{
			var request : URLRequest = new URLRequest(DOMAIN_GETPROGRESS + "?tick=" + date.getTime());
			request.method = URLRequestMethod.POST; 
			
			
			var loader : URLLoader = new URLLoader(); 
			loader.dataFormat = URLLoaderDataFormat.TEXT; 
			loader.addEventListener(Event.COMPLETE, _onGameProgressFetched);
			loader.addEventListener(Event.COMPLETE, onCompletedHandler);
			loader.load(request); 
		}
		
		static function _onGameProgressFetched(event : Event)
		{
			var tmpLoader : URLLoader = URLLoader(event.target); 
			tmpLoader.dataFormat = URLLoaderDataFormat.TEXT;
			var loadedProgress = JSON.parse(tmpLoader.data);
			GameProgress = loadedProgress["progress"];
		}
		
		public static function GetGameProgress() : int
		{
			return GameProgress;
		}
		
		public static function SetGameProgress(progress : int, onCompletedHandler:Function = null)
		{
			if(progress > GameProgress)
			{
				GameProgress = progress;
			}
			
			var request : URLRequest = new URLRequest(DOMAIN_SETPROGRESS);
			request.method = URLRequestMethod.POST; 
			
			var urlVar : URLVariables = new URLVariables();
			urlVar["progress"] = progress;
			request.data = urlVar;
			
			var loader : URLLoader = new URLLoader(); 
			loader.dataFormat = URLLoaderDataFormat.TEXT; 
			if(onCompletedHandler != null)
			{
				loader.addEventListener(Event.COMPLETE, onCompletedHandler, true, 0, true);
			}
			loader.load(request); 
		}
	}
}