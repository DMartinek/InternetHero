package
{
	import flash.display.MovieClip;
	
	public class btnYes_Spam extends btnYesNoBase
	{
		public function btnYes_Spam()
		{
			super();
			
		}
		
		public override function OnClick()
		{
			MovieClip(root).gotoAndPlay(1, "last");
		}
	}
}