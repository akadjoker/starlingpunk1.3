package  
{
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import starling.text.TextField;

	/**
	 * ...
	 * @author djoker
	 */
	public class Game extends Sprite
	{
		
		public function Game() 
		{
			 var textField:TextField = new TextField(400, 300, "Welcome to Starling!");
			 textField.x = 100;
			 textField.y = 100;
             addChild(textField);
			 
			 trace("create game");
		}
		
	}

}