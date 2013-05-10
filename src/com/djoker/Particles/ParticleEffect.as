package com.djoker.Particles {
	
	import starling.textures.Texture;
	import com.djoker.Particles.*;
	import flash.geom.Point;
	import com.djoker.Misc.SColor;
	
	/**
	 * A class representing a particle effect. After creating one of these and registering it
	 * with AxParticleSystem, you can then emit an effect of this type at any time. Be sure to
	 * change all the options before registering it though, they cannot be changed afterward.
	 */
	public class ParticleEffect {
		
		
		public static const ADD:int=0;
		public static const BLEND:int=1;
		public static const FILTER:int = 2;
		public static const MODULATE:int = 3;
		public static const NONE:int=4;
		public static const PARTICLE:int = 5;

		

		
		/**
		 * Defines the x spawn window. This is the minimum and maximum offset around the spawn point.
		 * For example, if you emit this effect at 10, 10, and it's x and y ranges are both -5 to 5, then
		 * the particles will spawn anywhere between (5, 5) and (15, 15).
		 * 
		 * @default (0, 0) 
		 */
		public var x:Point;
		/**
		 * Defines the y spawn window. This is the minimum and maximum offset around the spawn point.
		 * For example, if you emit this effect at 10, 10, and it's x and y ranges are both -5 to 5, then
		 * the particles will spawn anywhere between (5, 5) and (15, 15).
		 * 
		 * @default (0, 0) 
		 */
		public var y:Point;
		/**
		 * The minimum and maximum x velocity that the particles will start out with.
		 * 
		 * @default (-100, 100) 
		 */
		public var xVelocity:Point;
		/**
		 * The minimum and maximum y velocity that the particles will start out with.
		 * 
		 * @default (-100, 100) 
		 */
		public var yVelocity:Point;
		/**
		 * The minimum and maximum x acceleration that each particle can have.
		 * 
		 * @default (0, 0) 
		 */
		public var xAcceleration:Point;
		/**
		 * The minimum and maximum y acceleration that each particle can have.
		 * 
		 * @default (0, 0) 
		 */
		public var yAcceleration:Point;
		/**
		 * The minimum and maximum angular velocity. This effects the group as a whole, and not
		 * individual particles.
		 * 
		 * @default (0, 0) 
		 */
		public var aVelocity:Point;
		/**
		 * The minimum and maximum scale that each particle will start with.
		 * 
		 * @default (1, 1) 
		 */
		public var startScale:Point;
		/**
		 * The minimum and maximum scale that each particle will end with. If this is
		 * larger than the startScale, the particles will grow in size, while if it is
		 * less, they will shrink.
		 * 
		 * @default (1, 1) 
		 */
		public var endScale:Point;
		/**
		 * The minimum and maximum alpha value that each particle will start with.
		 * 
		 * @default (1, 1) 
		 */
		public var startAlpha:Point;
		/**
		 * The minimum and maximum alpha balue that each particle will end with. If this is
		 * larger than the startAlpha, the particles will fade in, while if it is less, they
		 * will fade out.
		 * 
		 * @default (0, 0) 
		 */
		public var endAlpha:Point;
		/**
		 * The minimum and maximum lifetime each particle will have. This is how long the particle
		 * will have before it stops being drawn. It also determines the timeline at which a particle
		 * will scale and fade. If the start alpha is 1, end alpha is 0, and lifetime is 2, that means
		 * that at time = 0, the particle will be fully opaque, and it will fade out over the course of
		 * 2 seconds, and at 2 seconds (the end of its lifetime), it will be fully transparent.
		 * 
		 * @default (1, 2) 
		 */
		public var lifetime:Point;
		/**
		 * The amount of particles to emit each time you emit this particle effect.
		 * 
		 * @default 10 
		 */
		public var amount:uint;
		/**
		 * The blend mode to use for the particles.
		 * 
		 * @default AxBlendMode.BLEND
		 */
		public var blend:int;
		/**
		 * The range of the red component of each particle's starting color. Change the starting and ending
		 * colors in bulk using the <code>color</code> method.
		 * 
		 * @default 1 
		 */
		public var startColorRed:Point;
		/**
		 * The range of the green component of each particle's starting color. Change the starting and ending
		 * colors in bulk using the <code>color</code> method.
		 * 
		 * @default 1 
		 */
		public var startColorGreen:Point;
		/**
		 * The range of the blue component of each particle's starting color. Change the starting and ending
		 * colors in bulk using the <code>color</code> method.
		 * 
		 * @default 1 
		 */
		public var startColorBlue:Point;
		/**
		 * The range of the red component of each particle's ending color. Change the starting and ending
		 * colors in bulk using the <code>color</code> method.
		 * 
		 * @default 1 
		 */
		public var endColorRed:Point;
		/**
		 * The range of the green component of each particle's ending color. Change the starting and ending
		 * colors in bulk using the <code>color</code> method.
		 * 
		 * @default 1 
		 */
		public var endColorGreen:Point;
		/**
		 * The range of the blue component of each particle's ending color. Change the starting and ending
		 * colors in bulk using the <code>color</code> method.
		 * 
		 * @default 1 
		 */
		public var endColorBlue:Point;
		/**
		 * If using multiple particle types in your texture, this should represent the size of each particle
		 * frame. Use frame() to set the frame size and range together.
		 */ 
		public var frameSize:Point;
		/**
		 * If using multiple particle types in your texture, this is the range of possible particles that this
		 * effect can have. Use frame() to set the frame size and range together.
		 */
		public var frameRange:Point;
		/**
		 * The scroll factor to use for this effect.
		 */
		public var scroll:Point;

		/**
		 * The name of this particle effect. This is what you will use to emit particles of this type once
		 * registered. 
		 */
		public var name:String;
		/**
		 * The embedded image to use for this particle.
		 */
		public var resource:Texture;


		/**
		 * 
		 * @param name
		 * @param resource
		 * @param max
		 *
		 */
		public function ParticleEffect(name:String, resource:Texture) {
			this.name = name;
			this.resource = resource;


			// particle effect defaults, you only need to modify values that are different than these
			x = new Point(0, 0);
			y = new Point(0, 0);
			xVelocity = new Point(-100, 100);
			yVelocity = new Point(-100, 100);
			xAcceleration = new Point(0, 0);
			yAcceleration = new Point(0, 0);
			aVelocity = new Point(0, 0);
			startScale = new Point(1, 1);
			endScale = new Point(1, 1);
			startAlpha = new Point(1, 1);
			endAlpha = new Point(0, 0);
			lifetime = new Point(1, 2);
			amount = 10;
			blend = BLEND;
			startColorRed = new Point(1, 1);
			startColorGreen = new Point(1, 1);
			startColorBlue = new Point(1, 1);
			endColorRed = new Point(1, 1);
			endColorGreen = new Point(1, 1);
			endColorBlue = new Point(1, 1);
			frameSize = new Point(0, 0);
			frameRange = new Point(-1, -1);
			scroll = new Point(1, 1);
		}

		/**
		 * Changes the starting and ending colors in bulk. Note that while each is an SColor, the alpha component
		 * of these colors is not used. Use startAlpha and endAlpha to modify the starting and ending alpha values.
		 * 
		 * @param startMin The minimum starting value of each red/green/blue component of each particle.
		 * @param startMax The maximum starting value of each red/green/blue component of each particle.
		 * @param endMin The minimum ending value of each red/green/blue component of each particle.
		 * @param endMax The maximum ending value of each red/green/blue component of each particle.
		 *
		 * @return The particle effect.
		 */
		public function color(startMin:SColor = null, startMax:SColor = null, endMin:SColor = null, endMax:SColor = null):ParticleEffect {
			if (startMin != null) {
				startColorRed.x = startMin.red;
				startColorGreen.x = startMin.green;
				startColorBlue.x = startMin.blue;
			}

			if (startMax != null) {
				startColorRed.y = startMax.red;
				startColorGreen.y = startMax.green;
				startColorBlue.y = startMax.blue;
			}

			if (endMin != null) {
				endColorRed.x = endMin.red;
				endColorGreen.x = endMin.green;
				endColorBlue.x = endMin.blue;
			}

			if (endMax != null) {
				endColorRed.y = endMax.red;
				endColorGreen.y = endMax.green;
				endColorBlue.y = endMax.blue;
			}

			return this;
		}
		
		/**
		 * Sets the possible frames this particle can use. You can put multiple particles in your image, and using this,
		 * tell it to randomly use one of those particles. You must set the width and the height of each frame, otherwise
		 * it will use the entire image for the particle. If you do not set frameMin and frameMin, it will assume that
		 * it can be any possible particle in the spritesheet.
		 * 
		 * @param frameWidth The width of each frame in your particle sprite sheet.
		 * @param frameHeight The height of each frame in your particle sprite sheet.
		 * 
		 * @return The particle effect.
		 */
		public function frame(frameWidth:uint, frameHeight:uint, frameMin:int = -1, frameMax:int = -1):ParticleEffect {
			frameSize.x = frameWidth;
			frameSize.y = frameHeight;
			frameRange.x = frameMin;
			frameRange.y = frameMax;
			return this;
		}
	}
}
