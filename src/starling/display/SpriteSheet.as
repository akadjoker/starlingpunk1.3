

package  starling.display
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Stage;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.textures.Texture;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Matrix;
    
    public class SpriteSheet
    {
        internal var _texture : Texture;
        
        protected var _spriteSheet : BitmapData;    
        protected var _uvCoords : Vector.<Number>;
        protected var _rects : Vector.<Rectangle>;
        
        public function SpriteSheet(SpriteSheetBitmapData:BitmapData, numSpritesW:int = 8, numSpritesH:int = 8)
        {
            _uvCoords = new Vector.<Number>();
            _rects = new Vector.<Rectangle>();
			_spriteSheet = fromBitmapData(SpriteSheetBitmapData);
			createUVs(numSpritesW, numSpritesH);
		}
		
		
		   public  function fromBitmapData(data:BitmapData):BitmapData
        {
            var origWidth:int   = data.width;
            var origHeight:int  = data.height;
            var legalWidth:int  = getNextPowerOfTwo(origWidth);
            var legalHeight:int = getNextPowerOfTwo(origHeight);
              var potData:BitmapData;

            
            if (legalWidth > origWidth || legalHeight > origHeight)
            {
                potData = new BitmapData(legalWidth, legalHeight, true, 0);
                potData.copyPixels(data, data.rect, new Point(0, 0));
                data = potData;
            }
            
        return data;
         
        }

   private function getNextPowerOfTwo(number:int):int
    {
        if (number > 0 && (number & (number - 1)) == 0) // see: http://goo.gl/D9kPj
            return number;
        else
        {
            var result:int = 1;
            while (result < number) result <<= 1;
            return result;
        }
    }
        // generate a list of uv coordinates for a grid of sprites
		// on the spritesheet texture for later reference by ID number
		// sprite ID numbers go from left to right then down
		public function createUVs(numSpritesW:int, numSpritesH:int) : void
        {
			var tileWidth:int = _spriteSheet.width / numSpritesW;
			var tileHeight:int = _spriteSheet.height / numSpritesH;
			
			trace('creating a '+_spriteSheet.width+'x'+_spriteSheet.height+
				' spritesheet texture with '+numSpritesW+'x'+ numSpritesH+' sprites '+' tile width '+tileWidth+' tileheight '+tileHeight);
	
			var destRect : Rectangle;
	
					
			for (var y:int = 0; y < numSpritesH; y++)
			{
			for (var x:int = 0; x < numSpritesW; x++)
				
				{
					
					var rect:Rectangle = new Rectangle(x * tileWidth, y * tileHeight, tileWidth, tileHeight);
					
					_uvCoords.push(
						// bl, tl, tr, br	
						 x / numSpritesW, (y+1) / numSpritesH,
						 x / numSpritesW, y / numSpritesH,
						 (x + 1) / numSpritesW, y / numSpritesH,
						 (x + 1) / numSpritesW, (y + 1) / numSpritesH);
						
					    destRect = new Rectangle();
						destRect.left = 0;
						destRect.top = 0;
						destRect.right = _spriteSheet.width / numSpritesW;
						destRect.bottom = _spriteSheet.height / numSpritesH;
						_rects.push(destRect);					
				}
			}
        }

		// when the automated grid isn't what we want
		// we can define any rectangle and return a new sprite ID
		public function defineSprite(x:uint, y:uint, w:uint, h:uint) : uint
		{
			var destRect:Rectangle = new Rectangle();
			destRect.left = x;
			destRect.top = y;
			destRect.right = x + w;
			destRect.bottom = y + h;
			_rects.push(destRect);
				
			_uvCoords.push(
                destRect.x/_spriteSheet.width, destRect.y/_spriteSheet.height + destRect.height/_spriteSheet.height,
                destRect.x/_spriteSheet.width, destRect.y/_spriteSheet.height,
                destRect.x/_spriteSheet.width + destRect.width/_spriteSheet.width, destRect.y/_spriteSheet.height,
                destRect.x/_spriteSheet.width + destRect.width/_spriteSheet.width, destRect.y/_spriteSheet.height + destRect.height/_spriteSheet.height);				
			
			return _rects.length - 1;
		}
		
        public function removeSprite(spriteId:uint) : void
        {
            if ( spriteId < _uvCoords.length ) {
                _uvCoords = _uvCoords.splice(spriteId * 8, 8);
                _rects.splice(spriteId, 1);
            }
        }

        public function get numSprites() : uint
        {
            return _rects.length;
        }

        public function getRect(spriteId:uint) : Rectangle
        {
            return _rects[spriteId];
        }
        
        public function getUVCoords(spriteId:uint) : Vector.<Number>
        {
            var startIdx:uint = spriteId * 8;
            return _uvCoords.slice(startIdx, startIdx + 8);
        }
        
        public function uploadTexture(context3D:Context3D) : void
        {
            if ( _texture == null ) {
                _texture = context3D.createTexture(_spriteSheet.width, _spriteSheet.height, Context3DTextureFormat.BGRA, false);
            }
 
            _texture.uploadFromBitmapData(_spriteSheet);
            
            // generate mipmaps
            var currentWidth:int = _spriteSheet.width >> 1;
            var currentHeight:int = _spriteSheet.height >> 1;
            var level:int = 1;
            var canvas:BitmapData = new BitmapData(currentWidth, currentHeight, true, 0);
            var transform:Matrix = new Matrix(.5, 0, 0, .5);
            
            while ( currentWidth >= 1 || currentHeight >= 1 ) {
                canvas.fillRect(new Rectangle(0, 0, Math.max(currentWidth,1), Math.max(currentHeight,1)), 0);
                canvas.draw(_spriteSheet, transform, null, null, null, true);
                _texture.uploadFromBitmapData(canvas, level++);
                transform.scale(0.5, 0.5);
                currentWidth = currentWidth >> 1;
                currentHeight = currentHeight >> 1;
            }
        }
    } // end class
} // end package