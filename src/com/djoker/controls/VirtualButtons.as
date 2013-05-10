package com.djoker.controls {



	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class VirtualButtons  {

		
					public static var hideParamWarnings:Boolean = false;
		
		public var enabled:Boolean = true;
		public var name:String;
		public var defaultChannel:uint = 0;
		
	
	
		protected var _initialized:Boolean;
		
		
		//Common graphic properties
		protected var _x:int;
		protected var _y:int;
		
		protected var _margin:int = 130;
		
		protected var _visible:Boolean = true;
		
		protected var _buttonradius:int = 50;
		
		public var button1Action:String = "button1";
		public var button1Channel:int = -1;
		public var button2Action:String = "button2";
		public var button2Channel:int = -1;
		
		public var graphic:starling.display.Sprite;
	

		protected var button1:Image;
		protected var button2:Image;

		protected var buttonUpTexture:Texture;
		protected var buttonDownTexture:Texture;

		public function VirtualButtons() {
		
		}

		 protected function initGraphics():void {
			
			graphic = new starling.display.Sprite();
			
				_x = _x ? _x : 800 - (_margin + 3*_buttonradius) ;
			    _y = _y ? _y : 600 - 3*_buttonradius;
			
			

			if (!buttonUpTexture) 
			{
				var tempSprite:Sprite = new Sprite();
				var tempBitmapData:BitmapData = new BitmapData(_buttonradius * 2, _buttonradius * 2, true, 0x00FFFFFF);

				tempSprite.graphics.clear();
				tempSprite.graphics.beginFill(0x000000, 0.1);
				tempSprite.graphics.drawCircle(_buttonradius, _buttonradius, _buttonradius);
				tempSprite.graphics.endFill();
				tempBitmapData.draw(tempSprite);
				buttonUpTexture = Texture.fromBitmapData(tempBitmapData);
				tempSprite = null;
				tempBitmapData = null;
			}

			if (!buttonDownTexture) {
				var tempSprite2:Sprite = new Sprite();
				var tempBitmapData2:BitmapData = new BitmapData(_buttonradius * 2, _buttonradius * 2, true, 0x00FFFFFF);

				tempSprite2.graphics.clear();
				tempSprite2.graphics.beginFill(0xEE0000, 0.85);
				tempSprite2.graphics.drawCircle(_buttonradius, _buttonradius, _buttonradius);
				tempSprite2.graphics.endFill();
				tempBitmapData2.draw(tempSprite2);
				buttonDownTexture = Texture.fromBitmapData(tempBitmapData2);
				tempSprite2 = null;
				tempBitmapData2 = null;
			}

			button1 = new Image(buttonUpTexture);
			
			button1.pivotX = button1.pivotY = _buttonradius;

			button2 = new Image(buttonUpTexture);
			button2.pivotX = button2.pivotY = _buttonradius;

			tempSprite = null;
			tempBitmapData = null;

			button2.x += _margin;

			graphic.x = _x;
			graphic.y = _y;

			graphic.addChild(button1);
			graphic.addChild(button2);

			Starling.current.stage.addChild(graphic);

			graphic.addEventListener(TouchEvent.TOUCH, handleTouch);
		}

		private function handleTouch(e:TouchEvent):void {
			
			var b1:Touch = e.getTouch(button1);
			var b2:Touch = e.getTouch(button2);

			if (b1) {
				
				switch (b1.phase) {
					
					case TouchPhase.BEGAN:
						(b1.target as Image).texture = buttonDownTexture;
					//	triggerON(button1Action, 1, button1Channel);
						break;
						
					case TouchPhase.ENDED:
						(b1.target as Image).texture = buttonUpTexture;
						//triggerOFF(button1Action, 0, button1Channel);
						break;
				}
			}

			if (b2) {
				
				switch (b2.phase) {
					
					case TouchPhase.BEGAN:
						(b2.target as Image).texture = buttonDownTexture;
						//triggerON(button2Action, 1, button2Channel);
						break;
						
					case TouchPhase.ENDED:
						(b2.target as Image).texture = buttonUpTexture;
						//triggerOFF(button2Action, 0,button2Channel);
						break;
				}
			}
		}

	

		 public function destroy():void {
			
			graphic.removeEventListener(TouchEvent.TOUCH, handleTouch);
			
			buttonUpTexture.dispose();
			buttonDownTexture.dispose();
			button1.dispose();
			button2.dispose();
		}
		
		
		public function set visible(value:Boolean):void
		{
			_visible = value;
				graphic.visible = value;
		}
		
		public function set buttonradius(value:int):void
		{
			if (!_initialized)
				_buttonradius = value;
			else
				trace("Warning: You cannot set " + this + " buttonradius after it has been created. Please set it in the constructor.");
		}
		
		public function set margin(value:int):void
		{
			if (!_initialized)
				_margin = value;
			else
				trace("Warning: You cannot set " + this + " margin after it has been created. Please set it in the constructor.");
		}
		
		public function get margin():int
		{
			return _margin;
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
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function get buttonradius():int
		{
			return _buttonradius;
		}
	
	}

}