package
{
	import com.djoker.SP;
	import com.djoker.Engine;
	import starling.text.TextField;
	import starling.gui.ProgressBar;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.TouchEvent;
    import starling.events.TouchPhase;		
	import starling.display.Button;

	public class GameEngine extends Engine
	{	
		
		private var mLoadingProgress:ProgressBar;
		public function GameEngine() 
		{
			super();
			
		}
		
		
		public function startWorld():void
		{
			 SP.world = new MenuState();
    	     //SP.world = new PlayWorld();
             //SP.world = new animworld();
  	         //SP.world = new ColideWorld();
		     //SP.world = new bechmak();
	
		}
		
		 private function onButtonTriggered(event:Event):void
        {
            var button:Button = event.target as Button;
            
			/*
            if (button.name == "Animation")
			{
		     SP.world = new animworld(); 
			}
			else
			if (button.name == "backButton")
			{
			SP.world = new MenuState();
			} else
			if (button.name == "Benchmark")
			{
			SP.world = new bechmak();
			} else
			if (button.name == "ColideWorld")
			{
			SP.world = new ColideWorld();
			} else
			if (button.name == "Tiles")
			{
			SP.world = new PlayWorld();
			} 
			*/
			
			if (button.name == "backButton")
			{
			SP.world = new MenuState();
			}
             
        }

		
		
		override public function init():void 
		{
			super.init();
			var w:Number=SP.width;
			var h:Number=SP.height;
			assets.enqueue(Assets);
			mLoadingProgress = new ProgressBar(w-10, 20);
            mLoadingProgress.x = 10;
            mLoadingProgress.y = h -20;
            addChild(mLoadingProgress);
			
            addEventListener(Event.TRIGGERED, onButtonTriggered);
			
            assets.loadQueue(function(ratio:Number):void
            {
                mLoadingProgress.ratio = ratio;
                
                if (ratio == 1)
                    Starling.juggler.delayCall(function():void
                    {
                        mLoadingProgress.removeFromParent(true);
                        mLoadingProgress = null;
						startWorld();
                
                    }, 0.15);
            });
            
			
		
			
		}
	}
}