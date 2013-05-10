package  
{
	import com.djoker.SP;
	import com.djoker.World;
	import com.djoker.utils.Key;

	import starling.display.Sprite;
    import starling.core.Starling;
    import starling.display.MovieClip;

	
	import flash.geom.Rectangle;
    import com.djoker.utils.MathVector;
  
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.display.BlendMode;
	import starling.display.QuadBatch;
    import starling.textures.TextureAtlas;
	
	


	import com.djoker.tmx.TMXMap
	import com.djoker.tmx.TMXLayer;
	import com.djoker.tmx.TMXObject
	import com.djoker.tmx.TMXObjectGroup;
	import com.djoker.tmx.TMXPropertySet
	import com.djoker.tmx.TMXTileset;
	

	
	import flash.display.BitmapData;
	import flash.utils.Timer;
	import flash.geom.Rectangle;
	 import flash.geom.Point;
    import flash.utils.Dictionary;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
    import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import flash.display.Bitmap;

	//import com.djoker.graphics.Tilemap;
	

	import com.djoker.objectmakers.tmx.TmxMap;
	import com.djoker.objectmakers.tmx.TmxLayer;
	import com.djoker.objectmakers.tmx.TmxObject;
	import com.djoker.objectmakers.tmx.TmxObjectGroup;
	import com.djoker.objectmakers.tmx.TmxPropertySet;
	import com.djoker.objectmakers.tmx.TmxTileSet;
	import com.djoker.graphics.TilesBatch;
    import com.djoker.controls.joystick.Joystick;
	import com.djoker.controls.VirtualButtons;
	import com.djoker.controls.VirtualJoystick;
	

	import starling.animation.Tween;
	import starling.animation.Transitions;
	import starling.display.Button;
	

	public class PlayWorld extends World 
	{

		
	    [Embed(source="assets/level1.xml", mimeType="application/octet-stream")]
        private static var gleeXML:Class;

		
		
		
		
	

      private var joystick:Joystick;
      private var hero:MovieClip;
   	  private  var tileList:Vector.<Texture>;
		public var stween:Tween;
	  

 


		
		public function PlayWorld() 
		{
		super();
	
		
			
		}
		
      		override public function begin():void
		{

		 			
	
			
		 
		 	var tmx:TmxMap = new TmxMap(getXml("sewers"));
			var mapCsv:String = tmx.getLayer('Bottom').toCsv(tmx.getTileSet('tiles'));
			var tilebatch:TilesBatch = new TilesBatch(mapCsv,getBitmap("sewer_tileset"), 24, 24);
			tilebatch.scrollFactorX = 1;
			tilebatch.scrollFactorY = 1;
		    addChild(tilebatch);
			tmx = null;
			

		 
		    hero = new MovieClip(getTextureAtlas("atlas").getTextures("flight_"), 10);
			hero.x = 100;
			hero.y = 100;
			hero.scaleX = 0.5;
			hero.scaleY=  0.5;
            addChild(hero);
            hero.play();
			hero.scrollFactorX = 1;
			hero.scrollFactorY = 1;
            Starling.juggler.add(hero);
			
			//joystick = new Joystick(Assets.getTexture("joystickbg"), Assets.getTexture("knob2"));
			joystick = new Joystick(SP.engine.assets.getTexture("control_base") , SP.engine.assets.getTexture("control_knob"));
            addChild(joystick);
			
  
	        var mBackButton:Button;
			mBackButton = new Button(getTextureAtlas("atlas").getTexture("button_back"), "Back");
            mBackButton.x = SP.halfWidth - mBackButton.width / 2;
            mBackButton.y = SP.height - mBackButton.height + 1;
            mBackButton.name = "backButton";
            addChild(mBackButton);
			
			
			stween = new Tween(this, 1.5, Transitions.EASE_OUT_IN);
			y =-240;
			x = -320
			this.rotation =- SP.deg2rad(190);
            stween.animate("y", 240);
			stween.animate("x", 320);
			stween.animate("rotation",SP.deg2rad(0));
			SP.juggler.add(stween);
		
			
		}
		
			
		override public function update():void 
		{
		super.update();
		

		   
	  SP.camera.scrollx += joystick.offset.x * 5;
	  SP.camera.scrolly += joystick.offset.y * 5;
	  
		 //  trace(SP.camera.scrollx);

		   

	
		}
		
		override public function end():void 
		{ 
		this.removeChildren(0, -1, true);
		SP.juggler.remove(stween);
		dispose();
		}
		
	
	}
}