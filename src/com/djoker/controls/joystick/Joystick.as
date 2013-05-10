package com.djoker.controls.joystick
{

	import com.djoker.tween.Tweener;
	import com.djoker.tween.misc.VarTween;
	import com.djoker.tween.Ease;

	
	import com.djoker.SP;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.animation.IAnimatable;
	
	
	import starling.animation.Tween;
	import starling.animation.Transitions;
	
	
	
	

	/**
	 *
	 * @author djoker
	 *
	 */
	public class Joystick extends Sprite //implements IAnimatable
	{
		
		

		


		private var _align:String = JoystickAlign.BOTTOM_LEFT;

		private var _allowHorizontalMovement:Boolean = true;

		private var _allowVerticalMovement:Boolean = true;

		private var _baseImage:Image;

		private var _centerX:int;

		private var _centerY:int;

		private var _down:Rectangle;

		private var _downLeft:Rectangle;

		private var _downRight:Rectangle;

	
		private var _hideWhenInactive:Boolean = false;

		private var _isPressed:Boolean = false;

		private var _knob:JoystickKnob;

	
		private var _left:Rectangle;

		private var _marginX:int;

		private var _marginY:int;

		private var _movementArea:Rectangle;

		private var _right:Rectangle;

		private var _up:Rectangle;

		private var _upLeft:Rectangle;

		private var _upRight:Rectangle;
		
		
		private var xTween:VarTween;
		private var yTween:VarTween;
		public var tween:Tweener;
		
		private var _time:uint;
		private var _updateTime:uint;
		private var _gameTime:uint;
		
		private var _vx:Number = 0;
		private var _vy:Number = 0;
		private var _spring:Number = 400;
		private var _friction:Number = 0.0005;
		
		
		
		
	

		public override function dispose():void
		{
			super.dispose();
			//SP.juggler.remove(this);
		tween.dispose();
		xTween = null;
		yTween = null;
		tween = null;
		
		
		}
		/**
		 *
		 * @param baseTexture
		 * @param knobTexture
		 *
		 */
		public function Joystick(baseTexture:Texture, knobTexture:Texture)
		{
			super();
			 
			_baseImage = new Image(baseTexture);
			_baseImage.scrollFactorX = 0;
			_baseImage.scrollFactorY = 0;
			_knob = new JoystickKnob(knobTexture);
			_knob.scrollFactorX = 0;
			_knob.scrollFactorY= 0;
			
		
			_time = _gameTime = getTimer();
			
			addChild(_baseImage);
			addChild(_knob);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_baseImage.addEventListener(TouchEvent.TOUCH, onTouch);
	
			
			if (_hideWhenInactive)
			{
			                var fadetween:Tween;	
				            fadetween = new Tween(this, 2.0, Transitions.EASE_OUT);
			                fadetween.animate("alpha", 0);
			                SP.juggler.add(fadetween);
			}
			//SP.juggler.add(this);
		}

			protected function onBounceIn():void
		{
	
		}

		/**
		 * Alignment of the joystick.
		 * @return
		 * @see JoystickAligment
		 *
		 */
		public function get align():String
		{
			return _align;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set align(value:String):void
		{
			_align = value;
		}


		public function get allowHorizontalMovement():Boolean
		{
			return _allowHorizontalMovement;
		}

		public function set allowHorizontalMovement(value:Boolean):void
		{
			_allowHorizontalMovement = value;
		}

		public function get allowVerticalMovement():Boolean
		{
			return _allowVerticalMovement;
		}

		public function set allowVerticalMovement(value:Boolean):void
		{
			_allowVerticalMovement = value;
		}

		/**
		 * Hides the joystick when it is not in use.
		 * @return
		 *
		 */
		public function get hideWhenInactive():Boolean
		{
			return _hideWhenInactive;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set hideWhenInactive(value:Boolean):void
		{
			_hideWhenInactive = value;
			alpha = 0;
		}

		/**
		 *
		 * @return
		 *
		 */
		public function get marginX():int
		{
			return _marginX;
		}

		/**
		 *
		 * @param value
		 *
		 */
		public function set marginX(value:int):void
		{
			_marginX = value;
		}

		/**
		 * Margin from the edge of stage in x-axis.
		 * @return
		 *
		 */
		public function get marginY():int
		{
			return _marginY;
		}

		/**
		 * Margin from the edge of stage in y-axis.
		 * @param value
		 *
		 */
		public function set marginY(value:int):void
		{
			_marginY = value;
		}

		/**
		 * Offset of the joystick knob in normalized vector between -1 and -1. This can be used to control movement more precisely.
		 * @return
		 *
		 */
		public function get offset():Point
		{
			return new Point(((_knob.originX - _knob.x) / (_movementArea.width >> 1)) * -1, ((_knob.originY - _knob.y) / (_movementArea.height >> 1)) * -1);
		}

		/**
		 * State of the joystick.
		 * @return
		 * @see JoystickState
		 *
		 */
		public function get state():String
		{
			if (_isPressed)
			{
				if (_right.contains(_knob.x, _knob.y))
				{
					return JoystickState.RIGHT;
				}
				else if (_left.contains(_knob.x, _knob.y))
				{
					return JoystickState.LEFT;
				}
				else if (_up.contains(_knob.x, _knob.y))
				{
					return JoystickState.UP;
				}
				else if (_down.contains(_knob.x, _knob.y))
				{
					return JoystickState.DOWN;
				}
				else if (_upRight.contains(_knob.x, _knob.y))
				{
					return JoystickState.UP_RIGHT;
				}
				else if (_downRight.contains(_knob.x, _knob.y))
				{
					return JoystickState.DOWN_RIGHT;
				}
				else if (_downLeft.contains(_knob.x, _knob.y))
				{
					return JoystickState.DOWN_LEFT
				}
				else if (_upLeft.contains(_knob.x, _knob.y))
				{
					return JoystickState.UP_LEFT
				}
			}

			return JoystickState.CENTER;
		}

		
		private function alignJoystick():void
		{
			switch (_align)
			{

				case JoystickAlign.TOP_LEFT:
				{
					_baseImage.x = 0 + marginX;
					_baseImage.y = 0 + marginY;
					break;
				}

				case JoystickAlign.TOP_RIGHT:
				{
					_baseImage.x = Starling.current.stage.stageWidth - _baseImage.width - marginX;
					_baseImage.y = 0 + marginY;
					break;
				}

				case JoystickAlign.BOTTOM_RIGHT:
				{
					_baseImage.x = Starling.current.stage.stageWidth - _baseImage.width - marginX;
					_baseImage.y = Starling.current.stage.stageHeight - _baseImage.height - marginY;
					break;
				}

				default:
				case JoystickAlign.BOTTOM_LEFT:
				{
					_baseImage.x = 0 + marginX;
					_baseImage.y = Starling.current.stage.stageHeight - _baseImage.height - marginY;
					break;
				}
			}
			
	
	

			_centerX = _baseImage.x + (_baseImage.width >> 1);
			_centerY = _baseImage.y + (_baseImage.height >> 1);
			_knob.originX = _centerX;
			_knob.originY = _centerY;
			_knob.x = _knob.originX;
			_knob.y = _knob.originY;
			var knobHalfWidth:Number = _knob.width >> 1;
			var knobHalfHeight:Number = _knob.height >> 1;
			var touchAreaHeight:Number = _baseImage.height / 3;
			var touchAreaWidth:Number = _baseImage.width / 3;
			_movementArea = new Rectangle(_baseImage.x + knobHalfWidth, _baseImage.y + knobHalfHeight, _baseImage.width - _knob.width, _baseImage.height - _knob.height);
			_upLeft = new Rectangle(_baseImage.x, _baseImage.y, touchAreaWidth, touchAreaHeight);
			_up = new Rectangle(_upLeft.right, _baseImage.y, touchAreaWidth, touchAreaHeight);
			_upRight = new Rectangle(_up.right, _baseImage.y, touchAreaWidth, touchAreaHeight);
			_left = new Rectangle(_baseImage.x, _upRight.bottom, touchAreaWidth, touchAreaHeight);
			_right = new Rectangle(_up.right, _left.y, touchAreaWidth, touchAreaHeight);
			_downLeft = new Rectangle(_left.x, _left.bottom, touchAreaWidth, touchAreaHeight);
			_down = new Rectangle(_downLeft.right, _downLeft.y, touchAreaWidth, touchAreaHeight);
			_downRight = new Rectangle(_down.right, _down.y, touchAreaWidth, touchAreaHeight);
			
			
			tween = new Tweener();
			xTween = new VarTween();
			tween.addTween(xTween, false);
			yTween = new VarTween();
			tween.addTween(yTween, false);
            SP.juggler.add(tween);
		
			
		}

		private function onAddedToStage(event:Event):void
		{
			alignJoystick();
		}



		
		public function advanceTime(passedTime:Number):void
		{
		
		//	tween.updateTweens();
			/*
			if (!_isPressed)
			{
				
				
			  _vx += (_centerX - _knob.x) * _spring; //'spring': elastic coefficient
              _vy += (_centerY - _knob.y) * _spring;
 
               _knob.x += (_vx *= _friction); //'friction': friction force
               _knob.y += (_vy *= _friction); 

			}
			
			*/
			/*	
	_ox=_centerX-_knob.x;
    _oy=_centerY-_knob.y;
    _oy=_oy-_sy;
    _ox=_ox-_sx;
    _sy=_sy+_oy;
    _sx=_sx+_ox;
	
  _knob.x=_knob.x+_sx*(Starling.dt*10);
  _knob.y=_knob.y+_sy*(Starling.dt*10);
  */
				
			
		}
		
		
		private function onTouch(event:TouchEvent):void
		{
			 var fadetween:Tween = null;	
					
			for (var i:int = 0; i < event.getTouches(this).length; ++i)
			{
				var touch:Touch = event.getTouches(this)[i];
				if (touch.phase == TouchPhase.BEGAN)
				{
					_isPressed = true;
				
					
				}
				else if (touch.phase == TouchPhase.ENDED)
				{
					_isPressed = false;
			/*	
			 var stween:Tween;		
            stween = new Tween(_knob, 0.5, Transitions.EASE_OUT_BOUNCE);
		    stween.animate("y", _centerY);
			stween.animate("x",_centerX);
			SP.juggler.add(stween);
		*/	
	
	            xTween.tween(_knob, "x", _centerX, 0.5, Ease.bounceOut);
		    	yTween.tween(_knob, "y", _centerY, 0.5, Ease.bounceOut);
					
					//_knobTween = new TweenLite(_knob, 0.5, {x: _knob.originX, y: _knob.originY, ease: Bounce.easeOut});
				}
			}

			if (_isPressed)
			{
				if (hideWhenInactive && alpha < 1)
				{
                           
							fadetween = new Tween(this, 2.0, Transitions.EASE_OUT);
			                fadetween.animate("alpha", 1);
			                SP.juggler.add(fadetween);
			
	
			
				}

				touch = event.getTouches(this)[0];

				if (_allowHorizontalMovement)
				{
					_knob.x = touch.globalX;

					if (touch.globalX < _movementArea.left)
					{
						_knob.x = _movementArea.left;
					}
					else if (touch.globalX > _movementArea.right)
					{
						_knob.x = _movementArea.right;
					}
				}

				if (_allowVerticalMovement)
				{
					_knob.y = touch.globalY;

					if (touch.globalY < _movementArea.top)
					{
						_knob.y = _movementArea.top;
					}
					else if (touch.globalY > _movementArea.bottom)
					{
						_knob.y = _movementArea.bottom;
					}
				}
			}
			else if (hideWhenInactive && alpha > 0)
			{
				           // var fadetween:Tween;	
				            fadetween = new Tween(this, 2.0, Transitions.EASE_OUT);
			                fadetween.animate("alpha", 0);
			                SP.juggler.add(fadetween);
				
				//_fadeTween.reverse();
			}
			
		}
	}
}
