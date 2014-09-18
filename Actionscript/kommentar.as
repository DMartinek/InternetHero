package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class kommentar extends MovieClip
	{
		static var GoodList:Array = new Array(char_LilPing, char_SenorPong, char_EddyAt);
		static var BadList:Array = new Array(char_FunkyBob, char_MrUSB);
		
		
		var targetY : int = 0;
		var movementSpeed: Number = 0.2;
		public var IsGood: Boolean;
		public function kommentar()
		{
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			super();
		}
		
		function getRandomElementOf(array:Array):Object {
			var idx:int=Math.floor(Math.random() * array.length);
			return array[idx];
		}
		
		function _onAddedToStage(e:Event)
		{
			DeleteButton.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			var tmp:SocialCharacter;
			if(IsGood)
			{
				tmp = new (getRandomElementOf(GoodList))();
			}
			else
			{
				tmp = new (getRandomElementOf(BadList))();
			}
			
			tmp.x = -248.55;
			tmp.y = -1.15;
			tmp.width = 35;
			tmp.height = 35;
			txtName.text = tmp.Name;
			addChild(tmp);
		}
		
		public function SetPositionY(Y:int)
		{
			y = Y;
			targetY = Y;
		}
		
		public function MoveUp()
		{
			targetY -= 66;
		}
		
		function _onEnterFrame(e:Event)
		{
			var diff : Number = targetY - y;
			if(Math.abs(diff) > 0.5)
			{
				y += diff * movementSpeed;
			}
			
			if(!IsGood && stage)
			{
				stage.dispatchEvent(new Event("MOOD_BADCOMMENT_ACTIVE"));
			}
		}
		
		function _onMouseDown(e:MouseEvent)
		{
			
			for (var i:int = parent.getChildIndex(this); i < parent.numChildren; i++) 
			{
				(parent.getChildAt(i) as kommentar).MoveUp();
			}
			
			if(IsGood)
			{
				stage.dispatchEvent(new Event("MOOD_GOODCOMMENT_REMOVED"));
			}
			else
			{
				stage.dispatchEvent(new Event("MOOD_BADCOMMENT_REMOVED"));
			}
			parent.removeChild(this);
		}
	}
}