package com.djoker.Particles 
{
	
	import starling.extensions.BatchItem;
	import starling.extensions.ImageBatch;
	import starling.textures.Texture;
	import com.djoker.Misc.SColor;
	
	
	/**
	 * ...
	 * @author djoker
	 */
	public class ParticleSystemInfo 
	{
		 
    public var Emission:int;
    public var Lifetime: Number;

    public var ParticleLifeMin: Number;
    public var ParticleLifeMax: Number;

   public var  Direction: Number;
   public var  Spread: Number;
   public var  Relative: Boolean;

   public var  SpeedMin: Number;
   public var  SpeedMax: Number;

  public var   GravityMin: Number;
  public var   GravityMax: Number;

  public var   RadialAccelMin: Number;
  public var   RadialAccelMax: Number;

   public var  TangentialAccelMin: Number;
   public var  TangentialAccelMax: Number;

  public var   SizeStart: Number;
   public var  SizeEnd: Number;
   public var  SizeVar: Number;

 public var    SpinStart: Number;
  public var   SpinEnd: Number;
  public var   SpinVar: Number;

  public var   ColorStart: SColor;
  public var   ColorEnd: SColor;
  public var   ColorVar: Number;
  public var   AlphaVar: Number;
		
		public function ParticleSystemInfo() 
		{
			ColorStart = new SColor();
			ColorEnd = new SColor();

Emission=40;
Lifetime=-1.000;
ParticleLifeMin=0.437;
ParticleLifeMax=0.992;
Direction=0.000;
Spread=6.283;
Relative=false
SpeedMin=85.714;
SpeedMax=104.762
GravityMin=0.000;
GravityMax=0.000
RadialAccelMin=-71.429;
RadialAccelMax=-71.429;
TangentialAccelMin=0.000;
TangentialAccelMax=0.000;
SizeStart=0.989;
SizeEnd=0.301;
SizeVar=0.000;
SpinStart=19.841;
SpinEnd=19.841;
SpinVar=0.524;
ColorVar=0.206;
AlphaVar=0.206;
ColorStart.red=0.095;
ColorStart.green=0.802;
ColorStart.blue=0.357;
ColorStart.alpha=1.000;
ColorEnd.red=0.413;
ColorEnd.green=0.159;
ColorEnd.blue=0.889;
ColorEnd.alpha=0.286;


			
		}
		
		public function Smoke():void
		{
Emission=268;
Lifetime=-1.000;
ParticleLifeMin=3.056;
ParticleLifeMax=4.008;
Direction=0.801;
Spread=0.000;
Relative=false
SpeedMin=300.000;
SpeedMax=300.000
GravityMin=0.000;
GravityMax=0.000
RadialAccelMin=14.286;
RadialAccelMax=0.000;
TangentialAccelMin=-14.286;
TangentialAccelMax=0.000;
SizeStart=2.192;
SizeEnd=0.471;
SizeVar=0.357;
SpinStart=-0.159;
SpinEnd=-0.159;
SpinVar=0.000;
ColorVar=0.278;
AlphaVar=0.278;
ColorStart.red=0.849;
ColorStart.green=0.667;
ColorStart.blue=0.056;
ColorStart.alpha=1.000;
ColorEnd.red=0.333;
ColorEnd.green=0.159;
ColorEnd.blue=0.786;
ColorEnd.alpha=0.381;
		
		}
		public function Fontain():void		
		{
Emission=138;
Lifetime=-1.000;
ParticleLifeMin=0.476;
ParticleLifeMax=1.032;
Direction=0.000;
Spread=0.675;
Relative=false
SpeedMin=300.000;
SpeedMax=300.000
GravityMin=428.571;
GravityMax=728.571
RadialAccelMin=-0.794;
RadialAccelMax=-0.794;
TangentialAccelMin=-0.159;
TangentialAccelMax=-0.159;
SizeStart=1.676;
SizeEnd=0.154;
SizeVar=0.444;
SpinStart=-50.000;
SpinEnd=8.730;
SpinVar=0.063;
ColorVar=0.413;
AlphaVar=0.413;
ColorStart.red=0.944;
ColorStart.green=0.183;
ColorStart.blue=0.095;
ColorStart.alpha=0.611;
ColorEnd.red=1.000;
ColorEnd.green=0.802;
ColorEnd.blue=0.071;
ColorEnd.alpha=0.119;
		}
		public function Fire():void
		{
Emission=67;
Lifetime=-1.000;
ParticleLifeMin=1.071;
ParticleLifeMax=1.944;
Direction=0.000;
Spread=1.181;
Relative=false
SpeedMin=114.286;
SpeedMax=190.476
GravityMin=0.000;
GravityMax=0.000
RadialAccelMin=0.000;
RadialAccelMax=0.000;
TangentialAccelMin=0.000;
TangentialAccelMax=0.000;
SizeStart=1.529;
SizeEnd=2.511;
SizeVar=0.278;
SpinStart=0.000;
SpinEnd=0.000;
SpinVar=0.000;
ColorVar=0.000;
AlphaVar=0.000;
ColorStart.red=1.000;
ColorStart.green=0.738;
ColorStart.blue=0.000;
ColorStart.alpha=0.905;
ColorEnd.red=0.571;
ColorEnd.green=0.000;
ColorEnd.blue=0.246;
ColorEnd.alpha=0.056;
			
		}
		
		
	}

}