package com.djoker 
{
	import flash.utils.Dictionary;
	import starling.display.Sprite;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
	import flash.geom.Point;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	import starling.core.Starling;
    import starling.text.BitmapFont;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
	import starling.events.Event;
	
	import com.djoker.utils.MathUtils;
	import com.djoker.utils.MathVector;
	import com.djoker.tween.Tween;
	import com.djoker.tween.Tweener;
	/**
	 * Updated by Engine, main game container that holds all currently active Entities.
	 * Useful for organization, eg. "Menu", "Level1", etc.
	 * @author  djoker
	 */
	public class World extends Sprite
	{	
		private var _allEntities:Dictionary;
		private var _addList:Vector.<Entity>;
		private var _removeList:Vector.<Entity>;
		private var _active:Boolean;
		private var _disposeEntities:Boolean;
	
		
		public function World() 
		{
			//probably dictionary
			_allEntities = new Dictionary();
			
			_addList = new Vector.<Entity>();
			_removeList = new Vector.<Entity>();
			
			_disposeEntities = true;
			_active = true;
			//touchable = false;
			
		//	addEventListener(Event.ADDED_TO_STAGE, onAdded);
		   
		}
		
		/*
		  public function added():void { }
		
		  private function onAdded ( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			added();
			
		}
		*/
		//----------
		//  getters and setters
		//----------
		public function onTouch(e:TouchEvent):void
		{
			
			var touches : Vector.<Touch> = e.touches;
			var tTouch : Touch;
			var i : int; 
			var length : int = touches.length; 
			_touchCount = length;
			
			for( i = 0; i < length; i++ )
			{
				tTouch = touches[ i ];
				settouchX(i, tTouch.globalX);
				settouchY(i, tTouch.globalY);
					
				switch ( tTouch.phase )
				{
					case TouchPhase.BEGAN:
						
				
						
				   mouseX =  tTouch.globalX;
		     	   mouseY =  tTouch.globalY;
				  _mouseHitX =  tTouch.globalX;
				  _mouseHitY =  tTouch.globalY;
  		    	 _mousehit = true;

						break;
					case TouchPhase.MOVED:
					case TouchPhase.STATIONARY:
				   mouseX =  tTouch.globalX;
		     	   mouseY =  tTouch.globalY;
				  _mouseHitX =  tTouch.globalX;
				  _mouseHitY =  tTouch.globalY;
	  	    	  _mousehit = true;
    			break;
					case TouchPhase.ENDED:
						settouchX(i,-1);
					    settouchY(i, -1);
						 mouseX =  -1;
		     	         mouseY =  -1;
				        _mousehit = false;
						_mouseHitX = -1;
						_mouseHitY = -1;
						break;
					default: 
						break;
				}
			}
			
		
		}
		
		
		public function getTextureAtlas(name:String):TextureAtlas
		{return SP.engine.assets.getTextureAtlas(name); }
		public function getSound(name:String):Sound
		{return SP.engine.assets.getSound(name); }
		public function getXml(name:String):XML
		{return SP.engine.assets.getXml(name); }
		public function getBitmap(name:String):Bitmap
		{return SP.engine.assets.getBitmap(name); }
		public function getTexture(name:String):Texture
		{return SP.engine.assets.getTexture(name); }
 
		
		/**
		 * if the world is inactive entites won't be updated
		 */
		public function get active():Boolean 
		{
			return _active;
		}
		
		public function set active(value:Boolean):void 
		{
			_active = value;
		}
		
		/**
		 * whether or not the world should dispose the entity when removing them, by defualt it is set to true
		 */
		public function get disposeEntities():Boolean 
		{
			return _disposeEntities;
		}
		
		public function set disposeEntities(value:Boolean):void 
		{
			_disposeEntities = value;
		}
		
		//----------
		//  public methods
		//----------
		

		public function engineUpdate():void 
		{
			
			updateLists();
			if (_active)
			{
				updateEntities();
				update();
			}
		}
		
		/**
		 * called by main StarlingPunk engine, makes sure any entites queued to be removed/add get taken care of 
		 */
		public function updateLists():void
		{
			processAddList();
			processRemoveList();
		}
		
		/**
		 * addeds the entity to the world, entity will be added on next frame tick
		 * @param	entity to be added to the world
		 */
		public function add(entity:Entity):void
		{
			if (entity.world) return;
			entity.world = this;
			_addList.push(entity);
		}
		
		/**
		 * removes the entity to the world, entity will be removed on last frame tick
		 * @param	entity to be removed from the world
		 */
		public function remove(entity:Entity):void
		{
			if (!entity.world) return;
			_removeList.push(entity);
			entity.world = null;
		}
		
		/**
		* removes all the entities from the world
		* @param overrides the worlds disposeEntities property
		*/
		public function removeAll(dispose:Boolean = true):void
		{
			_disposeEntities = dispose;
			var entity:Entity;
			for each (var entities:Vector.<Entity> in _allEntities) 
			{
				var numEntities:int = entities.length;
				for (var i:int = 0; i < numEntities; i++) 
				{
					entity = entities[i];
					remove(entity);
				}
			}
		}
		
		/**
		 * returns a vector of all entities of that type
		 * @param type The type to check.
		 * @return vector of entities of supplied type
		*/
		public function getType(type:String):Vector.<Entity>
		{
			return _allEntities[type];
		}
		
		/**
		 * this is called by the entity object when ever the type is changed. It will update the allEntites dictionary list
		 * @param the old type of the entity
		 * @param the new type of the entity
		*/
		public function changeEntityTypeName(oldType:String, newType:String):void
		{
			var group:Vector.<Entity> = getType(oldType);
			delete _allEntities[oldType];
			
			var newGroup:Vector.<Entity> = getType(newType);
			if (!newGroup)
			{
				_allEntities[newType] = group;
			}
			else
			{
				_allEntities[newType] = newGroup.concat(group);
			}
		}
		
		//----------
		//  private methods
		//----------
		
		private function updateEntities():void 
		{
			var entity:Entity;
			for each (var entities:Vector.<Entity> in _allEntities) 
			{				
				var numEntities:int = entities.length;
				for (var i:int = 0; i < numEntities; i++) 
				{
					entity = entities[i];
					entity.update();
				}
			}
		}
		
		private function processRemoveList():void
		{
			var entity:Entity;
			//only execute for as long as there are items left to remove
			while (this._removeList.length) 
			{
				entity = _removeList[0];
				entity.removed();
				removeChild(entity, _disposeEntities);
				removeFromObjectLookup(entity);
				//removes items till none are left
				_removeList.splice(0, 1);
			}
		}
		
		private function processAddList():void
		{
			var entity:Entity;
			//only execute for as long as there are items left to add
			while (this._addList.length) 
			{
				entity = _addList[0];
				addEntityToLookUp(entity);
				
				var tempLayer:uint = entity.layer;
				if (tempLayer > numChildren)
					tempLayer = numChildren;
				addChildAt(entity, tempLayer);
				entity.added();
				//removes items till none are left
				_addList.splice(0, 1);
			}
		}
		
		private function addEntityToLookUp(entity:Entity):void
		{
			var entityTypeArray:Vector.<Entity> = getType(entity.type);
			if (entityTypeArray == null || entityTypeArray.length == 0) 
			{
				//create new array if doesn't exist
				entityTypeArray = new Vector.<Entity>();
			}
			entityTypeArray.push(entity);
			_allEntities[entity.type] = entityTypeArray;
		}
		
		private function removeFromObjectLookup(entity:Entity):void
		{
			var entityTypeArray:Vector.<Entity> = this.getType(entity.type);
			var index:int = entityTypeArray.indexOf(entity);
			entityTypeArray.splice(index, 1);
			
			if (entityTypeArray.length == 0) 
			{
				entityTypeArray = null;
			}
		}
		
		//----------
		//  abstract methods
		//----------
		
		/**
		 * Abstract method that is called when world starts
		 */
		public function begin():void { }
		
		/**
		 * Abstract method that is called when world ends
		 */
		public function end():void { }
		
		/**
		 * Abstract method that is called when world updates
		 */
		public function update():void { }
		
		
		public function get mouseX():Number
		{
			return _mouseX;
		}
 
		public function set mouseX(value:Number):void
		{
			_mouseX = value;
		}
 
		public function get mouseY():Number
		{
			return _mouseY;
		}
 
		public function set mouseY(value:Number):void
		{
			_mouseY = value;
		}
 
		
		public function get mouseHit():Boolean
		{
			return _mousehit;
		}
 
		public function set mouseHit(value:Boolean):void
		{
			_mousehit = value;
		}
			public function get mouseHitX():Number
		{
			return _mouseHitX;
		}
 
		public function set mouseHitX(value:Number):void
		{
			_mouseHitX = value;
		}
 
		public function get mouseHitY():Number
		{
			return _mouseHitY;
		}
 
		public function set mouseHitY(value:Number):void
		{
			_mouseHitY = value;
		}
 //*******************
 
 		public function getTouchX(index:uint):Number
		{
			return _touchX[index];
		}
 
		public function settouchX(index:uint,value:Number):void
		{
			_touchX[index] = value;
		}
 	   public function getTouchY(index:uint):Number
		{
			return _touchY[index];
		}
 
		public function settouchY(index:uint,value:Number):void
		{
			_touchY[index] = value;
		}
 //************
 		public function get touchCount():Number
		{
			return _touchCount;
		}
 
		public function set touchCount(value:Number):void
		{
			_touchCount = value;
		}
		private var _touchX:Vector.<Number> = new <Number>[10];
		private var _touchY:Vector.<Number> = new <Number>[10];
		
		 
		private var _touchCount:Number;
		private var _mouseX:Number;
		private var _mouseY:Number;
		private var _mouseHitX:Number;
		private var _mouseHitY:Number;
		private var _mousehit:Boolean;

		
	}

}