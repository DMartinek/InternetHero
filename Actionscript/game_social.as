package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import fl.motion.Color;
	
	public class game_social extends MovieClip
	{
//		var bgMusic:Sound; 
//		var bgMusicChannel: SoundChannel;
		
		var allPosts : Array = [];
		static var PostCount = 10;
		var currentPostID: int = 0;
		var currentPostY = 107;
		
		var PingMood : Number = 100.0;
		var Score : Number = 0;
		var BonusScore : Number = 0;
		var TimeScore : Number = 0;
		
		public function game_social()
		{
			addEventListener(Event.ADDED_TO_STAGE, _addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, _removedFromStage);

		}
		
		function _addedToStage(event:Event)
		{		
			MoodBubble.PuzzleCounter.text = "0";
			currentPostID = 0;
			currentPostY = 107;
			PingMood = 100;
			Score = 0;
			BonusScore = 0;
			TimeScore = 3000;
			allPosts = []; 
			
			PlayTheNetFX.LoadSocialPostsFromServer(_loadSocialPostsCompleted);
			
			stage.addEventListener("MOOD_BADCOMMENT_ACTIVE", _onBadCommentActive);
			stage.addEventListener("MOOD_BADCOMMENT_REMOVED", _onBadCommentRemoved);
			stage.addEventListener("MOOD_GOODCOMMENT_REMOVED", _onGoodCommentRemoved);
			stage.addEventListener("MOOD_POST_WRONG", _onPostWrong);
			stage.addEventListener("MOOD_POST_CORRECT", _onPostCorrect);
			
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
//			bgMusic = new BackgroundMusic();
//			bgMusicChannel = bgMusic.play(0, int.MAX_VALUE);
		}
		
		function _onEnterFrame(e:Event)
		{
			if(TimeScore >0)
			{
				TimeScore -= 10 / 24;
			}
			else
			{
				TimeScore = 0;
			}
		}
		
		function _loadSocialPostsCompleted(event:Event)
		{
			var tmpPosts: Object = PlayTheNetFX.GetSocialPosts();
			var tmpActualPosts : Array = getPosts(tmpPosts.Posts as Array, PostCount);
			var tmpCommentsGoodPositive : Array = tmpPosts.CommentsGoodPositive as Array;
			var tmpCommentsGoodNegative : Array = tmpPosts.CommentsGoodNegative as Array;
			var tmpCommentsBad : Array = tmpPosts.CommentsBad as Array;
			
			for each(var i:Object in tmpActualPosts)
			{
				addPost(i, tmpCommentsGoodPositive, tmpCommentsGoodNegative, tmpCommentsBad);
			}
			
			addChild(allPosts[currentPostID]);
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
		
		function addPost(data:Object, commentsGoodPositive: Array, commentsGoodNegative: Array, commentsBad: Array)
		{
			var newPost : eintrag = new eintrag();
			newPost.Fill(data, commentsGoodPositive, commentsGoodNegative, commentsBad, currentPostY); //currentPostY = 
			allPosts.push(newPost);
		}
		
		function _removedFromStage(event:Event)
		{
			if(currentPostID< PostCount)
			{
				removeChild(allPosts[currentPostID]);
			}
			
			stage.removeEventListener("MOOD_BADCOMMENT_ACTIVE", _onBadCommentActive);
			stage.removeEventListener("MOOD_BADCOMMENT_REMOVED", _onBadCommentRemoved);
			stage.removeEventListener("MOOD_GOODCOMMENT_REMOVED", _onGoodCommentRemoved);
			stage.removeEventListener("MOOD_POST_WRONG", _onPostWrong);
			stage.removeEventListener("MOOD_POST_CORRECT", _onPostCorrect);
			
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
//			bgMusicChannel.stop();
//			bgMusicChannel = null;
//			bgMusic = null;
			
		}
		
		function _onBadCommentActive(e:Event)
		{
			setMood(PingMood - 5.0/24.0);
		}
		
		function _onBadCommentRemoved(e:Event)
		{
			setMood(PingMood + 10);
			BonusScore += 3000/PostCount;
		}
		
		function _onGoodCommentRemoved(e:Event)
		{
			setMood(PingMood - 20);
			BonusScore -= 3000/PostCount;
			if(BonusScore < 0) BonusScore = 0;
		}
		
		function _onPostWrong(e:Event)
		{
			setMood(PingMood - 20);
			Score -= 3000/PostCount;
			if(Score < 0) Score = 0;
		}
		
		function _onPostCorrect(e:Event)
		{
			setMood(PingMood + 20);	
			Score += 3000/PostCount;
			
			currentPostID++;
			
			MoodBubble.PuzzleCounter.text = currentPostID;
			
			if(currentPostID >= PostCount)
			{
				// Game Over
				PlayTheNetFX.SubmitScore("SOCIALGAME", PlayTheNetFX.GetLangString("GAME_SOCIAL_SCORE_YOUHAVE")  + " " +  currentPostID  + " " +  PlayTheNetFX.GetLangString("SCORE_OF") + " " + PostCount  + " " +  PlayTheNetFX.GetLangString("GAME_SOCIAL_SCORE_PARTS"), Score, TimeScore, BonusScore);
				stage.dispatchEvent(new Event("CONTENT_FINISHED_SOCIALGAME", true, true));
			}
			else
			{
				// Show next post.
				addChild(allPosts[currentPostID]);
			}
		}
		
		
		var moodAnim : int = 0;
		function setMood(mood:Number)
		{
			if(mood > 100)
				mood = 100;
			if(mood < 0)
				mood = 0;
			
			if(mood <= 0)
			{
				stage.removeEventListener("MOOD_BADCOMMENT_ACTIVE", _onBadCommentActive);
				stage.removeEventListener("MOOD_BADCOMMENT_REMOVED", _onBadCommentRemoved);
				stage.removeEventListener("MOOD_GOODCOMMENT_REMOVED", _onGoodCommentRemoved);
				stage.removeEventListener("MOOD_POST_WRONG", _onPostWrong);
				stage.removeEventListener("MOOD_POST_CORRECT", _onPostCorrect);
				
				removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
				
				PingMoodGraphic.gotoAndStop(200);
				
				// Game Over
				PlayTheNetFX.SubmitScore("SOCIALGAME", PlayTheNetFX.GetLangString("GAME_SOCIAL_SCORE_FAILED"), 0, 0, 0);
				stage.dispatchEvent(new Event("CONTENT_FINISHED_SOCIALGAME", true, true));
			}
			else
			{
				PingMood = mood;
				var moodVal = 2 * mood;
				PingMoodBar.PingMoodBarInner.x = -191 + moodVal;
				var tmpColor : ColorTransform = new ColorTransform();
				var tmpColor2 : ColorTransform = new ColorTransform();
				tmpColor.color = Color.interpolateColor(0xFF0000, 0x339900, mood/100.0);
				tmpColor2.color = Color.interpolateColor(0xFF3300, 0x33bb00, mood/100.0);
				PingMoodBar.PingMoodBarInner.MoodBarInnerGreen.transform.colorTransform = tmpColor;
				PingMoodBar.PingMoodBarInner.MoodBarInnerGreenShadow.transform.colorTransform = tmpColor2;
				
				var oldMoodAnim: int = moodAnim;
				moodAnim = (200-moodVal) / 40;
				
				if(moodAnim != oldMoodAnim)
				{
					PingMoodGraphic.gotoAndPlay(moodAnim*50);
				}
			}
		}
	}
}