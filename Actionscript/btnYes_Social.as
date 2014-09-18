package
{
	import flash.display.MovieClip;

	public class btnYes_Social extends btnYesNoBase
	{
		public function btnYes_Social()
		{
			super();
		}
		
		public override function OnClick()
		{
			MovieClip(root).gotoAndPlay(1, "last");
		}
	}
}