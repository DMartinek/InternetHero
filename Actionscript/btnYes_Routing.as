package
{
	import flash.display.MovieClip;

	public class btnYes_Routing extends btnYesNoBase
	{
		public function btnYes_Routing()
		{
			super();
		}
		
		public override function OnClick()
		{
			MovieClip(root).gotoAndPlay(241, "last");
		}
	}
}