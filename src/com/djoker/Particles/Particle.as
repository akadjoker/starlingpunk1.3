package com.djoker.Particles 
{
	
		
	import starling.extensions.BatchItem;
	import starling.extensions.ImageBatch;
	import starling.textures.Texture;
	import com.djoker.Misc.SColor;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author djoker
	 */
	public class Particle 
	{
	 public var Location: Point;
    public var Velocity: Point;

   public var  Gravity: Number;
    public var RadialAccel: Number;
    public var TangentialAccel: Number;

    public var Spin: Number;
    public var SpinDelta: Number;

    public var Size: Number;
    public var SizeDelta: Number;

    public var Color: SColor;
    public var ColorDelta: SColor;

   public var  Age: Number;
    public var TerminalAge: Number;
	
	public var item:BatchItem;
	
		public function Particle() 
		{
			Location = new Point();
			Velocity = new Point();
			Color = new SColor();
			ColorDelta = new SColor();
			Location= new Point();
            Velocity = new Point();
	
			
			
		}
		
	}

}