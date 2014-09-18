package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class KindName extends MovieClip
	{
		public var Name : TextField;
		
		public function KindName()
		{
			super();
			Name.text = PlayTheNetFX.USERNAME;
		}
	}
}