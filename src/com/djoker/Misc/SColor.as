package com.djoker.Misc {

	
	
	public class SColor {
		/** The red component, between 0 and 1. */
		public var red:Number;
		/** The green component, between 0 and 1. */
		public var green:Number;
		/** The blue component, between 0 and 1. */
		public var blue:Number;
		/** The alpha component, between 0 and 1. */
		public var alpha:Number;
		
	
		public function SColor(red:Number = 1, green:Number = 1, blue:Number = 1, alpha:Number = 1) {
			this.red = red;
			this.green = green;
			this.blue = blue;
			this.alpha = alpha;
		}
		
	
		public function get hex():uint {
			return ((int)(255 * alpha / 1) << 24) + ((int)(255 * red / 1) << 16) + ((int)(255 * green / 1) << 8) + (int)(255 * blue / 1);
		}
		
		public  function getColorRGB(R:uint = 0, G:uint = 0, B:uint = 0):uint
		{
			return R << 16 | G << 8 | B;
		}
	
		public  function getColor():Number
			{
				var r:int = int(this.red * 255);
				var g:int = int(this.green * 255);
				var b:int = int(this.blue * 255);
				
			  return  Number( getColorRGB(r, g, b));
		    }
			
			public  function getrgb():uint
			{
			return  ((int)(255 * red / 1) << 16) + ((int)(255 * green / 1) << 8) + (int)(255 * blue / 1);
		    }
		
			public  function getrgba():uint
			{
			return  ((int)(255 * alpha / 1) << 24) + ((int)(255 * red / 1) << 16) + ((int)(255 * green / 1) << 8) + (int)(255 * blue / 1);
		    }
		

		public function set hex(value:uint):void {
			alpha = ((value & 0xff000000) >> 24) / 0xff;
			red = ((value & 0x00ff0000) >> 16) / 0xff;
			green = ((value & 0x0000ff00) >> 8) / 0xff;
			blue = (value & 0x000000ff) / 0xff;
		}
		

		public static function fromHex(value:uint):SColor {
			var color:SColor = new SColor;
			color.hex = value;
			return color;
		}
	}
}
