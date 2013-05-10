package  
{
	
	
	import com.djoker.SP;
	import com.djoker.World;
	import com.djoker.masks.Pixelmask;
	import com.djoker.helpers.Primitives;
	import com.djoker.Entity;
	import com.djoker.utils.Key;
	import com.djoker.utils.Input;
	import com.djoker.graphics.Spritemap;
	
		
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.textures.TextureAtlas;

	/**
	 * ...
	 * @author djoker
	 */
	public class Player extends Entity 
	{
	private	var angle:Number;
	private var ix:Number;
	private var iy:Number;
	private var hh:Number;
	
	private var image:Image;
		
		public function Player() 
		{
			super();
		
			
			graphic = new Spritemap(SP.engine.assets.getTexture("sprite"));
			//image = new Image(Assets.getTexture("sprite"));
			//image.SetImageFrame(20, 20, 20, 20);

	        graphic.pivotX = graphic.width  / 2.0;
            graphic.pivotY = graphic.height / 2.0;
			hh = graphic.width / 2;
			
	
            
			

			x = SP.range(hh, SP.width -hh);
			y = SP.range(hh, SP.height - hh);
			
			angle = SP.range(0, 360);
			ix = Math.cos(SP.deg2rad(angle))* 200;
			iy = Math.sin(SP.deg2rad(angle))* 200;
			angle = 0;
			
		}
			override public function update():void 
			{
			super.update();
			angle++;
			graphic.rotation =  SP.deg2rad(angle);
			x = x + ix*SP.elapsed;
			y = y + iy*SP.elapsed;
			
			if (x < hh) ix = -ix;
			if (y < hh) iy = -iy;
			
			if (x > SP.width-hh) ix = -ix;
			if (y > SP.height-hh) iy = -iy;
			
			
			
			}
		
	}

}