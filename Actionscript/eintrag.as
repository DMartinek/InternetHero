package
{
	import com.univie.ptn.PlayTheNetFX;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class eintrag extends MovieClip
	{
		var Type : String = "";
		var IsSolved : Boolean = false;
		public function eintrag()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		function _onAddedToStage(e:Event)
		{
			langGAME_SOCIAL_VISIBLE.text = PlayTheNetFX.GetLangString("GAME_SOCIAL_VISIBLE");
			btnOnlyMe.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDownOnlyMe);
			btnFriends.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDownFriends);
			btnEveryone.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDownEveryone);
		}
		
		
		function _onMouseDownOnlyMe(e:MouseEvent)
		{
			if(Type == "Everyone")
			{
				stage.dispatchEvent(new Event("MOOD_POST_WRONG"));
			}
			else if(Type == "Friends")
			{
				stage.dispatchEvent(new Event("MOOD_POST_WRONG"));
			}
			else if(Type == "Nobody")
			{
				Solve();
			}
		}		
		function _onMouseDownFriends(e:MouseEvent)
		{
			if(Type == "Everyone")
			{
				stage.dispatchEvent(new Event("MOOD_POST_WRONG"));
			}
			else if(Type == "Friends")
			{
				Solve();
			}
			else if(Type == "Nobody")
			{
				stage.dispatchEvent(new Event("MOOD_POST_WRONG"));
			}	
		}		
		function _onMouseDownEveryone(e:MouseEvent)
		{
			if(Type == "Everyone")
			{
				Solve();
			}
			else if(Type == "Friends")
			{
				stage.dispatchEvent(new Event("MOOD_POST_WRONG"));
			}
			else if(Type == "Nobody")
			{
				stage.dispatchEvent(new Event("MOOD_POST_WRONG"));
			}
		}
		
		function Solve()
		{
			IsSolved = true;
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);			
		}
		
		function _onEnterFrame(e:Event)
		{
			if(scaleX < 0.01)
			{
				parent.addChild(new puzzleteilAnimated());
				parent.removeChild(this);
				removeEventListener(Event.ENTER_FRAME, _onEnterFrame);		
			}
			scaleX *= 0.5;	
			scaleY *= 0.5;
		}

		function getPosts(arr:Array, k:int):Array {
			var i:int;
			var rand:int;
			
			// Make a temporary array that initially matches the arr array.
			var temp:Array = arr.concat();
			
			// The hand array starts off empty but will eventually contain k cards.
			var posts:Array = new Array();
			
			for (i=0; i<k; i++) {
				// If temp contains no elements, we are not going to be able to choose any more cards, so we get out of the loop.
				if (temp.length == 0) break;
				
				// Get a random number from 0, 1, 2, ..., (length of temp array)-1. These are simply all the legit indices for the temp array.
				rand = Math.floor(temp.length * Math.random());
				
				// Put the element at temp[rand] into the hand array and remove it from the temp array.
				posts.push(temp.splice(rand,1)[0]);
			}
			return posts;
		}
		public function Fill(data : Object, commentsGoodPositive: Array, commentsGoodNegative: Array, commentsBad: Array, yStart : int) : int
		{
			txtStatus.text = data.Content as String;
			Type = data.Type as String;
			this.x = 607;
			this.y = yStart;
			yStart += 106.65;
			
			var comments: Array = [];
			if(data.Feeling == "Positive")
			{
				comments = getPosts(commentsGoodPositive, 2);
			}
			else
			{
				comments = getPosts(commentsGoodNegative, 2);
			}
			
			comments = comments.concat(getPosts(commentsBad, 1));
			var commentsShuffled: Array = [];
			while (comments.length > 0) {
				commentsShuffled.push(comments.splice(Math.round(Math.random() * (comments.length - 1)), 1)[0]);
			}
			
			for each(var i : Object in commentsShuffled)
			{
				var tmpComment : kommentar = new kommentar();
				tmpComment.txtContent.text = i.Content;
				tmpComment.x = 528.3 - x;
				tmpComment.SetPositionY(yStart - y);
				
				tmpComment.IsGood = i.IsGood as Boolean;
				
				yStart += 66;
				addChild(tmpComment);
			}
			
			yStart += 30;
			
			return yStart;

		}
	}
}