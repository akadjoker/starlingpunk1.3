package com.djoker 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import starling.display.Sprite;
	import starling.display.Image;
	
	/**
	 * Main game Entity class updated by World.
	 * @author  djoker
	 */
	
	public class Entity extends Sprite
	{
				/** @private */ private var _x:Number;
		/** @private */ private var _y:Number;
				/** @private */ private var _moveX:Number = 0;
		/** @private */ private var _moveY:Number = 0;
			/** @private */ private var _point:Point = SP.point;
		
		private var _world:World;
		private var _type:String;
		private var _hitBounds:Rectangle;
		private var _collidable:Boolean;
		private var _layer:uint;
		private var _originX:Number;
		private var _originY:Number;
		public var  _worldX:Number;
		private var _worldY:Number
		
		public var hitWidth :Number;
		public var hitHeight :Number;
			
	
		
		internal var _graphic:Image;
		 
		// Collision information.
		private const HITBOX:Mask = new Mask;
		private var _mask:Mask;
		//private var bound:Rectangle;
		internal var _class:Class;
		
		public function Entity(x:Number = 0, y:Number = 0, type:String = "", mask:Mask = null) 
		{
			_layer = 1;
			_originX = 0;
			_originY = 0;
			_collidable = true;
			_worldX = 0;
			_worldY = 0;
			_hitBounds = new Rectangle(0, 0);
			this.x = x;
			this.y = y;
			if (type == "")
				type = getQualifiedClassName(this);
			this._type = type;
			
			touchable = false;
			if (mask) this.mask = mask;
			HITBOX.assignTo(this);
			_class = Class(getDefinitionByName(getQualifiedClassName(this)));
		}
		
		//----------
		//  getters and setters
		//----------
		
		/**
		 * The World object this Entity has been added to.
		 */
		public function get world():World {	return _world; }
		public function set world(value:World):void 
		{
			_world = value;
		}
		
		/**
		 * The collision type, used for collision checking.
		 */
		public function get type():String { return _type; }
		public function set type(value:String):void 
		{
			if (world)
				world.changeEntityTypeName(_type, value);
			_type = value;
		}
		
		/**
		 * The rectange bounds of the entity used for rectangle collision detection
		 */
		public function get hitBounds():Rectangle { return _hitBounds; }
		public function set hitBounds(value:Rectangle):void 
		{
			_hitBounds = value;
		}
		
		/**
		 * If the Entity should respond to collision checks.
		 */
		public function get collidable():Boolean { return _collidable; }
		public function set collidable(value:Boolean):void 
		{
			_collidable = value;
		}
		
		/**
		 * An optional Mask component, used for specialized collision. If this is
		 * not assigned, collision checks will use the Entity's hitbox by default.
		 */
		public function get mask():Mask { return _mask; }
		public function set mask(value:Mask):void 
		{	
			if (_mask == value) return;
			if (_mask) _mask.assignTo(null);
			_mask = value;
			if (value) _mask.assignTo(this);
		}
		
		/**
		 * The rendering layer of this Entity. Higher layers are rendered first.
		 */
		public function get layer():uint 
		{ return _layer; }
		public function set layer(value:uint):void 
		{
			var temp:uint = value
			if (world && this.parent)
			{
				if (temp > world.numChildren)
					temp = world.numChildren;
				world.setChildIndex(this, temp);
			}
			_layer = value;
		}
		
				
		/**
		 * X origin of the Entity's hitbox.
		 */
		public function get originX():Number 
		{
			return _originX;
		}
		
		public function set originX(value:Number):void 
		{
			_originX = value;
		}
		
		/**
		 * Y origin of the Entity's hitbox.
		 */
		public function get originY():Number 
		{
			return _originY;
		}
		
		public function set originY(value:Number):void 
		{
			_originY = value;
		}
	
	
		//-------------------
		//  public methods
		//-------------------
		/**
		 * Checks if this Entity overlaps the specified position.
		 * @param	x			Virtual x position to place this Entity.
		 * @param	y			Virtual y position to place this Entity.
		 * @param	pX			X position.
		 * @param	pY			Y position.
		 * @return	If the Entity intersects with the position.
		 */
		public function collidePoint(x:Number, y:Number, pX:Number, pY:Number):Boolean
		{
			if (pX >= x - originX && pY >= y - originY
			&& pX < x - originX + hitWidth && pY < y - originY + hitHeight)
			{
				if (!_mask) return true;
				_x = this.x; _y = this.y;
				this.x = x; this.y = y;
				SP.entity.x = pX;
				SP.entity.y = pY;
				SP.entity.hitWidth = 1;
				SP.entity.hitHeight = 1;
				if (_mask.collide(SP.entity.HITBOX))
				{
					this.x = _x; this.y = _y;
					return true;
				}
				this.x = _x; this.y = _y;
				return false;
			}
			return false;
		}
		
			public function get onCamera():Boolean
		{
			
			return collideRect(x, y, SP.camera.scrollx, SP.camera.scrolly, SP.width, SP.height);
		}
		public function get halfHeight():Number { return hitHeight / 2; }
		
		/**
		 * The center x position of the Entity's hitbox.
		 */
		public function get centerX():Number { return x - originX + hitWidth / 2; }
		
		/**
		 * The center y position of the Entity's hitbox.
		 */
		public function get centerY():Number { return y - originY + hitHeight / 2; }
		
		/**
		 * The leftmost position of the Entity's hitbox.
		 */
		public function get left():Number { return x - originX; }
		
		/**
		 * The rightmost position of the Entity's hitbox.
		 */
		public function get right():Number { return x - originX + hitWidth; }
		
		/**
		 * The topmost position of the Entity's hitbox.
		 */
		public function get top():Number { return y - originY; }
		
		/**
		 * The bottommost position of the Entity's hitbox.
		 */
		public function get bottom():Number { return y - originY + hitHeight;}
		
		
		/**
		* Checks if this Entity collides with a specific Entity.
		* @param	entity	The Entity to collide against.
		* @param	x		Virtual x position to place this Entity.
		* @param	y		Virtual y position to place this Entity.
		* @return	The Entity if they overlap, or null if they don't.
		*/
		
		public function collideWith(e:Entity, x:Number, y:Number):Entity
		{
			_x = this.x; _y = this.y;
			this.x = x; this.y = y;
			
			if (e.collidable && this.collidable 
			&& x - originX + hitWidth > e.x - e.originX
			&& y - originY + hitHeight > e.y - e.originY
			&& x - originX < e.x - e.originX + e.hitWidth
			&& y - originY < e.y - e.originY + e.hitHeight)
			{
				if (!_mask)
				{
					if (!e._mask || e._mask.collide(HITBOX))
					{
						this.x = _x; this.y = _y;
						return e;
					}
					this.x = _x; this.y = _y;
					return null;
				}
				if (_mask.collide(e._mask ? e._mask : e.HITBOX))
				{
					this.x = _x; this.y = _y;
					return e;
				}
			}
			this.x = _x; this.y = _y;
			return null;
		}
		
		
		
		
		/*
		 * Checks for a collision against an Entity type.
		 * @param	type		The Entity type to check for.
		 * @param	x			Virtual x position to place this Entity.
		 * @param	y			Virtual y position to place this Entity.
		 * @return	The first Entity collided with, or null if none were collided.
		*/
		public function collide(type:String, x:Number, y:Number):Entity
		{
			if (!this.world) return null;
			var entity:Entity;
			
			var allEnitiesOfType:Vector.<Entity> = this.world.getType(type);
			//if undefined return
			if (!allEnitiesOfType) return null;
			var numEnities:int = allEnitiesOfType.length;
			//if 0 return
			if (!numEnities) return null;
			
			for (var i:int = 0; i < numEnities; i++) 
			{
				var currentEntity:Entity = allEnitiesOfType[i];
				entity = this.collideWith(currentEntity, x, y);
				if (entity) 
					return entity;
			}
			return entity;
		}
			/*
		 * Checks for a collision against an Entity type.
		 * @param	type		The Entity type to check for.
		 * @param	x			Virtual x position to place this Entity.
		 * @param	y			Virtual y position to place this Entity.
		 * @return	The first Entity collided with, or null if none were collided.
		*/
		public function Intersect(type:String, x:Number, y:Number):Boolean
		{
			if (!this.world) return false;
			var entity:Entity;
			
			var allEnitiesOfType:Vector.<Entity> = this.world.getType(type);
			//if undefined return
			if (!allEnitiesOfType) return false;
			var numEnities:int = allEnitiesOfType.length;
			//if 0 return
			if (!numEnities) return false;
			
			for (var i:int = 0; i < numEnities; i++) 
			{
				var currentEntity:Entity = allEnitiesOfType[i];
				entity = this.collideWith(currentEntity, x, y);
				if (entity) 
					return true;
			}
			return true;
		}
		/**
		 * Checks for collision against multiple Entity types.
		 * @param	types		An Array or Vector of Entity types to check for.
		 * @param	x			Virtual x position to place this Entity.
		 * @param	y			Virtual y position to place this Entity.
		 * @return	The first Entity collided with, or null if none were collided.
		 */
		public function collideTypes(types:Object, x:Number, y:Number):Entity
		{
			if (!_world) return null;
			var entity:Entity;
			for each (var type:String in types)
			{
				if ((entity = collide(type, x, y))) return entity;
			}
			return null;
		}
		
				
		/**
		 * When you collide with an Entity on the x-axis with moveTo() or moveBy().
		 * @param	e		The Entity you collided with.
		 */
		public function moveCollideX(e:Entity):Boolean
		{
			
			return true;
		}
		
		/**
		 * When you collide with an Entity on the y-axis with moveTo() or moveBy().
		 * @param	e		The Entity you collided with.
		 */
		public function moveCollideY(e:Entity):Boolean
		{
			return true;
		}
		

				/**
		 * Moves the Entity by the amount, retaining integer values for its x and y.
		 * @param	x			Horizontal offset.
		 * @param	y			Vertical offset.
		 * @param	solidType	An optional collision type (or array of types) to stop flush against upon collision.
		 * @param	sweep		If sweeping should be used (prevents fast-moving objects from going through solidType).
		 */
		public function moveBy(x:Number, y:Number, solidType:Object = null, sweep:Boolean = false):void
		{
			_moveX += x;
			_moveY += y;
			x = Math.round(_moveX);
			y = Math.round(_moveY);
			_moveX -= x;
			_moveY -= y;
			if (solidType)
			{
				var sign:int, e:Entity;
				if (x != 0)
				{
					if (sweep || collideTypes(solidType, this.x + x, this.y))
					{
						sign = x > 0 ? 1 : -1;
						while (x != 0)
						{
							if ((e = collideTypes(solidType, this.x + sign, this.y)))
							{
								if (moveCollideX(e)) break;
								else this.x += sign;
							}
							else this.x += sign;
							x -= sign;
						}
					}
					else this.x += x;
				}
				if (y != 0)
				{
					if (sweep || collideTypes(solidType, this.x, this.y + y))
					{
						sign = y > 0 ? 1 : -1;
						while (y != 0)
						{
							if ((e = collideTypes(solidType, this.x, this.y + sign)))
							{
								if (moveCollideY(e)) break;
								else this.y += sign;
							}
							else this.y += sign;
							y -= sign;
						}
					}
					else this.y += y;
				}
			}
			else
			{
				this.x += x;
				this.y += y;
			}
			
			
			
		}
				/**
		 * Moves the Entity to the position, retaining integer values for its x and y.
		 * @param	x			X position.
		 * @param	y			Y position.
		 * @param	solidType	An optional collision type (or array of types) to stop flush against upon collision.
		 * @param	sweep		If sweeping should be used (prevents fast-moving objects from going through solidType).
		 */
		public function moveTo(x:Number, y:Number, solidType:Object = null, sweep:Boolean = false):void
		{
			moveBy(x - this.x, y - this.y, solidType, sweep);
		}
		
		/**
		 * Moves towards the target position, retaining integer values for its x and y.
		 * @param	x			X target.
		 * @param	y			Y target.
		 * @param	amount		Amount to move.
		 * @param	solidType	An optional collision type (or array of types) to stop flush against upon collision.
		 * @param	sweep		If sweeping should be used (prevents fast-moving objects from going through solidType).
		 */
		public function moveTowards(x:Number, y:Number, amount:Number, solidType:Object = null, sweep:Boolean = false):void
		{
			_point.x = x - this.x;
			_point.y = y - this.y;
			
			if (_point.x*_point.x + _point.y*_point.y > amount*amount) {
				_point.normalize(amount);
			}
			
			moveBy(_point.x, _point.y, solidType, sweep);
		}
		
				/**
		 * Clamps the Entity's hitbox on the x-axis.
		 * @param	left		Left bounds.
		 * @param	right		Right bounds.
		 * @param	padding		Optional padding on the clamp.
		 */
		public function clampHorizontal(left:Number, right:Number, padding:Number = 0):void
		{
			if (x - originX < left + padding) x = left + originX + padding;
			if (x - originX + hitWidth > right - padding) x = right - hitWidth + originX - padding;
		}
		
		/**
		 * Clamps the Entity's hitbox on the y axis.
		 * @param	top			Min bounds.
		 * @param	bottom		Max bounds.
		 * @param	padding		Optional padding on the clamp.
		 */
		public function clampVertical(top:Number, bottom:Number, padding:Number = 0):void
		{
			if (y - originY < top + padding) y = top + originY + padding;
			if (y - originY + hitHeight > bottom - padding) y = bottom - hitHeight + originY - padding;
		}
		
			/**
		 * Checks if this Entity overlaps the specified rectangle.
		 * @param	x			Virtual x position to place this Entity.
		 * @param	y			Virtual y position to place this Entity.
		 * @param	rX			X position of the rectangle.
		 * @param	rY			Y position of the rectangle.
		 * @param	rWidth		Width of the rectangle.
		 * @param	rHeight		Height of the rectangle.
		 * @return	If they overlap.
		 */
		
		public function collideRect(x:Number, y:Number, rX:Number, rY:Number, rWidth:Number, rHeight:Number):Boolean
		{
			if (x - originX + hitWidth >= rX && y - originY + hitHeight >= rY && x - originX <= rX + rWidth && y - originY <= rY + rHeight)
			{
				if (!_mask) return true;
				_x = this.x; 
				_y = this.y;
				this.x = x; 
				this.y = y;
				SP.entity.x = rX;
				SP.entity.y = rY;
				SP.entity.hitWidth = rWidth;
				SP.entity.hitHeight = rHeight;
				if (_mask.collide(SP.entity.HITBOX))
				{
					this.x = _x;
					this.y = _y;
					return true;
				}
				this.x = _x; 
				this.y = _y;
				return false;
			}
			return false;
		}
		/**
		 * Calculates the distance from another Entity.
		 * @param	e				The other Entity.
		 * @param	useHitboxes		If hitboxes should be used to determine the distance. If not, the Entities' x/y positions are used.
		 * @return	The distance.
		 */
		public function distanceFrom(e:Entity, useHitboxes:Boolean = false):Number
		{
			if (!useHitboxes) return Math.sqrt((x - e.x) * (x - e.x) + (y - e.y) * (y - e.y));
			return SP.distanceRects(x - originX, y - originY, hitWidth,hitHeight, e.x - e.originX, e.y - e.originY, e.hitWidth, e.hitHeight);
		}
		
		/**
		 * Calculates the distance from this Entity to the point.
		 * @param	px				X position.
		 * @param	py				Y position.
		 * @param	useHitbox		If hitboxes should be used to determine the distance. If not, the Entities' x/y positions are used.
		 * @return	The distance.
		 */
		public function distanceToPoint(px:Number, py:Number, useHitbox:Boolean = false):Number
		{
			if (!useHitbox) return Math.sqrt((x - px) * (x - px) + (y - py) * (y - py));
			return SP.distanceRectPoint(px, py, x - originX, y - originY, hitWidth, hitHeight);
		}
		
		/**
		 * Calculates the distance from this Entity to the rectangle.
		 * @param	rx			X position of the rectangle.
		 * @param	ry			Y position of the rectangle.
		 * @param	rwidth		Width of the rectangle.
		 * @param	rheight		Height of the rectangle.
		 * @return	The distance.
		 */
		public function distanceToRect(rx:Number, ry:Number, rwidth:Number, rheight:Number):Number
		{
			return SP.distanceRects(rx, ry, rwidth, rheight, x - originX, y - originY, width, height);
		}
		
		/**
		 * Gets the class name as a string.
		 * @return	A string representing the class name.
		 */
		public function toString():String
		{
			var s:String = String(_class);
			return s.substring(7, s.length - 1);
		}
		/**
		 * gets the correct rectange based of bounds of entity and pivot point
		 * @param	xOffset Virtual x position to place this Entity.
		 * @param	yOffset Virtual y position to place this Entity.
		 * @return
		 */
		public function getRect(xOffset:Number, yOffset:Number):Rectangle
		{
			 var returnrect:Rectangle = this._hitBounds;

				
			returnrect.x = xOffset - pivotX - _originX;
			returnrect.y = yOffset - pivotY - _originY;
			returnrect.width  = 20;//this.hitWidth;
			returnrect.height = 20;//this.hitHeight;
			
			return returnrect;
		

			
		}
		
		/**
		 * Sets the Entity's hitbox properties.
		 * @param	width		Width of the hitbox.
		 * @param	height		Height of the hitbox.
		 * @param	originX		X origin of the hitbox.
		 * @param	originY		Y origin of the hitbox.
		 */
		public function setHitbox(width:int = 0, height:int = 0, originX:int = 0, originY:int = 0):void
		{
			this.hitWidth = width;
			this.hitHeight = height;
			this.originX = originX;
			this.originY = originY;
			//_hitBounds.setTo(originX, originY, width, height);
		}
		
		/**
		 * Sets the origin of the Entity.
		 * @param	x		X origin.
		 * @param	y		Y origin.
		 */
		public function setOrigin(x:int = 0, y:int = 0):void
		{
			originX = x;
			originY = y;
			_hitBounds.x = originX;
			_hitBounds.y = originY;
		}
		
		/**
		 * Center's the Entity's origin (half width and height).
		 */
		public function centerOrigin():void
		{
			originX = (hitWidth / 2) - width / 2;
			originY = (hitHeight / 2) - height / 2;
			_hitBounds.x = originX;
			_hitBounds.y = originY;
		}


		
		
		/**
		 * sets the hit bounds width
		 * @param	width
		 */
		public function setHitWidth(width:Number):void
		{
			this.hitWidth = width;
			
			
			
			var rect:Rectangle = getRect(this.x, this.y);
			rect.width = width;
			_hitBounds = rect;
		
		}
		
		/**
		 * sets the hit bounds height
		 * @param	width
		 */
		public function setHitHeight(height:Number):void
		{
			this.hitHeight = height;
	
			var rect:Rectangle = getRect(this.x, this.y);
			rect.height = height;
			_hitBounds = rect;
		}
		
		
		//----------
		//  abstract methods
		//----------
		
		/**
		* Override this; called when Entity updates
		*/
		public function update():void 
		{
			var point:Point = new Point(x, y);
			point = localToGlobal(point);
			_worldX = point.x;
		}
		

		public function get graphic():Image { return _graphic; }
		public function set graphic(value:Image):void
		{
			if (_graphic == value) return;
			setHitbox(value.width, value.height);
			_graphic = value;
			addChild(_graphic);
			
		}
		
		/**
		* Override this, called when the Entity is added to a World.
		*/
		public function added():void { }
		
		/**
		* Override this, called when the Entity is removed from a World.
		*/
		public function removed():void { }
		
		/**
		* Override this not called internally 
		*/
		public function destroy():void { }
		
	}
}