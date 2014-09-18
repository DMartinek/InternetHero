package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	public class MuteButton extends MovieClip
	{
		var muted: Boolean;
		public function MuteButton()
		{
			useHandCursor = true;
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, _onClick);
			addEventListener(MouseEvent.MOUSE_OVER, _onOver);
			addEventListener(MouseEvent.MOUSE_OUT, _onOut);
			
			addEventListener(Event.ENTER_FRAME, _onFrameEnter);
			
			gotoAndStop(1);
		}
		
		function _onClick(e:MouseEvent):void{
			if(muted){
				SoundMixer.soundTransform = new SoundTransform(1,0);
				gotoAndStop(1);
				
			}else{
				SoundMixer.soundTransform = new SoundTransform(0,0);
				gotoAndStop(2);
			}
			muted = !muted;
		}
		
		function _onOver(e:MouseEvent):void{
			if(muted){
				gotoAndStop(3);		
			}else{
				gotoAndStop(4);
			}
		}
		
		function _onOut(e:MouseEvent):void{
			if(muted){
				gotoAndStop(2);
				
			}else{
				gotoAndStop(1);
			}
		}
		
		function _onFrameEnter(e:Event):void
		{
			// Bring always to front!
			if(parent != null)
				parent.addChild(this);
		}
	}
}