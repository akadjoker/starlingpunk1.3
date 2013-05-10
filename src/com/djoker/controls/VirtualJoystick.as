package com.djoker.controls {



	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	import flash.display.BitmapData;
	import flash.display.Sprite;

	/**
	 * Starling Virtual Joystick
	 * (drawing itself using flash graphics -> bitmapData -> Starling Texture)
	 */
	public class VirtualJoystick 
	{
		
		public static var hideParamWarnings:Boolean = false;
		
		public var enabled:Boolean = true;
		public var name:String;
		public var defaultChannel:uint = 0;
		
	
	
		protected var _initialized:Boolean;
		
		
		//Common graphic properties
		protected var _x:int;
		protected var _y:int;
		
		protected var _knobX:int = 0;
		protected var _knobY:int = 0;
		
		protected var _visible:Boolean = true;
		
		//joystick features
		protected var _innerradius:int;
		protected var _knobradius:int = 50;
		protected var _radius:int = 130;
		
		//Axes values [-1;1]
		protected var _xAxis:Number = 0;
		protected var _yAxis:Number = 0;
		
		//Axes Actions
		protected var _xAxisActions:Vector.<Object>;
		protected var _yAxisActions:Vector.<Object>;
		
		protected var _grabbed:Boolean = false;
		protected var _centered:Boolean = true;
		
		//Optional properties
		public var circularBounds:Boolean = true;
		
		public var graphic:starling.display.Sprite; //main Sprite container.
		
		//separate joystick elements
		protected var back:Image;
		protected var knob:Image;
		
		public function VirtualJoystick(name:String)
		{
			_innerradius = _radius - _knobradius;
			
			_x = _x ? _x : 2*_innerradius;
			_y = _y ? _y : 600 - 2*_innerradius;
			
			initActionRanges();
			initGraphics();
		}
		
		 protected function initGraphics():void
		{
			graphic = new starling.display.Sprite();
			
			if (!back)
			{
				//draw back
				var tempSprite:Sprite = new Sprite();
				var tempBitmapData:BitmapData = new BitmapData(_radius * 2, _radius * 2, true, 0x00FFFFFF);
				
				tempSprite.graphics.beginFill(0x000000, 0.1);
				tempSprite.graphics.drawCircle(_radius, _radius, _radius);
				tempBitmapData.draw(tempSprite);
				
				//draw arrows
				
				var m:int = 15; // margin
				var w:int = 30; // width
				var h:int = 40; // height
				
				tempSprite.graphics.clear();
				tempSprite.graphics.beginFill(0x000000, 0.2);
				tempSprite.graphics.moveTo(_radius, m);
				tempSprite.graphics.lineTo(_radius - w, h);
				tempSprite.graphics.lineTo(_radius + w, h);
				tempSprite.graphics.endFill();
				tempBitmapData.draw(tempSprite);
				
				tempSprite.graphics.clear();
				tempSprite.graphics.lineStyle();
				tempSprite.graphics.beginFill(0x000000, 0.2);
				tempSprite.graphics.moveTo(_radius, _radius * 2 - m);
				tempSprite.graphics.lineTo(_radius - w, _radius * 2 - h);
				tempSprite.graphics.lineTo(_radius + w, _radius * 2 - h);
				tempSprite.graphics.endFill();
				tempBitmapData.draw(tempSprite);
				
				tempSprite.graphics.clear();
				tempSprite.graphics.beginFill(0x000000, 0.2);
				tempSprite.graphics.moveTo(m, _radius);
				tempSprite.graphics.lineTo(h, _radius - w);
				tempSprite.graphics.lineTo(h, _radius + w);
				tempSprite.graphics.endFill();
				tempBitmapData.draw(tempSprite);
				
				tempSprite.graphics.clear();
				tempSprite.graphics.beginFill(0x000000, 0.2);
				tempSprite.graphics.moveTo(_radius * 2 - m, _radius);
				tempSprite.graphics.lineTo(_radius * 2 - h, _radius - w);
				tempSprite.graphics.lineTo(_radius * 2 - h, _radius + w);
				tempSprite.graphics.endFill();
				tempBitmapData.draw(tempSprite);
				
				back = new Image(Texture.fromBitmapData(tempBitmapData));
				
				tempSprite = null;
				tempBitmapData = null;
			}
			
			if (!knob)
			{
				//draw knob
				var tempSprite2:Sprite = new Sprite();
				var tempBitmapData2:BitmapData = new BitmapData(_radius * 2, _radius * 2, true, 0x00FFFFFF);
				
				tempSprite2.graphics.clear();
				tempSprite2.graphics.beginFill(0xEE0000, 0.85);
				tempSprite2.graphics.drawCircle(_knobradius, _knobradius, _knobradius);
				tempBitmapData2 = new BitmapData(_knobradius * 2, _knobradius * 2, true, 0x00FFFFFF);
				tempBitmapData2.draw(tempSprite2);
				
				knob = new Image(Texture.fromBitmapData(tempBitmapData2));
				
				tempSprite2 = null;
				tempBitmapData2 = null;
			}
			
			back.pivotX = back.pivotY = back.width / 2;
			graphic.addChild(back);
			
			knob.pivotX = knob.pivotY = knob.width / 2;
			graphic.addChild(knob);
			
			//move joystick
			graphic.x = _x;
			graphic.y = _y;
			
			//Add graphic
			Starling.current.stage.addChild(graphic);
			
			//Touch Events
			graphic.addEventListener(TouchEvent.TOUCH, handleTouch);
		}
		
		private function handleTouch(e:TouchEvent):void
		{
			var t:Touch = e.getTouch(graphic);
			if (!t)
				return;
			
			if (t.phase == TouchPhase.ENDED)
			{
				reset();
				_grabbed = false;
				return;
			}
			
			if (t.phase == TouchPhase.BEGAN)
			{
				_grabbed = true;
				_centered = false;
			}
			
			if (!_grabbed)
				return;
			
			var relativeX:int = t.globalX - graphic.x;
			var relativeY:int = t.globalY - graphic.y;
			
			handleGrab(relativeX, relativeY);
		
		}
		
		//properties for knob tweening.
		private var _vx:Number = 0;
		private var _vy:Number = 0;
		private var _spring:Number = 400;
		private var _friction:Number = 0.0005;
		
		 public function update():void
		{
			if (visible)
			{
				//update knob graphic
				if (_grabbed)
				{
					knob.x = _knobX;
					knob.y = _knobY;
				}
				else if (!_centered && !((knob.x > -0.5 && knob.x < 0.5) && (knob.y > -0.5 && knob.y < 0.5)))
				{
					//http://snipplr.com/view/51769/
					_vx += -knob.x * _spring;
					_vy += -knob.y * _spring;
					
					knob.x += (_vx *= _friction);
					knob.y += (_vy *= _friction);
				}
				else
					_centered = true;
				
			}
		}
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			graphic.visible = value;
		}
		protected function initActionRanges():void
		{
			_xAxisActions = new Vector.<Object>();
			_yAxisActions = new Vector.<Object>();
			
			//register default actions to value intervals
			
			addAxisAction("x", "left", -1, -0.3);
			addAxisAction("x", "right", 0.3, 1);
			addAxisAction("y", "up", -1, -0.3);
			addAxisAction("y", "down", 0.3, 1);
			
			addAxisAction("y", "duck", 0.8, 1);
			addAxisAction("y", "jump", -1, -0.8);
		
		}
		
		public function addAxisAction(axis:String, name:String, start:Number, end:Number):void
		{
			var actionlist:Vector.<Object>;
			if (axis.toLowerCase() == "x")
				actionlist = _xAxisActions;
			else if (axis.toLowerCase() == "y")
				actionlist = _yAxisActions;
			else
				throw(new Error("VirtualJoystick::addAxisAction() invalid axis parameter (only x and y are accepted)"));
			
			if ( (start < 0 && end > 0) || (start > 0 && end < 0) || start == end )
				throw(new Error("VirtualJoystick::addAxisAction() start and end values must have the same sign and not be equal"));
			
			if (!((start < -1 || start > 1) || (end < -1 || end > 1)))
				actionlist.push({name: name, start: start, end: end});
			else
				throw(new Error("VirtualJoystick::addAxisAction() start and end values must be between -1 and 1"));
		}
		
		/**
		 * Give handleGrab the relative position of touch or mouse to knob.
		 * It will handle knob movement restriction, action triggering and set _knobX and _knobY for knob positioning.
		 */
		public function handleGrab(relativeX:int, relativeY:int):void
		{
			if (circularBounds)
			{
				var dist:Number = relativeX*relativeX + relativeY*relativeY ;
				if (dist <= _innerradius*_innerradius)
				{
					_knobX = relativeX;
					_knobY = relativeY;
				}
				else
				{
					var angl:Number = Math.atan2(-relativeX, -relativeY);
					_knobX = Math.cos(-angl - Math.PI/2) * _innerradius;
					_knobY = Math.sin(-angl - Math.PI/2) * _innerradius;
				}
			}
			else
			{
				if (relativeX < _innerradius && relativeX > -_innerradius)
					_knobX = relativeX;
				else if (relativeX > _innerradius)
					_knobX = _innerradius;
				else if (relativeX < -_innerradius)
					_knobX = -_innerradius;
				
				if (relativeY < _innerradius && relativeY > -_innerradius)
					_knobY = relativeY;
				else if (relativeY > _innerradius)
					_knobY = _innerradius;
				else if (relativeY < -_innerradius)
					_knobY = -_innerradius;
			}
			
			//normalize x and y axes value.
			
			_xAxis = _knobX / _innerradius;
			_yAxis = _knobY / _innerradius;
			
			// Check registered actions on both axes
			
			if ((_xAxis >= -0.01 && _xAxis <= 0.01) || (_yAxis >= -0.01 && _yAxis <= 0.01))
				//threshold of Axis values where no actions will be fired // actions will turned off.
				triggerAllOFF();
			else
			{
				var a:Object; //action 
				var ratio:Number;
				var val:Number;
				
				if (_xAxisActions.length > 0)
					for each (a in _xAxisActions)
					{
						ratio = 1 / (a.end - a.start);
						val = _xAxis <0 ? 1 - Math.abs((_xAxis - a.start)*ratio) : Math.abs((_xAxis - a.start) * ratio);
						//if ((_xAxis >= a.start) && (_xAxis <= a.end))
							//triggerVALUECHANGE(a.name, val);
						//else
							//triggerOFF(a.name, 0);
					}
				
				if (_yAxisActions.length > 0)
					for each (a in _yAxisActions)
					{
						ratio = 1 / (a.start - a.end);
						val = _yAxis <0 ? Math.abs((_yAxis - a.end)*ratio) : 1 - Math.abs((_yAxis - a.end) * ratio);
						//if ((_yAxis >= a.start) && (_yAxis <= a.end))
							//triggerVALUECHANGE(a.name, val);
						//else
							//triggerOFF(a.name, 0);
					}
				
			}
		}
		
		protected function triggerAllOFF():void
		{
			/*
			var a:Object;
			if (_xAxisActions.length > 0)
				for each (a in _xAxisActions)
					triggerOFF(a.name);
			if (_yAxisActions.length > 0)
				for each (a in _yAxisActions)
					triggerOFF(a.name);
					*/
		}
		
		protected function reset():void
		{
			_knobX = 0;
			_knobY = 0;
			_xAxis = 0;
			_yAxis = 0;
			triggerAllOFF();
		}
		
		public function set radius(value:int):void
		{
			if (!_initialized)
			{
				_radius = value;
				_innerradius = _radius - _knobradius;
			}
			else
				trace("Warning: You cannot set " + this + " radius after it has been created. Please set it in the constructor.");
		}
		
		public function set knobradius(value:int):void
		{
			if (!_initialized)
			{
				_knobradius = value;
				_innerradius = _radius - _knobradius;
			}
			else
				trace("Warning: You cannot set " + this + " knobradius after it has been created. Please set it in the constructor.");
		}
		
		public function set x(value:int):void
		{
			if (!_initialized)
				_x = value;
			else
				trace("Warning: you can only set " + this + " x through graphic.x after instanciation.");
		}
		
		public function set y(value:int):void
		{
			if (!_initialized)
				_y = value;
			else
				trace("Warning: you can only set " + this + " y through graphic.y after instanciation.");
		}
		
		public function get radius():int
		{
			return _radius;
		}
		
		public function get knobradius():int
		{
			return _knobradius;
		}
	
		 public function destroy():void
		{
			back.dispose();
			knob.dispose();
			graphic.dispose();
			
			_xAxisActions = null;
			_yAxisActions = null;
			
			destroy();
		}
	
	}

}