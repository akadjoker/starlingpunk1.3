package com.djoker.Particles {
	
	
	import flash.utils.Dictionary;
	import starling.display.Sprite;
	
   import com.djoker.Particles.*;
   import com.djoker.SP;


	public class ParticleSystem {
		private static var effects:Dictionary = new Dictionary;

		public static function register(effect:ParticleEffect):Sprite 
		{
			var container:Sprite = new Sprite;
			var particleCloud:ParticleCloud = new ParticleCloud(effect).build();
			particleCloud.container = container;
			SP.juggler.add(particleCloud);
			container.addChild(particleCloud);
			effects[effect.name] = container;
			return container;
		}

		public static function emit(name:String, x:Number, y:Number,loop:Boolean=false):ParticleCloud 
		{
	
			if (effects[name] == null) 
			{
				return  null;
			}
			var sprite:Sprite = (  effects[name] as Sprite);
			if (sprite.numChildren <= 0) return  null;
			var cloud:ParticleCloud = sprite.getChildAt(0) as ParticleCloud;
			cloud.reset(x, y,loop);
		    return cloud;
		}
		public static function move(name:String, x:Number, y:Number):ParticleCloud 
		{
			if (effects[name] == null) 
			{
				return  null;
			}
			var sprite:Sprite = (  effects[name] as Sprite);
			if (sprite.numChildren <= 0) return  null;
			var cloud:ParticleCloud = sprite.getChildAt(0) as ParticleCloud;
			cloud.move(x, y);
		    return cloud;
		}
			public static function Remove(name:String):void
		{
			if (effects[name] == null) 
			{
				return ;
			}
			var sprite:Sprite = (  effects[name] as Sprite);
			var cloud:ParticleCloud = sprite.getChildAt(0) as ParticleCloud;
			
		    cloud.dispose();
			
			effects[name] = null;
		}
	}
}
