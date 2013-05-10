package com.djoker.graphics 
{
	
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display.Bitmap;
	
	
    
    import flash.display3D.Context3D;
	import flash.display3D.Program3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DCompareMode;
  

    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.VertexBuffer3D;
    import flash.geom.Matrix;
    import flash.geom.Matrix3D;
	import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    
    import starling.core.RenderSupport;
    import starling.core.Starling;
    import starling.core.starling_internal;
    import starling.errors.MissingContextError;
    import starling.events.Event;
    import starling.textures.Texture;
    import starling.textures.TextureSmoothing;
    import starling.utils.MatrixUtil;
    import starling.utils.VertexData;
	import starling.display.DisplayObject;
	import com.djoker.SP;
    
    use namespace starling_internal;
	
	/**
	 * ...
	 * @author djoker
	 */
	public class TilesBatch extends DisplayObject 
	{
     
				public var solidIndex:uint;

		/**
		 * The width of each tile in the tilemap.
		 */
		protected var tileWidth:uint;
		/**
		 * The height of each tile in the tilemap.
		 */
		protected var tileHeight:uint;
		/**
		 * The number of rows in the tiles image.
		 */
		protected var tileRows:uint;
		/**
		 * The number of columns in the tiles image.
		 */
		protected var tileCols:uint;
		/**
		 * The number of rows in the map.
		 */
		protected var rows:uint;
		/**
		 * The number of columns in the map.
		 */
		protected var cols:uint;
		/**
		 * The list of tiles, one for each type of tile in the tiles image.
		 */
		//protected var tiles:Vector.<STile>;
		/**
		 * The list of tiles in the map. Each one is an index into the tiles vector. 
		 */
		protected var data:Vector.<uint>;

		/**
		 * The frame used to calculate collisions against other objects.
		 */
		protected var frame:Rectangle;
		

        protected var _context3D : Context3D;


        protected var _indexBuffer : IndexBuffer3D;
        protected var _vertexBuffer : VertexBuffer3D;
        protected var _uvBuffer : VertexBuffer3D;
        protected var _shader : Program3D;
        protected var _updateVBOs : Boolean;
		protected var _modelViewMatrix : Matrix3D;

	
		protected var vertexShader:Array;
		protected var fragmentShader:Array;
		protected var indexData:Vector.<uint>;
		protected var indexBuffer:IndexBuffer3D;
		protected var vertexData:Vector.<Number>;
		protected var vertexBuffer:VertexBuffer3D;
		protected var triangles:uint;
		protected var colorTransform:Vector.<Number>;
		public var texture:Texture;
		public var countTris:Boolean;
		public var rowSize:uint;

		
		
		
		public function TilesBatch(mapString:String, graphic:Bitmap, tileWidth:uint, tileHeight:uint, solidIndex:uint = 1) 
		{
			
		    _context3D = Starling.context;
			
	
			
			  if (_context3D == null) throw new MissingContextError();
			
			colorTransform = new Vector.<Number>(4, true);
			colorTransform[0] = colorTransform[1] = colorTransform[2] = colorTransform[3] = 1;
	
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			this.solidIndex = solidIndex;
			
			texture = Texture.fromBitmap(graphic);


	        this.tileCols = Math.floor(texture.rawWidth / tileWidth);
			this.tileRows = Math.floor(texture.rawHeight / tileHeight);
		//	this.tiles = new Vector.<STile>;
			this.data = new Vector.<uint>;

			indexData = new Vector.<uint>;
			vertexData = new Vector.<Number>;

			var rowArray:Array = mapString.split("\n");
			var index:uint = 0;
			var uvWidth:Number = 1 / (texture.Width / tileWidth);
			var uvHeight:Number = 1 / (texture.Height / tileWidth);
			
		//	trace(uvWidth + "u<>v" + uvHeight);
		//	trace(texture.Width + "w<>h" + texture.Height);
		//	trace(texture.rawWidth + "rw<>rh" + texture.rawHeight);
		
			
			//var uvWidth:Number = 0.09375;
			//var uvHeight:Number = 0.09375;
			

			
			
	
			rows = rowArray.length;
			for (var y:uint = 0; y < rows; y++)
			{
				var row:Array = rowArray[y].split(",");
				cols = Math.max(cols, row.length);
				for (var x:uint = 0; x < cols; x++)
				{
					var tid:uint = row[x];
					if (tid == 0) 
					{
						data.push(0);
						continue;
					}
				
					data.push(tid);
					tid -= 1;
					
					var tx:uint = x * tileWidth;
					var ty:uint = y * tileHeight;
					var u:Number = (tid % tileCols) * uvWidth;
					var v:Number = Math.floor(tid / tileCols) * uvHeight;
					
	
					
					var EPSILON:Number = 0.0001;
					
				
					
					indexData.push(index, index + 1, index + 2, index + 1, index + 2, index + 3);
					vertexData.push(
						tx + EPSILON, 	ty + EPSILON,	u,				v,
						tx + tileWidth,		ty + EPSILON,	u + uvWidth,	v,
						tx + EPSILON,	ty + tileHeight,	u,				v + uvHeight,
						tx + tileWidth,		ty + tileHeight,	u + uvWidth,	v + uvHeight
					);
					index += 4;
				}
			}
			rowSize = 4;

			setupShaders();
			var vertexLength:uint = vertexData.length / rowSize;
			indexBuffer =_context3D.createIndexBuffer(indexData.length);
			indexBuffer.uploadFromVector(indexData, 0, indexData.length);
			vertexBuffer = _context3D.createVertexBuffer(vertexLength, rowSize);
			vertexBuffer.uploadFromVector(vertexData, 0, vertexLength);
			triangles = indexData.length / 3;

			width = cols * tileWidth;
			height = rows * tileHeight;
/*
			tiles.push(null);
			for (index = 1; index <= tileCols * tileRows; index++)
			{ 
				var tile:STile = new STile(this, index, tileWidth, tileHeight);
				tiles.push(tile);
			}

			
			trace (width+"<>"+height);
*/
        }
        
      
   

 
  

        protected function setupShaders() : void
        {
			
			     var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
              vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
                 "mov v1, va1 \n"+ 
                "m44 op, va0, vc0"	
                
            );
			
            var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
                "tex ft0, v1, fs0 <2d,nearest,mipnone> \n"+ 
				"mul oc, fc0, ft0"
     
            );
			
            
            _shader = _context3D.createProgram();
            _shader.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode );
			
		
        }
 
        
       
									 
		
		public function draw() : void
        {
			
        }
		
		 public override function dispose():void
        {
        
            vertexShader = null;
			fragmentShader = null;
			indexData = null;
			indexBuffer = null;
			vertexData = null;
			vertexBuffer = null;
			_shader = null;
			
			colorTransform = null;
			texture = null;
			
            super.dispose();
        }
		
		
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
        {
            var matrix:Matrix = getTransformationMatrix(targetSpace);
            var position:Point = matrix.transformPoint(new Point(x, y));
            return new Rectangle(position.x, position.y);
        }
		
		public override function render(support:RenderSupport, alpha:Number):void
        {
			  if (_context3D == null) throw new MissingContextError();
	

			 //  support.finishQuadBatch(); // (1)
 
  
             //      support.raiseDrawCount(1); // (2)

			
			colorTransform[0] = 1;// color.red;
			colorTransform[1] = 1;// color.green;
			colorTransform[2] = 1;// color.blue;
			colorTransform[3] = alpha;// color.alpha;

			_context3D.setProgram(_shader);
			_context3D.setTextureAt(0, texture.base);
			_context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		//	_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, Starling.current.mSupport.mvpMatrix3D, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, support.mvpMatrix3D, true);
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, colorTransform);
			_context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context3D.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2);
			_context3D.drawTriangles(indexBuffer, 0, triangles);
			
	
			Starling.counttris += triangles ;
			
			_context3D.setTextureAt(1, null);
            _context3D.setVertexBufferAt(0, null);
            _context3D.setVertexBufferAt(1, null);
          //  _context3D.setVertexBufferAt(2, null);
	
		}
    } // end class
} // end package