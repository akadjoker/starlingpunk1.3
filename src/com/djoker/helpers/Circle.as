package com.djoker.helpers   
{
	/**
	 * .
	 * @author djoker
	 */
	public class Circle 
	{
		public  var x:Number;
		public  var y:Number;
		public  var radius:Number;
		
		public function Circle(x:Number,  y:Number, radius:Number) 
		{
			this.x = x;
			this.y = y;
			this.radius = radius;
		}
		public function contains ( x:Number, y:Number) :Boolean
		{
		x = this.x - x;
		y = this.y - y;
		return x * x + y * y <= radius * radius;
	}
		public function setCircle ( x:Number ,  y:Number, radius:Number) :void
		{
		this.x = x;
		this.y = y;
		this.radius = radius;
	}
	}

}