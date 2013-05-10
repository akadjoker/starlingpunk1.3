package 
{
	
import flash.display.Sprite;
import starling.core.Starling;

		
	[SWF(width="640", height="480", frameRate="60", backgroundColor="#000000")]
	
	public class Main extends Sprite 
	{
		  private var mStarling:Starling;
        
        public function Main()
        {
			
            
            
          Starling.handleLostContext = true; // required on Windows, needs more memory
		  
			
			mStarling = new Starling(GameEngine, stage);
			mStarling.simulateMultitouch = true;
			mStarling.enableErrorChecking = true;
			
            mStarling.showStats = true;
			mStarling.start(); 		
            

        }
        
     
    }
}


