package com.univie.ptn
{
	import com.unity.IUnityContent;
	import com.unity.IUnityContentHost;
	import com.unity.UnityContentLoader;
	import com.unity.UnityLoaderParams;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.system.LoaderContext;
	
	public class PlayTheNetUnityHost extends MovieClip implements IUnityContentHost
	{
		public var isLoaded: Boolean;
		private var preloadContent : PreloadContent;
		public var unityContentLoader: UnityContentLoader;
		var loadingScreen : Loading;
		public var ContentUnity : IUnityContent;
		public function PlayTheNetUnityHost(preContent : PreloadContent)
		{
			preloadContent = preContent;
			preloadContent.content = this;
		}
		
		public function Unload()
		{
			//removeChild(unityContentLoader);
			removeChild(unityContentLoader);
			trace("Unload is called.");
		}
		
		public function unityInitStart():void
		{
			addChild(unityContentLoader);
			trace("Unity initialization started!");
//			loadingScreen = new Loading();
//			loadingScreen.x = 480;
//			loadingScreen.y = 300;
//			addChild(loadingScreen);
		}
		public function unityInitComplete():void
		{
			//PlayTheNetFX.RestartUnityContent(ContentName);
			//ContentUnity.startFrameLoop();
			//ContentUnity.sendMessage("Main","Reload");
			trace("Unity initialization completed!");
			preloadContent.isLoaded = true;
			isLoaded = true;
			PlayTheNetFX.LoadCompleted(preloadContent);
			//removeChild(loadingScreen);
			//loadingScreen = null;
		}
	}
}