package  
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import flash.display.Bitmap
	
	import com.djoker.SP;
	import com.djoker.World;
	import com.djoker.masks.Pixelmask;
	import com.djoker.helpers.Primitives;
	import com.djoker.Entity;
	import com.djoker.utils.Key;
	import com.djoker.utils.Input;
	import com.djoker.graphics.Tilemap;
	
	import starling.animation.Tween;
	import starling.animation.Transitions;
	import starling.display.Button;

	
	/**
	 * ...
	 * @author djoker
	 */
	public class ColideWorld extends World 
	{
		  public static const MAP_DATA:String = "0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,0,0,0,1,0,0,0\n" +
                                                "0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0\n" +
                                                "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
												

			
		public var Player:Entity;
		public var Gem:Entity;
		public var tiles:Tilemap;
		public var stween:Tween;
		
		
		public function ColideWorld() 
		{
		super();
	
		}
		override public function begin():void
		{
		
			
			stween = new Tween(this, 0.5, Transitions.EASE_OUT);
			x = -320;
            stween.animate("x", 320);
			SP.juggler.add(stween);
	 
			
		Player = new Entity(100, 100, "player", new Pixelmask(Primitives.rectData(20,30)) );
		Player.graphic = Primitives.rect(20, 30);
		//Player.setHitbox(20, 30);
		
		
		for (var i:uint = 0; i < 50; i++)
		{
		Gem = new Entity(SP.range(20,620),SP.range(20,420), "gem",new Pixelmask(Primitives.circleData(20,0xFF00FF)));
		Gem.graphic = Primitives.circle(20, 0xFF00FF);
		//Gem.setHitbox(20, 20);
		add(Gem);
		}
		
		
		
		add(Player);
		
		
			var mBackButton:Button;
			mBackButton = new Button(getTextureAtlas("atlas").getTexture("button_back"), "Back");
            mBackButton.x = SP.halfWidth - mBackButton.width / 2;
            mBackButton.y = SP.height - mBackButton.height + 1;
            mBackButton.name = "backButton";
            addChild(mBackButton);

		
		}
		override public function update():void 
		{
		super.update();

		if (Input.check(Key.LEFT))
		{
		//Player.x--;	
		Player.moveBy(-1, 0, "gem", true);
		}
		if (Input.check(Key.RIGHT))
		{
		//Player.x++;	
		Player.moveBy(1, 0, "gem", true);
		}
		
		if (Input.check(Key.UP))
		{
		//Player.y--;	
		Player.moveBy(0, -1, "gem", true);
		}
		if (Input.check(Key.DOWN))
		{
		//Player.y++;	
		Player.moveBy(0, 1, "gem", true);
		}
		
	
		
		
		
		var gem:Entity = Player.collide("gem", Player.x, Player.y);
		
		
		if (gem)
		{
		this.remove(gem);
		//gem.graphic.color = 0x00FF00;
		}
		
		
		
		}
		
		override public function end():void 
		{ 
			this.removeChildren(0, -1, true);
		SP.juggler.remove(stween);
		dispose();
		}
	}

}