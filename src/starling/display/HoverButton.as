package starling.display 
{
import starling.display.Button;
import starling.display.DisplayObject;
import starling.events.TouchEvent;
import starling.textures.Texture;

/**
* The HoverButton Class
* Essentially adds an overState to the Starling Button class.
* @author Tony Downey
*/
public class HoverButton extends Button {

private var mUpState:Texture;
private var mOverState:Texture;
public var mIsOver:Boolean;

public function HoverButton(upState:Texture, text:String="", downState:Texture=null, overState:Texture=null) {
super(upState, text, downState);
mOverState = overState;
mUpState = upState;
addEventListener(TouchEvent.TOUCH, onTouchCheckHover);
}

/** Checks if there is a parent, an overState, and if the touch event is hovering; if so, it replaces the upState texture */
private function onTouchCheckHover(e:TouchEvent):void {
mIsOver = true;	
if (parent && mOverState && upState != mOverState && e.interactsWith(e.currentTarget as DisplayObject)) {
removeEventListener(TouchEvent.TOUCH, onTouchCheckHover);
parent.addEventListener(TouchEvent.TOUCH, onParentTouchCheckHoverEnd);
upState = mOverState;

}
}

/** Checks if there is a parent, an overState, and if the touch event is finished hovering; if so, it resets the upState texture */
private function onParentTouchCheckHoverEnd(e:TouchEvent):void {
	
if (parent && mOverState && ! e.interactsWith(e.currentTarget as DisplayObject)) {
parent.removeEventListener(TouchEvent.TOUCH, onParentTouchCheckHoverEnd);
addEventListener(TouchEvent.TOUCH, onTouchCheckHover);
upState = mUpState;

}
}

/** The texture that is displayed while the button is hovered over. */
public function get overState():Texture { return mOverState; }
public function set overState(value:Texture):void{ if (mOverState != value) mOverState = value; }

/** The texture that is displayed when the button is not being touched. */
override public function get upState():Texture { return mUpState; }
override public function set upState(value:Texture):void {
if (mOverState != value) mUpState = value;
super.upState = value;
mIsOver = false;
}

}

}