package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	import fl.transitions.Fade;
	import fl.transitions.Transition;
	import fl.transitions.TransitionManager;
	import fl.transitions.easing.Strong;
	
	public dynamic class UILogin extends MovieClip
	{
		public var btnStartGame : flash.display.SimpleButton;
		public var btnRegister : flash.display.MovieClip;
		public var txtUsername : fl.controls.TextInput;
		public var txtPassword : fl.controls.TextInput;
		public var mvcError : MovieClip;
		
		public function UILogin()
		{
			super();
			btnStartGame.addEventListener(MouseEvent.CLICK, _onStartGameClick);
			btnRegister.addEventListener(MouseEvent.CLICK, _onRegisterClick);
			TransitionManager.start(this,{type:Fade, direction:Transition.IN, duration:1, easing:Strong.easeOut})
							
			addEventListener(KeyboardEvent.KEY_DOWN, myKeyDown);	
		}
		
		function myKeyDown (e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ENTER)
			{
				PlayTheNetFX.LogIn(txtUsername.text, txtPassword.text, _LogInCompleted);
				
				removeEventListener(KeyboardEvent.KEY_DOWN, myKeyDown);	
			}
		}
		function _onStartGameClick(e:MouseEvent) : void
		{
			PlayTheNetFX.LogIn(txtUsername.text, txtPassword.text, _LogInCompleted);
		}
		
		function _onRegisterClick(e:MouseEvent) : void
		{
			var mvcRegister : UIRegister = new UIRegister();
			parent.addChild(mvcRegister);
			mvcRegister.x = 0;
			mvcRegister.y = 0;
			
			
			PlayTheNetFX.FillObjectTextWithLanguageStrings(mvcRegister);
		}
		
		function _LogInCompleted(event:Event)
		{
			if(PlayTheNetFX.IsLoggedIn)
			{			
				mvcError.visible = false;		
				dispatchEvent(new Event("CONTENT_FINISHED_UI", true, true));		
			}
			else
			{
				mvcError.visible = true;
			}
		}
		
	}
}