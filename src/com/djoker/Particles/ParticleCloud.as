package com.djoker.Particles {
	
	import starling.animation.IAnimatable;
	import com.djoker.Misc.SColor;
	
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DCompareMode;
  
    import flash.geom.Matrix;

	
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.VertexBuffer3D;
	
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.geom.Point;
    import flash.geom.Rectangle;
    
	
    import starling.core.RenderSupport;
    import starling.core.Starling;
	import starling.display.Sprite;
    import starling.core.starling_internal;
    import starling.errors.MissingContextError;
    import starling.events.Event;
    import starling.textures.Texture;
    import starling.textures.TextureSmoothing;
    import starling.utils.MatrixUtil;
    import starling.utils.VertexData;
	import starling.display.DisplayObject;
	import com.djoker.SP;


	public class ParticleCloud extends DisplayObject implements IAnimatable
	{
		

		public var active:Boolean;
		public var rowSize:uint;
		public var container:Sprite;
		
		protected var vertexShader:Array;
		protected var fragmentShader:Array;
		protected var indexData:Vector.<uint>;
		protected var indexBuffer:IndexBuffer3D;
		protected var vertexData:Vector.<Number>;
		protected var vertexBuffer:VertexBuffer3D;
		protected var context : Context3D;
		public var shader : Program3D;
		protected var triangles:uint;
		protected var colorTransform:Vector.<Number>;
		public var color:SColor;
		private var isloop:Boolean;
		
		 public var source:String;
		public var destination:String;
		public var dokill:Boolean;
		
	
	     public var texture:Texture;
		protected var effect:ParticleEffect;
		protected var tempVector:Vector.<Number>;
		public var time:Number;

		
		private function SetBlendMode(source:String, destination:String) :void
		{
			this.source = source;
			this.destination = destination;
		}
		
		private function BlendMode(value:int) :void
		{
		
	switch (value) 
	{
  case ParticleEffect.ADD:
	  SetBlendMode(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE);
  case ParticleEffect.BLEND:
	  SetBlendMode(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
  case ParticleEffect.FILTER:
	  SetBlendMode(Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ZERO);
  case ParticleEffect.MODULATE:
	  SetBlendMode(Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.ZERO);
  case ParticleEffect.NONE:
	  SetBlendMode(Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE);
  case ParticleEffect.PARTICLE: 
	  SetBlendMode(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE);

    }
  }
		
		
		public function ParticleCloud(effect:ParticleEffect) 
		{
			this.effect = effect;
			BlendMode(effect.blend);
			colorTransform = new Vector.<Number>(4, true);
		    colorTransform[0] = colorTransform[1] = colorTransform[2] = colorTransform[3] = 1;
			rowSize=19;
			tempVector = new Vector.<Number>(4, true);
			time = 0;
			visible = false;
			active = false;
			color = new SColor;
  		    context = Starling.context;
			isloop = false;
			dokill = false;
		  if (context == null) throw new MissingContextError();
			
		}

		
		
        protected function setupShaders(vertexShader:Array, fragmentShader:Array) : void
        {
	
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble(Context3DProgramType.VERTEX, vertexShader.join("\n"));

			var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentShader.join("\n"));


            shader = context.createProgram();
            shader.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode );
			
		
        }
 
			public function clone():ParticleCloud {
			var other:ParticleCloud = new ParticleCloud(effect);
			other.texture = texture;
			other.shader = shader;
			return other.build();
		}
		
		public function randomNumber(p:Point):Number {
			return SP.randomrange(p.x * 1000, p.y * 1000) / 1000;
		}
		
		/**
		 * Builds the necessary geometry required to draw this particle cloud.
		 *
		 * @return The particle cloud instance.
		 */
		public function build():ParticleCloud 
		{
		
			texture = effect.resource;

			indexData = new Vector.<uint>;
			vertexData = new Vector.<Number>;
			
			var frameWidth:uint = effect.frameSize.x == 0 ? texture.rawWidth : effect.frameSize.x;
			var frameHeight:uint = effect.frameSize.y == 0 ? texture.rawHeight : effect.frameSize.y;
			var uvWidth:Number = frameWidth / texture.width;
			var uvHeight:Number = frameHeight / texture.height;
			var columns:uint = Math.floor(texture.rawWidth / frameWidth);
			var rows:uint = Math.floor(texture.rawHeight / frameHeight);
			var lastFrameIndex:uint = columns * rows - 1;

			for (var i:uint = 0; i < effect.amount; i++) 
			{
				var index:uint = i * 4;
				var tx:int = SP.rand(effect.x.x, effect.x.y);
				var ty:int = SP.rand(effect.y.x, effect.y.y);
				
				var vx:Number =  randomNumber(effect.xVelocity);
				var vy:Number =  randomNumber(effect.yVelocity);
				var ax:Number =  randomNumber(effect.xAcceleration);
				var ay:Number =  randomNumber(effect.yAcceleration);
				var life:Number = randomNumber( effect.lifetime);
				var ssc:Number =  randomNumber(effect.startScale);
				var esc:Number =  randomNumber(effect.endScale);
				var csr:Number =  randomNumber(effect.startColorRed);
				var csg:Number = randomNumber( effect.startColorGreen);
				var csb:Number =  randomNumber(effect.startColorBlue);
				var csa:Number = randomNumber( effect.startAlpha);
				var cer:Number = randomNumber( effect.endColorRed);
				var ceg:Number =  randomNumber(effect.endColorGreen);
				var ceb:Number =  randomNumber(effect.endColorBlue);
				var cea:Number = randomNumber( effect.endAlpha);
				
				var frame:uint;
				if (effect.frameRange.x < 0 || effect.frameRange.y < 0) {
					frame = SP.rand(0, lastFrameIndex); 
				} else {
					frame = randomNumber(effect.frameRange);
				}
				
				var frameRow:uint = frame / columns;
				var frameCol:uint = frame % columns;
				var u:Number = frameCol * frameWidth / texture.width;
				var v:Number = frameRow * frameHeight / texture.height;
				
				indexData.push(index, index + 1, index + 2, index + 1, index + 2, index + 3);
				vertexData.push(
					tx, 				ty, 				u,				v,				vx, vy, ax, ay, ssc, esc, life, csr, csg, csb, csa, cer, ceg, ceb, cea,
					tx + frameWidth, 	ty, 				u + uvWidth,	v, 				vx, vy, ax, ay, ssc, esc, life, csr, csg, csb, csa, cer, ceg, ceb, cea,
					tx, 				ty + frameHeight, 	u, 				v + uvHeight, 	vx, vy, ax, ay, ssc, esc, life, csr, csg, csb, csa, cer, ceg, ceb, cea,
					tx + frameWidth, 	ty + frameHeight, 	u + uvWidth, 	v + uvHeight, 	vx, vy, ax, ay, ssc, esc, life, csr, csg, csb, csa, cer, ceg, ceb, cea
				);
			}

			setupShaders(VERTEX_SHADER,FRAGMENT_SHADER);
			var vertexLength:uint = vertexData.length / rowSize;
			indexBuffer = context.createIndexBuffer(indexData.length);
			indexBuffer.uploadFromVector(indexData, 0, indexData.length);
			vertexBuffer = context.createVertexBuffer(vertexLength, rowSize);
			vertexBuffer.uploadFromVector(vertexData, 0, vertexLength);
			triangles = indexData.length / 3;


			return this;
		}

		override public function dispose():void 
		{
			active = false;
			SP.juggler.remove(this);
			if (container)
			{
				container.removeChild(this, false);
			}
		//	trace("free particles");
			//super.dispose();
		}
		
		 public function advanceTime(dt:Number):void
		 {
			 if (dokill)
			 {
				 	active = false;
					visible = false;
					return;
			 }

			 
			if (time > effect.lifetime.y) 
			{
				if (this.isloop)
				{
					time = 0;
					this.active = true;
			        this.visible = true;
					return;
				} 
				else
				{
					active = false;
					visible = false;
					return;
				}
				
			}

				time += dt;
		}

		/**
		 * Moves the cloud to the passed location, and resets it so that it begins drawing the effect from the
		 * beginning.
		 * 
		 * @param x The x-coordinate in world space.
		 * @param y The y-coordinate in world space.
		 */
		public function reset(x:Number, y:Number,loop:Boolean ):void {
			this.x = x;
			this.y = y;
			this.time = 0;
			this.active = true;
			this.visible = true;
			this.isloop = loop;
		}

		public function move(x:Number, y:Number ):void {
			this.x = x;
			this.y = y;

		}	
		public override function render(support:RenderSupport, alpha:Number):void
        {
		if (context == null) throw new MissingContextError();
		
		    if (!active || !visible) return;
	     	colorTransform[0]   = color.red;
			colorTransform[1] =   color.green;
			colorTransform[2]  =  color.blue;
			colorTransform[3] =   color.alpha;
			
		
			

			context.setProgram(shader);
			context.setTextureAt(0, texture.base);
			context.setBlendFactors(source, destination);
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, support.mvpMatrix3D, true);

			tempVector[0] = time;
			tempVector[1] = time;
			tempVector[2] = time;
			tempVector[3] = time;
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, tempVector);

			tempVector[0] = 0.5 * time * time;
			tempVector[1] = tempVector[0];
			tempVector[2] = tempVector[0];
			tempVector[3] = tempVector[0];
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, tempVector);
			
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, colorTransform);
			context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2);
			context.setVertexBufferAt(2, vertexBuffer, 4, Context3DVertexBufferFormat.FLOAT_2);
			context.setVertexBufferAt(3, vertexBuffer, 6, Context3DVertexBufferFormat.FLOAT_2);
			context.setVertexBufferAt(4, vertexBuffer, 8, Context3DVertexBufferFormat.FLOAT_2);
			context.setVertexBufferAt(5, vertexBuffer, 10, Context3DVertexBufferFormat.FLOAT_1);
			context.setVertexBufferAt(6, vertexBuffer, 11, Context3DVertexBufferFormat.FLOAT_4);
			context.setVertexBufferAt(7, vertexBuffer, 15, Context3DVertexBufferFormat.FLOAT_4);
			context.drawTriangles(indexBuffer, 0, triangles);
			Starling.counttris += triangles ;
			context.setVertexBufferAt(0, null, 0, Context3DVertexBufferFormat.FLOAT_2);
			context.setVertexBufferAt(1, null, 2, Context3DVertexBufferFormat.FLOAT_2);
			context.setVertexBufferAt(2, null, 4, Context3DVertexBufferFormat.FLOAT_2);
			context.setVertexBufferAt(3, null, 6, Context3DVertexBufferFormat.FLOAT_2);
			context.setVertexBufferAt(4, null, 8, Context3DVertexBufferFormat.FLOAT_1);
			context.setVertexBufferAt(5, null, 10, Context3DVertexBufferFormat.FLOAT_1);
			context.setVertexBufferAt(6, null, 10, Context3DVertexBufferFormat.FLOAT_4);
			context.setVertexBufferAt(7, null, 10, Context3DVertexBufferFormat.FLOAT_4);
	
		}
	
		

		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
        {
            var matrix:Matrix = getTransformationMatrix(targetSpace);
            var position:Point = matrix.transformPoint(new Point(x, y));
            return new Rectangle(position.x, position.y);
        }
		
		/**
		 * The vertex shader used to draw particle clouds. 
		 */
		public static const VERTEX_SHADER:Array =
		[
			"mov v1, 		va1", 					// copy uv to fragment shader
			"mov vt0, 		va0", 					// move x, y to vt0
			"mul vt1, 		va2, 		vc4",		// multiply velocity by time, vt1
			"add vt0.xy, 	vt0.xy,		vt1.xy", 	// add dx.xy to position.xy, vt0
			"mul vt1,		va3,		vc5", 		// multiply acceleration by 0.5t^2, vt1
			"add vt0.xy,	vt0.xy,		vt1.xy", 	// add dx.xy to position.xy, vt0
			"div vt2,		vc4,		va5", 		// divide time lived by lifetime
			"sat vt2,		vt2", 					// clamp between 0 and 1, vt2.x = progress
			"sub vt3.y,		va4.x,		va4.y", 	// find total amount scale should change, vt3.y
			"mul vt3.y,		vt3.y,		vt2.x", 	// multiply progress by scale change
			"mov vt3.z,		va4.x", 				// move start scale into vt3.z
			"sub vt3.z,		vt3.z, 		vt3.y", 	// subtract end scale from vt3.z
			"mul vt0.x,     vt0.x,		vt3.z", 	// multiply current scale by x
			"mul vt0.y,     vt0.y,		vt3.z", 	// multiply current scale by y
			"sub vt4,		va6,		va7", 		// find how much each color component should change
			"mul vt4,		vt4,		vt2.xxxx", 	// find how much it has changed so far
			"sub v2,		va6,		vt4", 		// subtract how much it has changed from the start value to get current value
			"m44 op, 		vt0, 		vc0"	 	// multiply by global transformation
		];
		
	
		public static const FRAGMENT_SHADER:Array = 
		[
			"tex ft0, v1, fs0 <2d,nearest,mipnone>",
			"mul oc, ft0, v2",
		];
	}
}
