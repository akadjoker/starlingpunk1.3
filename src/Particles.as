		
package
{
    import starling.core.Starling;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
   
    public class Particles extends Sprite
    {      
        private var explosions:Vector.<Explosion>;
       
        public function Particles()
        {
            addEventListener(Event.ADDED_TO_STAGE, init);
        }
       
        private function init(event:Event):void
        {
            explosions = new Vector.<Explosion>();
           
            stage.addEventListener(TouchEvent.TOUCH, onTouch);
           
            // main game loop
            addEventListener(Event.ENTER_FRAME, loop);
        }

        private function onTouch(event:TouchEvent):void
        {
            var t:Touch = event.getTouch(stage);
           
            if(t.phase == TouchPhase.ENDED)
            {
                var ex:Explosion = new Explosion();
                explosions.push(ex);
                Starling.juggler.add(ex);
                ex.emitterX = t.globalX;
                ex.emitterY = t.globalY;
                addChild(ex);              
                ex.start(0.1);
                ex.advanceTime(1);
            }
        }
       
        private function loop(event:Event):void
        {
            updateParticles();
        }
       
        private function updateParticles():void
        {
            var ex:Explosion;
           
            for(var i:int=0; i<explosions.length; i++)
            {
                ex = explosions[i];
                if(ex.numParticles == 0)
                {
                    ex.stop();
                    explosions.splice(i, 1);
                    Starling.juggler.remove(ex);
                    removeChild(ex, true);
                }
            }
        }
    }
}