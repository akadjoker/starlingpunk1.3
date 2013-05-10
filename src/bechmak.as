package  
{
	
		
	import com.djoker.SP;
	import com.djoker.World;
	import com.djoker.masks.Pixelmask;
	import com.djoker.helpers.Primitives;
	import com.djoker.Entity;
	import com.djoker.utils.Key;
	import com.djoker.utils.Input;

	
	import com.djoker.tween.Tweener;
	import com.djoker.tween.misc.VarTween;
	import com.djoker.tween.Ease;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.textures.TextureAtlas;
	import starling.display.MovieClip;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	import starling.display.Button;
	

	
	/**
	 * ...
	 * @author djoker
	 */
	public class bechmak extends World 
	{
		public var player:Player;
		private var stween:Tween;
		private var hero:MovieClip;
		
		
		public function bechmak() 
		{
			super();
			
			
			
		
		}
		override public function begin():void
		{

			hero = new MovieClip(getTextureAtlas("atlas").getTextures("flight_"), 10);
			hero.x = 100;
			hero.y = 100;
			hero.scaleX = -1;
			hero.pivotX = hero.width  / 2;
            hero.pivotY = hero.height / 2;
			hero.scaleX = 0.2;
			hero.scaleY=  0.2;
            addChild(hero);
            hero.play();
			Starling.juggler.add(hero);
		
			
		//	this.y = 0;
			
			/*
			tween = new Tweener();
			var topTween:VarTween = new VarTween(onBounceIn);
			topTween.tween(this, "y", 200, 1.5, Ease.bounceOut);
			tween.addTween(topTween, false);
			SP.juggler.add(tween);
			*/
	        
			y = -240;
			stween = new Tween(this, 2.0, Transitions.EASE_OUT);
            stween.animate("y", 240);
			SP.juggler.add(stween);
	 

			
			for (var i:int = 0; i < 100; i++)
			{
			add(new Player());
			}
			
			var mBackButton:Button;
			mBackButton = new Button(getTextureAtlas("atlas").getTexture("button_back"), "Back");
            mBackButton.x = SP.halfWidth - mBackButton.width / 2;
            mBackButton.y = SP.height - mBackButton.height + 1;
            mBackButton.name = "backButton";
            addChild(mBackButton);
			
		}
		protected function onBounceIn():void
		{
			trace("bouncein");
		}

		override public function end():void 
		{ 
			this.removeChildren(0, -1, true);
		SP.juggler.remove(stween);
		dispose();
		}
		
		override public function update():void 
		{
		super.update();
		
	
		//tween.updateTweens();
		
	//hero.advanceTime(0.1);
		
		if (mouseHit)
		{
				add(new Player());
			}
		
		}
	}

}