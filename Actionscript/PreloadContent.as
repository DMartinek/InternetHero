package
{
	
	import com.unity.IUnityContent;
	import com.unity.IUnityContentHost;
	import com.unity.UnityContentLoader;
	import com.univie.ptn.PlayTheNetUnityHost;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.display.Loader;
	
	public class PreloadContent
	{
		public var ID:String;
		public var loader:Object;
		public var SWFloader:Loader;
		public var isNeeded:Boolean;
		public var isUnity : Boolean;
		public var content : Object = null;
		public var unityContentHost:PlayTheNetUnityHost = null;
		public var completion: int;
		public var isLoaded: Boolean = false;
		public var parent:DisplayObjectContainer = null;
		public var priority:int = 0;
		public var onFinishedEventNames:Array = null;
		public var onFinished:Array = null;
		public var unityGameName = "";
	}
	
}