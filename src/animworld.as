package  
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.textures.TextureAtlas;
	import starling.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.djoker.utils.Input;
	import com.djoker.utils.Key;
	
    import com.djoker.controls.joystick.Joystick;
	import com.djoker.controls.joystick.JoystickAlign;
	import com.djoker.controls.joystick.JoystickState;

	
	import com.djoker.*;
	import com.djoker.graphics.Spritemap;
	
	import com.djoker.Particles.*;
	import com.djoker.Misc.SColor;
	
	
	import starling.display.Button;
	import starling.events.Event;
	import starling.events.TouchEvent;
    import starling.events.TouchPhase;
	
	 import starling.animation.Tween;
	import starling.animation.Transitions;

	/**
	 * ...
	 * @author djoker
	 */
	public class animworld extends World 
	{
		private var joystick:Joystick;
        private var hero:Image;
		private var player:Entity;
		private var anim:Spritemap;
		private var animwalk:Spritemap;
		private var px:Number = 100;
		private var particles:ParticleManager;
		private var parinfo:ParticleSystemInfo;
		
	
		private var X:Number = 100;
		private var Y: Number = 100;
		private var DX:Number = 0;
		private var DY:Number = 0;
  
		private var  Speed:Number = 180;
		private var  Friction:Number = 0.98;
  
		public var stween:Tween;
		 
	  
		[Embed(source = "assets/particles.png")] public static const parbmp:Class;
		
		public function animworld() 
		{
		super();
		}
			override public function begin():void 
		{ 
			y = -240;
	
		   
		   
		   	joystick = new Joystick(SP.engine.assets.getTexture("control_base") , SP.engine.assets.getTexture("control_knob"));
            addChild(joystick);
			
			
			
           Input.define("right", [Key.RIGHT]);
           Input.define("left", [Key.LEFT]);
		   Input.define("1", [Key.DIGIT_1]);
		   Input.define("2", [Key.DIGIT_2]);
		   Input.define("3", [Key.DIGIT_3]);
		   
		   
		   player = new Entity(200, 80);
           animwalk = new Spritemap(getTexture("herowalk"), 480 / 6, 612 / 6);
           animwalk.addTo('walk', animwalk._frameCount,0.9);
           animwalk.play('walk');
		   player.graphic = animwalk;
		   
		   


anim=new Spritemap(getTexture("heroidle"),510/15, 315/3);
anim.addTo('idle', 30,0.9);
anim.play('idle');
anim.visible = true;
animwalk.visible = false;
player.graphic = anim;

		   
		   add(player);
		   
		   parinfo = new ParticleSystemInfo();
		   //parinfo.Smoke();
		   //parinfo.Fontain();
		 //  parinfo.Fire();
		   
		   var bitmap:Bitmap = new parbmp();
		   var buffer:BitmapData = bitmap.bitmapData;
	
	
			
			hero = new Image(Texture.fromBitmapDataRect(buffer,96,64,32,32));
			addChild(hero);
		 
		   
		  // particles = new ParticleManager(getTexture("coin_particle"), parinfo);
		   particles = new ParticleManager(Texture.fromBitmapDataRect(buffer,0,0,32,32), parinfo);
		//   particles = new ParticleManager(SP.engine.assets.getCreateTexture("coin_particle",0, 0, 32, 32), parinfo);
		   particles.Fire();
		   addChild(particles);
		   
	
		   
		   
		   	var damage:ParticleEffect = new ParticleEffect("damage", getTexture("coin_particle") );
			damage.xVelocity = new Point(-20, 20);
			damage.yVelocity = new Point(-60, -110);
			damage.yAcceleration = new Point( 100, 180);
			damage.startScale = new Point(0.5, 1);
			damage.endScale= new Point(2.0,2.5);
			damage.lifetime = new Point(1.0, 1.4);
			damage.amount = 500;
			damage.blend = ParticleEffect.BLEND;
			damage.color(new SColor(0, 0, 1), new SColor(0.2, 0.2, 0.2), new SColor(0.1, 0, 0.1), new SColor(1, 0.2, 0.2));
			
	       addChild( ParticleSystem.register(damage));
		   
		   
		   
		   	
			var coinShatter:ParticleEffect = new ParticleEffect("coin-shatter", getTexture("coin_particle"));
		//	coinShatter.x = new Point(5, 14);
		//	coinShatter.y = new Point(5, 14);
			coinShatter.xVelocity = new Point(-30, 30);
			coinShatter.yVelocity = new Point(-30, 30);
			coinShatter.lifetime = new Point(0.5, 2);
			coinShatter.amount = 50;
			coinShatter.blend = ParticleEffect.PARTICLE;
			coinShatter.color(new SColor(0.1, 0, 0), new SColor(1, 0.2, 0.2), new SColor(0.1, 0, 0), new SColor(1, 0.2, 0.2));
			addChild(ParticleSystem.register(coinShatter));
			
			
			var launcher:ParticleEffect = new ParticleEffect("launcher", getTexture("coin_particle"));
			//launcher.x = new Point(0, 24);
			//launcher.y = new Point(0, 6);
			launcher.xVelocity = new Point(-50, 50);
			launcher.yVelocity = new Point(-30, 0);
			launcher.yAcceleration = new Point(-500, -200);
			launcher.lifetime = new Point(0.5, 3);
			launcher.amount = 50;
			launcher.blend = ParticleEffect.PARTICLE;
			launcher.color(new SColor(0, 0, 0), new SColor(1, 1, 1), new SColor(0, 0, 0), new SColor(1, 1, 1));
			addChild(ParticleSystem.register(launcher));
	
			
			ParticleSystem.emit("damage", 300, 200,true);	

			
			
			
			var mBackButton:Button;
			mBackButton = new Button(getTextureAtlas("atlas").getTexture("button_back"), "Back");
            mBackButton.x = SP.halfWidth - mBackButton.width / 2;
            mBackButton.y = SP.height - mBackButton.height + 1;
            mBackButton.name = "backButton";
            addChild(mBackButton);
  
			
			stween = new Tween(this, 0.5, Transitions.EASE_OUT);
            stween.animate("y", 240);
			SP.juggler.add(stween);
		}
		
   
			
			
       
	
		
		
		override public function update():void 
		{
		super.update();
		
		
	//	particles.MoveTo(100, 100, true);

		
		
		
	//	hero.scrollFactorX = 1;

		
	anim.visible = true;
	animwalk.visible = false;
	

				
			  if (Input.check(Key.A))     DX = DX - Speed * SP.elapsed;
			  if (Input.check(Key.D))     DX = DX + Speed * SP.elapsed;
			  if (Input.check(Key.W))     DY = DY - Speed * SP.elapsed;
			  if (Input.check(Key.S))     DY = DY + Speed * SP.elapsed;
			
					
 switch (joystick.state)
            {
                case JoystickState.LEFT:
                {
					 DX = DX - Speed * SP.elapsed;
                           break;
                }
                case JoystickState.RIGHT:
                {
					 DX = DX + Speed * SP.elapsed;
                       break;
                }
                case JoystickState.UP:
                {
                    DY = DY - Speed * SP.elapsed;
                    break;
                }
                case JoystickState.DOWN:
                {
                    DY = DY + Speed * SP.elapsed;
                    break;
                }
                case JoystickState.UP_RIGHT:
                {
                    
                    break;
                }
                case JoystickState.DOWN_RIGHT:
                {
                    
                    break;
                }
                case JoystickState.DOWN_LEFT:
                {
                   
                    break;
                }
                case JoystickState.UP_LEFT:
                {
                    
                    break;
                }
				
            }
			
			if (Input.check("1"))	 ParticleSystem.Remove("coin-shatter");
			if (Input.check("2"))	 ParticleSystem.emit("coin-shatter", px, 200,false);	
			if (Input.check("3"))	 ParticleSystem.emit("launcher", px, 200,false);
			
		//	ParticleSystem.move("damage", px, 200);	
			
			px++;
			if (px >= 600) px = 200;
			
			  DX = DX * Friction;
              DY = DY * Friction;
              X = X + DX;
              Y = Y + DY;
			  hero.x = X;
			  hero.y = Y;
			  
			  particles.FInfo.Emission = 50;// int(DX * DX + DY * DY) * 2;
			  particles.MoveTo(X+16, Y+16);
    
	if (X > 640)
	{
     X = 640 - (X - 640);
     DX = -DX;
    };
  if (X < 16) 
  {
    X = 16 + 16 - X;
    DX = -DX;
  }
  
  if (Y > 440) 
  {
    Y = 440 - (Y - 440);
    DY = -DY;
  }
  if (Y < 16)
  {
    Y = 16 + 16 - Y;
    DY = -DY;
  }
			  
			
            if (Input.check("left") || joystick.state==JoystickState.LEFT)
			{
				anim.visible = false;
				animwalk.visible = true;	
				animwalk.FlipX = true;
				anim.FlipX = true;
				//animwalk.scaleX =- 1;
			
			} else if (Input.check("right") || joystick.state==JoystickState.RIGHT)
			{
				//animwalk.scaleX = 1;
				anim.visible = false;
			    animwalk.visible = true;	
				
				
				
				animwalk.FlipX = false;
				anim.FlipX = false;
		
			} else
			{
			anim.visible = true;
			animwalk.visible = false;
			
			}

			
		
	
		}
		
		override public function end():void 
		{ 
		SP.juggler.remove(stween);
		dispose();
		}

		override public function dispose():void 
		{
			super.dispose();
			this.removeChildren();
			
		}

	
	}
}