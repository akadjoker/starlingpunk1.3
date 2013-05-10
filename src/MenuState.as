package  
{
	
    import com.djoker.SP;
	import com.djoker.World;
	import com.djoker.utils.Key;
	
	
	import starling.text.TextField;
    import starling.textures.Texture;
    import starling.utils.VAlign;
	
	import starling.events.Event;
	
	import starling.display.Button;

    import starling.animation.Tween;
	import starling.animation.Transitions;
	
	
	/**
	 * ...
	 * @author djoker
	 */
	public class MenuState extends World 
	{
		    private var state:int = 0;
			public var stween:Tween;
			public var itween:Tween;
			
		
		public function MenuState() 
		{
			super();
		}
		
		override public function begin():void 
		{ 
			
			var count:Number = 0;
		    var buttonTexture:Texture = this.getTextureAtlas("atlas").getTexture("button_normal");
		     
			
			    count=2;
		        var button:Button = new Button(buttonTexture, "Animation");
                button.x = SP.width/2-button.width/2;
                button.y = 50 + int(count / 2) * 52;
                button.name ="Animation";
                addChild(button); 
				
				count=4;
			    var button2:Button = new Button(buttonTexture, "Benchmark");
                button2.x = SP.width/2-button2.width/2;
                button2.y = 50 + int(count / 2) * 52;
                button2.name ="Benchmark";
                addChild(button2); 
				
				count = 6;
			    var button3:Button = new Button(buttonTexture, "ColideWorld");
                button3.x = SP.width/2-button3.width/2;
                button3.y = 50 + int(count / 2) * 52;
                button3.name ="ColideWorld";
                addChild(button3); 
				
				
				count = 8;
			    var button4:Button = new Button(buttonTexture, "Tiles");
                button4.x = SP.width/2-button4.width/2;
                button4.y = 50 + int(count / 2) * 52;
                button4.name ="Tiles";
                addChild(button4); 
				
			x = -320;
			this.rotation = -SP.deg2rad(190);
			itween = new Tween(this, 0.5, Transitions.EASE_OUT);
            itween.animate("x", 320);
			itween.animate("rotation",SP.deg2rad(0));
			SP.juggler.add(itween);
			
			
			
				
				addEventListener(Event.TRIGGERED, onButtonTriggered);
		}
		

		 private function onButtonTriggered(event:Event):void
        {
			

			
            var button:Button = event.target as Button;
            
            if (button.name == "Animation")
			{
		    // SP.world = new animworld(); 
			state = 0;
			}
			
			if (button.name == "Benchmark")
			{
			//SP.world = new bechmak();
			state = 1;
			} 
			
			if (button.name == "ColideWorld")
			{
				state = 2;
			//SP.world = new ColideWorld();
			} 
			
			if (button.name == "Tiles")
			{
				state = 3;
			//SP.world = new PlayWorld();
			} 
			
			stween = new Tween(this, 0.5, Transitions.EASE_OUT);
            stween.animate("y", 640);
			stween.onComplete = onComplete;
			SP.juggler.add(stween);
			
	
             
        }
		

		

		
		public function onComplete():void 
		{
			
		switch (state)
		{
		case 0: SP.world = new animworld(); break
		case 1: SP.world = new bechmak(); break
		case 2: SP.world = new ColideWorld(); break
		case 3: SP.world = new PlayWorld();break
		}
		
		//trace(state);
		
		}
		
		override public function end():void 
		{ 
		
	    SP.juggler.remove(stween);
		dispose();
		}

		override public function dispose():void 
		{
			super.dispose();
			this.removeChildren();
			
		}
		
	}

}