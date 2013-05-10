package com.djoker.graphics 
{
	
	import flash.display.Bitmap;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
	import com.djoker.SP;
	
	import starling.display.Image;
    import starling.core.RenderSupport;
    import starling.textures.Texture;
    import starling.textures.TextureSmoothing;
    import starling.utils.VertexData;
	
	/**
	 * ...
	 * @author djoker
	 */
	public class Spritemap extends Image
	{
		public var complete:Boolean = true;
		
		public var callback:Function;
		public var rate:Number = 1;
		public var fixed:Boolean = true;
		public var FlipX:Boolean = false;
		public var FlipY:Boolean = false;
		
		
		
		
		public function Spritemap(texture:Texture,frameWidth:uint = 0, frameHeight:uint = 0, callback:Function = null) 
		{
			super(texture);
			width = frameWidth;
			height = frameHeight;
			pivotX = frameWidth  / 2;
            pivotY = frameHeight / 2;

		
		    _rect = new Rectangle(0, 0, frameWidth, frameHeight);
			if (!frameWidth) _rect.width = texture.width;
			if (!frameHeight) _rect.height = texture.height;
			_width = texture.width;
			_height = texture.height;
			_columns = Math.ceil(_width / _rect.width);
			_rows = Math.ceil(_height / _rect.height);
			_frameCount = _columns * _rows;
			this.callback = callback;
		 	updateBuffer();
			update();
			active = true;
		}
	
		public function play(name:String = "", reset:Boolean = false, frame:int = 0):Anim
		{
			if (!reset && _anim && _anim._name == name) return _anim;
			_anim = _anims[name];
			if (!_anim)
			{
				_frame = _index = 0;
				complete = true;
				updateBuffer();
				return null;
			}
			_index = 0;
			_timer = 0;
			_frame = uint(_anim._frames[frame % _anim._frameCount]);
			complete = false;
			updateBuffer();
			update();
			return _anim;
		}
		 public function updateBuffer(clearBefore:Boolean = false):void 
		{
			
			_rect.x = _rect.width * (_frame % _columns);
			_rect.y = _rect.height * uint(_frame / _columns);
			//if (_flipped) _rect.x = (_width - _rect.width) - _rect.x;
			
			//animrect = _rect;
			//SetImageFrame(_rect.x, _rect.y, _rect.width, _rect.height);
			SetImageFrameFlip(_rect.x, _rect.y, _rect.width, _rect.height,FlipX,FlipY);
		
		}
		
		override public  function update():void 
		{
		
		
		if (_anim && !complete)
			{
			_timer += (fixed ? _anim._frameRate : _anim._frameRate * SP.elapsed) * rate;
		
				if (_timer >= 1)
				{
					while (_timer >= 1)
					{
						_timer --;
						_index ++;
						if (_index == _anim._frameCount)
						{
							if (_anim._loop)
							{
								_index = 0;
								if (callback != null) callback();
							}
							else
							{
								_index = _anim._frameCount - 1;
								complete = true;
								if (callback != null) callback();
								break;
							}
						}
					}
					if (_anim) _frame = uint(_anim._frames[_index]);
					updateBuffer();
				}
			}
			
		//	trace( _frame+"<>"+SP.passedTime+"<>"+_timer+"<>"+(200 * SP.passedTime * rate));

			
		
					
		}
		
		
		public function add(name:String, frames:Array, frameRate:Number = 0, loop:Boolean = true):Anim
		{
			for (var i:int = 0; i < frames.length; i++) {
				frames[i] %= _frameCount;
				if (frames[i] < 0) frames[i] += _frameCount;
			}
			(_anims[name] = new Anim(name, frames, frameRate, loop))._parent = this;
			updateBuffer();
			update();
			return _anims[name];
		}
	
			public function addTo(name:String, count:int, frameRate:Number = 0, loop:Boolean = true):Anim
		{
			var frames:Array = new Array(count);
			for (var i:int = 0; i < frames.length; i++) 
			{
				frames[i] = i;
				
			}
			(_anims[name] = new Anim(name, frames, frameRate, loop))._parent = this;
			updateBuffer();
			update();
			return _anims[name];
		}
        public function getFrame(column:uint = 0, row:uint = 0):uint
		{
			return (row % _rows) * _columns + (column % _columns);
		}
		public function setFrame(column:uint = 0, row:uint = 0):void
		{
			_anim = null;
			var frame:uint = (row % _rows) * _columns + (column % _columns);
			if (_frame == frame) return;
			_frame = frame;
			_timer = 0;
			updateBuffer();
		}
		
		public function randFrame():void
		{
			frame = SP.randseed(_frameCount);
		}
		public function setAnimFrame(name:String, index:int):void
		{
			var frames:Array = _anims[name]._frames;
			index %= frames.length;
			if (index < 0) index += frames.length;
			frame = frames[index];
		}
		public function get frame():int { return _frame; }
		public function set frame(value:int):void
		{
			_anim = null;
			value %= _frameCount;
			if (value < 0) value = _frameCount + value;
			if (_frame == value) return;
			_frame = value;
			_timer = 0;
			updateBuffer();
		}
		public function get index():uint { return _anim ? _index : 0; }
		public function set index(value:uint):void
		{
			
			if (!_anim) return;
			value %= _anim._frameCount;
			if (_index == value) return;
			_index = value;
			_frame = uint(_anim._frames[_index]);
			_timer = 0;
			updateBuffer();
		}
		

		public function get frameCount():uint { return _frameCount; }
		
		/**
		 * Columns in the Spritemap.
		 */
		public function get columns():uint { return _columns; }
		
		/**
		 * Rows in the Spritemap.
		 */
		public function get rows():uint { return _rows; }
		
		/**
		 * The currently playing animation.
		 */
		public function get currentAnim():String { return _anim ? _anim._name : ""; }
		
	
		
		// Spritemap information.
		/** @private */ protected var _rect:Rectangle;
		/** @private */ public var _width:uint;
		/** @private */ public var _height:uint;
		/** @private */ public var _columns:uint;
		/** @private */ private var active:Boolean;
		/** @private */ public var _rows:uint;
		/** @private */ public var _frameCount:uint;
		/** @private */ private var _anims:Object = { };
		/** @private */ private var _anim:Anim;
		/** @private */ private var _index:uint;
		/** @private */ protected var _frame:uint;
		/** @private */ private var _timer:Number = 0;		
	}

  }

		  
	

