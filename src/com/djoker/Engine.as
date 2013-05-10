package com.djoker 
{	
	
	
	import com.djoker.events.EngineEvent;
	import com.djoker.utils.Input;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;
	import flash.utils.getTimer;
	
	/**
	 * Main game Sprite class, Manages the game loop.
	 * @author  djoker
	 */
	
	public class Engine extends Sprite
	{

		private var _paused:Boolean = false;
		

		public function Engine() 
		{	
			
			
			assets = new AssetManager();
			assets.verbose = false;
			
			//worlds = new Sprite();
			
			// global game objects
			SP.engine = this;
			SP.camera = new Camera();
			SP._world = new World;
			SP.entity = new Entity(0, 0);
			addChild(SP.camera.container);
			SP.camera.container.addChild(SP._world);
			
			// on-stage event listener
			addEventListener(Event.ADDED_TO_STAGE, onStage);
			
			SP.GetTime=getTimer();
			_time = _gameTime = getTimer();
			
			
		}
		
		
		
		 


		//----------
		//  getters and setters
		//----------
		
		public function get paused():Boolean 
		{
			return _paused;
		}
		
		public function set paused(value:Boolean):void 
		{
			_paused = value;
			if (value)
				dispatchEvent(new EngineEvent(EngineEvent.PAUSED));
			else
				dispatchEvent(new EngineEvent(EngineEvent.UNPAUSED));
		}
		
		/**
		 * Override this, called after Engine has been added to the stage.
		 */
		public function init():void { }
		
		/**
		 * Updates the game, updating the World and Entities.
		 */
		public function update():void
		{
			if (SP._world.active)
			{
				SP._world.engineUpdate();
			}
			SP._world.updateLists();
			if (SP._goto) checkWorld();
			
		}
		
		/** @private Event handler for stage entry. */
		private function onStage(e:Event = null):void
		{
			// remove event listener
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			
			
			SP.stage = stage;
			
			// enable input
			Input.enable();
			
			// global game properties
			SP.width = stage.stageWidth;
			SP.height = stage.stageHeight;
			
			// switch worlds
			if (SP._goto) checkWorld();
			
			SP.juggler = Starling.juggler;
			
			// game start
			init();
			
			// start game loop
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		
		
		
		/** @private Framerate independent game loop. */
		private function onEnterFrame(e:EnterFrameEvent):void
		{	
			SP.GetTime=getTimer();
			
			_time = _gameTime = getTimer();
			_flashTime = _time - _flashTime;
			_updateTime = _time;
			SP.elapsed = (_time - _last) / 1000;
			if (SP.elapsed > SP.maxElapsed) SP.elapsed = SP.maxElapsed;
			SP.elapsed *= SP.rate;
			_last = _time;
			
			  
			// update loop
			if (!_paused) update();
			
			SP.passedTime = e.passedTime;
			
			// update input
			Input.update();
		}
		
		/** @private Switch Worlds if they've changed. */
		private function checkWorld():void
		{
			if (!SP._goto) return;
			
			SP._world.end();
			SP.camera.container.removeChild(SP._world, true);
			SP._world.updateLists();
			SP._world = SP._goto;
			SP._goto = null;
			SP._world.updateLists();
			SP.camera.container.addChild(SP._world);
			SP.camera.setWorld(SP._world);
			SP._world.begin();
			SP._world.updateLists();
			stage.addEventListener(TouchEvent.TOUCH, SP._world.onTouch);
		}
		

		
		public  var assets:AssetManager;
		
					// Time information.
		/** @private */ internal static var _time:uint;
		/** @private */ public static var _updateTime:uint;
		/** @private */ public static var _renderTime:uint;
		/** @private */ public static var _gameTime:uint;
		/** @private */ public static var _flashTime:uint;
		/** @private */ private var _last:Number;
		           //    public  var worlds:Sprite;
	}
}