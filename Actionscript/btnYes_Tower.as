package
{
	import flash.display.MovieClip;
	
	public class btnYes_Tower extends btnYesNoBase
	{
		public function btnYes_Tower()
		{
			super();
		}
		
		public override function OnClick()
		{
			MovieClip(root).gotoAndPlay(1, "last");
		}
	}
}