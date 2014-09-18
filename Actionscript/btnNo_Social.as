package
{
	import flash.display.MovieClip;

	public class btnNo_Social extends btnYesNoBase
	{
		public function btnNo_Social()
		{
			super();
		}
		
		
		public override function OnClick()
		{
			MovieClip(root).gotoAndPlay(1, "explain");
		}
	}
}