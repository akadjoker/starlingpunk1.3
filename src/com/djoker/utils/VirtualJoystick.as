package com.djoker.utils 
{
	/**
	 * ...
	 * @author djoker
	 */
import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
 
    public class VirtualJoystick extends Sprite
    {
        // -- conf
        private var DISTANCE_MIN:int = 50;
        private var DISTANCE_MAX:int = 100;    
 
        // -- DIRS
        public var UP:Boolean   = false;
        public var DW:Boolean   = false;
        public var LF:Boolean   = false;
        public var RG:Boolean   = false;
        public var NONE:Boolean = true;    
 
        public var speed_factor:Number  = .0;
        public var angle:Number = .0;
 
        // --
        private var _knobX:int = 0;
        private var _knobY:int = 0;
 
        // --
        private var _knob:Image;
        private var _joystick:Image;
 
        public function VirtualJoystick(x:int, y:int, scale:Number = 1) {
            this.x = x;
            this.y = y;
            this.scaleX = this.scaleY =  scale;
            addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage );
        }
 
        private function _onAddedToStage(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage );   
 
            /*
                        var joy:Shape = new Shape();
            joy.graphics.beginFill(0x333333);
            joy.graphics.drawRect(0, 0, 150, 150);
            joy.graphics.endFill();
            var dat:BitmapData = new BitmapData(150, 150, true, 0x0);
            dat.draw( joy );
 
            var knob:Shape = new Shape();
            knob.graphics.beginFill(0xCC0000);
            knob.graphics.drawCircle(40,40,40)
            knob.graphics.endFill();
            var dat2:BitmapData = new BitmapData(80, 80, true, 0x0);
            dat2.draw(knob);
            */
 
            _joystick = new Image( Texture.fromBitmapData( new Border ) ); // dat
            _joystick.pivotX = _joystick.width >> 1;
            _joystick.pivotY = _joystick.height >> 1;
            _joystick.addEventListener(TouchEvent.TOUCH, _onTouch);
            addChild( _joystick );
 
            _knob = new Image( Texture.fromBitmapData( new Knob ) ); // dat2
            _knob.pivotX = _knob.width >> 1;
            _knob.pivotY = _knob.height >> 1;
            _knob.touchable = false;
            addChild( _knob );
        }
 
        private function _onTouch(e:TouchEvent):void
        {
            e.stopImmediatePropagation();
            var touch:Touch = e.getTouch(this);
 
            if (touch)
            {
                switch (touch.phase)
                {
 
                    case TouchPhase.ENDED:
                        _knobX = 0;
                        _knobY = 0;
                        LF = false;
                        RG = false;
                        UP = false;
                        DW = false;
                        NONE = true;
                        _update();
                        break;
 
                    case TouchPhase.BEGAN:
                    case TouchPhase.MOVED:
                        NONE = false;
                        _onTouchMove(touch);
                        break;
 
                    default:
                    // --
                }
 
            }
        }      
 
        private function _onTouchMove(touch:Touch):void
        {
            var dx:int = (touch.globalX / SB.ratioX - x); // default SB.ratioX = 1
            var dy:int = (touch.globalY / SB.ratioY - y); // default SB.ratioY = 1
            angle = Math.atan2(dy, dx);
            var dist:int = Math.sqrt(dx * dx + dy * dy);
            if (dist < DISTANCE_MAX) {
                _knobX = dx;
                _knobY = dy;
            } else {
                _knobX = (Math.cos(angle) * DISTANCE_MAX);
                _knobY = (Math.sin(angle) * DISTANCE_MAX);
                dist = DISTANCE_MAX;
            }
            // --
            LF = (dx < -DISTANCE_MIN);
            RG = (dx > DISTANCE_MIN);
            UP = (dy < -DISTANCE_MIN);
            DW = (dy > DISTANCE_MIN);
            // --
            speed_factor = dist / DISTANCE_MAX;
                        _update();
        }      
 
        private function _update():void
        {
            if(this.stage != null){
                _knob.x = _knobX;
                _knob.y = _knobY;
            }
        }          
 
        // ================================================================
 
        public function destroy():void
        {
            _joystick.removeEventListener(TouchEvent.TOUCH, _onTouch);
            removeChildren();
        }
    }
}