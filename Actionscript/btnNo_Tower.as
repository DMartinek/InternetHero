package
{
	import flash.display.MovieClip;

	public class btnNo_Tower extends btnYesNoBase
	{
		public function btnNo_Tower()
		{
			super();
		}
		
		public override function OnClick()
		{
			MovieClip(root).gotoAndPlay(1, "explain");
		}
	}
}