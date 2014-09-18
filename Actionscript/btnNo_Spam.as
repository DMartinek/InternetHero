package
{
	import flash.display.MovieClip;

	public class btnNo_Spam extends btnYesNoBase
	{
		public function btnNo_Spam()
		{
			super();
		}
		
		
		public override function OnClick()
		{
			MovieClip(root).gotoAndPlay(1, "explain");
		}
	}
}