package
{
	import flash.display.MovieClip;

	public class btnNo_Routing extends btnYesNoBase
	{
		public function btnNo_Routing()
		{
			super();
		}
		
		public override function OnClick()
		{
			MovieClip(root).gotoAndPlay(1, "last");
		}
	}
}