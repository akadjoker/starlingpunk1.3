package com.djoker.graphics 
{

	import com.djoker.Entity;
	
	public class Anim 
	{
		/**
		 * Constructor.
		 * @param	name		Animation name.
		 * @param	frames		Array of frame indices to animate.
		 * @param	frameRate	Animation speed.
		 * @param	loop		If the animation should loop.
		 */
		public function Anim(name:String, frames:Array, frameRate:Number = 0, loop:Boolean = true) 
		{
			_name = name;
			_frames = frames;
			_frameRate = frameRate;
			_loop = loop;
			_frameCount = frames.length;
		}
		
		/**
		 * Plays the animation.
		 * @param	reset		If the animation should force-restart if it is already playing.
		 */
		public function play(reset:Boolean = false):void
		{
			_parent.play(_name, reset);
		}
		
		/**
		 * Name of the animation.
		 */
		public function get name():String { return _name; }
		
		/**
		 * Array of frame indices to animate.
		 */
		public function get frames():Array { return _frames; }
		
		/**
		 * Animation speed.
		 */
		public function get frameRate():Number { return _frameRate; }
		
		/**
		 * Amount of frames in the animation.
		 */
		public function get frameCount():uint { return _frameCount; }
		
		/**
		 * If the animation loops.
		 */
		public function get loop():Boolean { return _loop; }
		
		 public var _parent:Spritemap;
		/** @private */ public var _name:String;
		/** @private */ public var _frames:Array;
		/** @private */ public var _frameRate:Number;
		/** @private */ public var _frameCount:uint;
		/** @private */ public var _loop:Boolean;
	}
}