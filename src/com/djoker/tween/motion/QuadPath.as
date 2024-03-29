﻿package com.djoker.tween.motion 
{
	import flash.geom.Point;
import com.djoker.SP
	
	/**
	 * A series of points which will determine a path from the
	 * beginning point to the end poing using quadratic curves.
	 */
	public class QuadPath extends Motion
	{
		/**
		 * Constructor.
		 * @param	complete	Optional completion callback.
		 * @param	type		Tween type.
		 */
		public function QuadPath(complete:Function = null, type:uint = 0) 
		{
			super(0, complete, type, null);
			_curveT[0] = 0;
		}
		
		/**
		 * Starts moving along the path.
		 * @param	duration	Duration of the movement.
		 * @param	ease		Optional easer function.
		 */
		public function setMotion(duration:Number, ease:Function = null):void
		{
			updatePath();
			_target = duration;
			_speed = _distance / duration;
			_ease = ease;
			start();
		}
		
		/**
		 * Starts moving along the path at the speed.
		 * @param	speed		Speed of the movement.
		 * @param	ease		Optional easer function.
		 */
		public function setMotionSpeed(speed:Number, ease:Function = null):void
		{
			updatePath();
			_target = _distance / speed;
			_speed = speed;
			_ease = ease;
			start();
		}
		
		/**
		 * Adds the point to the path.
		 * @param	x		X position.
		 * @param	y		Y position.
		 */
		public function addPoint(x:Number = 0, y:Number = 0):void
		{
			_updateCurve = true;
			if (!_points.length) _curve[0] = new Point(x, y);
			_points[_points.length] = new Point(x, y);
		}
		
		/**
		 * Gets the point on the path.
		 * @param	index		Index of the point.
		 * @return	The Point object.
		 */
		public function getPoint(index:uint = 0):Point
		{
			if (!_points.length) throw new Error("No points have been added to the path yet.");
			return _points[index % _points.length];
		}
		
		/** @private Starts the Tween. */
		override public function start():void 
		{
			_index = 0;
			super.start();
		}
		
		/** @private Updates the Tween. */
		override public function update():void 
		{
			super.update();
			if (_index < _curve.length - 1)
			{
				while (_t > _curveT[_index + 1]) _index ++;
			}
			var td:Number = _curveT[_index],
				tt:Number = _curveT[_index + 1] - td;
			td = (_t - td) / tt;
			_a = _curve[_index];
			_b = _points[_index + 1];
			_c = _curve[_index + 1];
			x = _a.x * (1 - td) * (1 - td) + _b.x * 2 * (1 - td) * td + _c.x * td * td;
			y = _a.y * (1 - td) * (1 - td) + _b.y * 2 * (1 - td) * td + _c.y * td * td;
		}
		
		/** @private Updates the path, preparing the curve. */
		private function updatePath():void
		{
			if (_points.length < 3)	throw new Error("A QuadPath must have at least 3 points to operate.");
			if (!_updateCurve) return;
			_updateCurve = false;
			
			// produce the curve points
			var p:Point,
				c:Point,
				l:Point = _points[1],
				i:uint = 2;
			while (i < _points.length)
			{
				p = _points[i];
				if (_curve.length > i - 1) c = _curve[i - 1];
				else c = _curve[i - 1] = new Point;
				if (i < _points.length - 1)
				{
					c.x = l.x + (p.x - l.x) / 2;
					c.y = l.y + (p.y - l.y) / 2;
				}
				else
				{
					c.x = p.x;
					c.y = p.y;
				}
				l = p;
				i ++;
			}
			
			// find the total distance of the path
			i = 0;
			_distance = 0;
			while (i < _curve.length - 1)
			{
				_curveD[i] = curveLength(_curve[i], _points[i + 1], _curve[i + 1]);
				_distance += _curveD[i ++];
			}
			
			// find t for each point on the curve
			i = 1;
			var d:Number = 0;
			while (i < _curve.length - 1)
			{
				d += _curveD[i];
				_curveT[i ++] = d / _distance;
			}
			_curveT[_curve.length - 1] = 1;
		}
		
		/**
		 * Amount of points on the path.
		 */
		public function get pointCount():Number { return _points.length; }
		
		/** @private Calculates the length of the curve. */
		private function curveLength(start:Point, control:Point, finish:Point):Number
		{
			var a:Point = SP.point,
				b:Point = SP.point2;
			a.x = start.x - 2 * control.x + finish.x;
			a.y = start.y - 2 * control.y + finish.y;
			b.x = 2 * control.x - 2 * start.x;
			b.y = 2 * control.y - 2 * start.y;
			var A:Number = 4 * (a.x * a.x + a.y * a.y),
				B:Number = 4 * (a.x * b.x + a.y * b.y),
				C:Number = b.x * b.x + b.y * b.y,
				ABC:Number = 2 * Math.sqrt(A + B + C),
				A2:Number = Math.sqrt(A),
				A32:Number = 2 * A * A2,
				C2:Number = 2 * Math.sqrt(C),
				BA:Number = B / A2;
			return (A32 * ABC + A2 * B * (ABC - C2) + (4 * C * A - B * B) * Math.log((2 * A2 + BA + ABC) / (BA + C2))) / (4 * A32);
		}
		
		// Path information.
		/** @private */ private var _points:Vector.<Point> = new Vector.<Point>;
		/** @private */ private var _distance:Number = 0;
		/** @private */ private var _speed:Number = 0;
		/** @private */ private var _index:uint = 0;
		
		// Curve information.
		/** @private */ private var _updateCurve:Boolean = true;
		/** @private */ private var _curve:Vector.<Point> = new Vector.<Point>;
		/** @private */ private var _curveT:Vector.<Number> = new Vector.<Number>;
		/** @private */ private var _curveD:Vector.<Number> = new Vector.<Number>;
		
		// Curve points.
		/** @private */ private var _a:Point;
		/** @private */ private var _b:Point;
		/** @private */ private var _c:Point;
	}
}