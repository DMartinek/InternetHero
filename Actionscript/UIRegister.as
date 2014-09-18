package
{
	import com.univie.ptn.PlayTheNetFX;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	import fl.transitions.Fade;
	import fl.transitions.Transition;
	import fl.transitions.TransitionManager;
	import fl.transitions.easing.Strong;
	
	public dynamic class UIRegister extends MovieClip
	{
		public var btnRegister : flash.display.SimpleButton;
		public var btnBack : flash.display.SimpleButton;
		public var txtUsername : fl.controls.TextInput;
		public var txtPassword : fl.controls.TextInput;
		public var txtPasswordAgain : fl.controls.TextInput;
		public var mvcErrorName : MovieClip;
		public var mvcErrorNameShort : MovieClip;
		public var mvcErrorPassword : MovieClip;
		public var mvcErrorPasswordShort : MovieClip;
		
		public function UIRegister()
		{
			super();
			
			btnRegister.addEventListener(MouseEvent.CLICK, _onRegisterClick);
			btnBack.addEventListener(MouseEvent.CLICK, _onBackClick);
			TransitionManager.start(this,{type:Fade, direction:Transition.IN, duration:1, easing:Strong.easeOut})
		}
		
		function _onBackClick(e:MouseEvent) : void
		{
			parent.removeChild(this);
		}
		
		function _onRegisterClick(e:MouseEvent) : void
		{
			mvcErrorPassword.visible = false;
			mvcErrorName.visible = false;
			mvcErrorPasswordShort.visible = false;
			mvcErrorNameShort.visible = false;
			

			if(txtUsername.text.length < 4)
			{
				mvcErrorNameShort.visible = true;
			}
			else if(txtPassword.text.length < 6)
			{
				mvcErrorPasswordShort.visible = true;
			}
			else if(txtPassword.text != txtPasswordAgain.text)
			{
				mvcErrorPassword.visible = true;
				return;
			}
			else
			{
				PlayTheNetFX.Register(txtUsername.text, txtPassword.text, _RegisterCompleted);
			}
		}
		
		function _RegisterCompleted(event:Event)
		{
			if(PlayTheNetFX.IsRegisteredSuccessfully)
			{			
				mvcErrorName.visible = false;
				parent.removeChild(this);
			}
			else
			{
				mvcErrorName.visible = true;
			}
		}
	}
}