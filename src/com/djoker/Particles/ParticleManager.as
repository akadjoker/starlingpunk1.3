package com.djoker.Particles 
{
	
	import flash.display.InteractiveObject;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.extensions.BatchItem;
	import starling.extensions.ImageBatch;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import com.djoker.Misc.SColor;
	import flash.geom.Point;
	import com.djoker.SP;
	
  
	
	/**
	 * ...
	 * @author djoker
	 */
	public class ParticleManager extends ImageBatch 

	{
		
	
     private const MAXP:Number   =100;
	 private const M_PI:Number   = 3.14159265358979323846;
     private const M_PI_2:Number = 1.57079632679489661923;
  
	private var FAge: Number;
    private var FEmissionResidue: Number;
    private var FPrevLocation: Point;
    private var FLocation: Point;
    private var FTX:Number;
	private var FTY: Number;
    private var FParticlesAlive:int;
    private var spaw:int;
	public var FInfo:ParticleSystemInfo;
	private var usetexture:Texture;
	
	private var Accel:Point;
	private var Accel2:Point;
	private var V:Point;
 

	
	private var Time:int = 0;
	private var LastEmitTime:int = 0;

		
		private var FParticles:Vector.<Particle> = new Vector.<Particle>();
		
		public function ParticleManager(texture:Texture,info:ParticleSystemInfo) 
		{
			
			super(texture);
			usetexture = texture;

			if (info != null)
			{
			
			}
			
			this.FInfo = info;
			FPrevLocation = new Point();
			FLocation = new Point(300, 300);
			
			 Accel= new Point();
	         Accel2= new Point();
             V= new Point();
			
			
			  FAge = -2;
              spaw=0;
			
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);

		}
		public function Fire():void
       {
         if (FInfo.Lifetime == -1) 
           FAge = -1;
            else
           FAge = 0;
	   }
public function functionFireAt( X:Number, Y: Number):void
{
  Stop();
  MoveTo(X,Y);
  Fire();
}

public function Stop(KillParticles: Boolean=false):void
{
  FAge = -2;
  if (KillParticles) FParticlesAlive = 0;
}

public function remove(entity:Particle):void 
{
			var index:uint = FParticles.indexOf(entity);
			if (index >= 0)
			{
				removeItem(entity.item);
				FParticles.splice(index, 1);
			}
		}

public function MoveTo( X:Number, Y:Number, MoveParticles: Boolean=false):void
{
  var I:int;
  var DX:Number;
  var DY:Number;

  if (MoveParticles) 
  {
    DX = X - FLocation.x;
    DY = Y - FLocation.y;
    for (I = 0; I < FParticlesAlive;I++)
	{
      FParticles[I].Location.x = FParticles[I].Location.x + DX;
      FParticles[I].Location.y = FParticles[I].Location.y + DY;
    }
    FPrevLocation.x = FPrevLocation.x + DX;
    FPrevLocation.y = FPrevLocation.y + DY;
  } else 
  {
    if (FAge == -2) 
	{
      FPrevLocation.x = X;
      FPrevLocation.y = Y;
    } else 
	{
      FPrevLocation.x = FLocation.x;
      FPrevLocation.y = FLocation.y;
    }
  }
  FLocation.x = X;
  FLocation.y = Y;
}


		public function LoadSystemInfo(value:ParticleSystemInfo):void
		{
		FInfo = value;
		}
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

 
			/*
			for (var i:int = 0; i<=FInfo.Emission ; i++) 
			{
				var Par:Particle = new Particle();
				Par.item = addItem();
				Par.item.texture = usetexture;
				Par.item.scale = 1;
				Par.item.angle = 0;
				Par.item.color = 0xFFFFFF;
				reset(Par);
				moveparticle(Par,SP.elapsed);
	            FParticles.push(Par);
			
	 }
	 
*/

		
			
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrame);
		}
		
		private function emitt( now:int, timeSinceLastCall:int):void
		{
			Time += timeSinceLastCall;
			
				
			var perSecond:Number;
			var MaxParticlesPerSecond:Number=40;
			var MinParticlesPerSecond:Number=35;
			
			
				var pps:int = (MaxParticlesPerSecond - MinParticlesPerSecond);
	            var perSecond:Number = pps ? Number(MinParticlesPerSecond) + (Math.random() % pps) : MinParticlesPerSecond;
	            var everyWhatMillisecond:Number = 1000.0 / perSecond;
				
				
				if (Time > everyWhatMillisecond)
	            {
		            Time = 0;
					
				var Par:Particle = new Particle();
				Par.item = addItem();
				Par.item.texture = usetexture;
				Par.item.scale = 1;
				Par.item.angle = 0;
				Par.item.color = 0xFFFFFFFF;
				reset(Par);
				
	            FParticles.push(Par);
					
	             }
				
		}
		
		private function doParticleSystem( time:int):void
		{
			
			if (LastEmitTime==0)
	        {
		     LastEmitTime = time;
		     return;
	        }
	
					var now:int = time;
	                var timediff:int = time - LastEmitTime;
	                 LastEmitTime = time;
					 
					 if (FParticles.length<this.FInfo.Emission)
		             emitt(now, timediff);
	
		}
		
		
		private function enterFrame(e:EnterFrameEvent):void 
		{
         // doParticleSystem(SP.GetTime);
		  
		  
	  if (FAge >= 0) 
      {
        FAge = FAge + SP.elapsed;
        if (FAge >= FInfo.Lifetime) 
        FAge = -2;
	  }
	  
	    move(SP.elapsed);
	  
	  //  if (FAge != -2) 
		{
   
  
		    var FEmissionResidue:int;
		    var  ParticlesNeeded:int  = FInfo.Emission * SP.elapsed + FEmissionResidue;
            var  ParticlesCreated:int = ParticlesNeeded;	
             FEmissionResidue = ParticlesNeeded - ParticlesCreated;
      	 
			 //trace(FParticlesAlive + '<>', ParticlesNeeded + '<>' + FEmissionResidue);
			 
			   var I:int;
			 
			    for (I = 0 ; I < ParticlesCreated; I++)
	            {
			    if (FParticles.length >= MAXP) break ;
        

		
				 var Par:Particle = new Particle();
				 Par.item = addItem();
				 Par.item.texture = usetexture;
				 Par.item.scale = 1;
				 Par.item.angle = 0;
				 Par.item.color = 0xFFFFFF;
				 reset(Par);
			     FParticles.push(Par);
				}
		    }
		FPrevLocation = FLocation;
		}
		
		private function reset(Par:Particle):void
		{
		var Ang:Number;	
	    Par.Age = 0;
        Par.TerminalAge = SP.randf(FInfo.ParticleLifeMin,FInfo.ParticleLifeMax);
        Par.Location.x = FPrevLocation.x + (FLocation.x - FPrevLocation.x)*  SP.randf(0.0,1.0);
        Par.Location.y = FPrevLocation.y + (FLocation.y - FPrevLocation.y)*  SP.randf(0.0,1.0);
        Par.Location.x = Par.Location.x +  SP.randf(-2.0,2.0);
        Par.Location.y = Par.Location.y +  SP.randf(-2.0,2.0);
        
		//Ang = FInfo.Direction - M_PI_2 + SP.randf(0, FInfo.Spread) - FInfo.Spread / 2;
		
		Ang = FInfo.Direction -1.57079632679489661923 + SP.randf(0, FInfo.Spread) - FInfo.Spread / 2;

		
        if (FInfo.Relative) 
        {
           V.x = FPrevLocation.x - FLocation.x;
           V.y = FPrevLocation.y - FLocation.y;
           Ang = Ang + (SP.VectorAnglTan(V) + M_PI_2);
        }
      Par.Velocity.x = Math.cos(Ang);
      Par.Velocity.y = Math.sin(Ang);
      Par.Velocity.x=Par.Velocity.x*SP.randf(FInfo.SpeedMin,FInfo.SpeedMax);
      Par.Velocity.y=Par.Velocity.y*SP.randf(FInfo.SpeedMin,FInfo.SpeedMax);


      Par.Gravity = SP.randf(FInfo.GravityMin,FInfo.GravityMax);
      Par.RadialAccel =SP.randf(FInfo.RadialAccelMin,FInfo.RadialAccelMax);
      Par.TangentialAccel = SP.randf(FInfo.TangentialAccelMin,FInfo.TangentialAccelMax);

      Par.Size = SP.randf(FInfo.SizeStart,FInfo.SizeStart+ (FInfo.SizeEnd - FInfo.SizeStart) * FInfo.SizeVar);
      Par.SizeDelta = (FInfo.SizeEnd - Par.Size) / Par.TerminalAge;

      Par.Spin = SP.randf(FInfo.SpinStart,FInfo.SpinStart+ (FInfo.SpinEnd - FInfo.SpinStart) * FInfo.SpinVar);
      Par.SpinDelta  = (FInfo.SpinEnd - Par.Spin) / Par.TerminalAge;
			

      Par.Color.red = SP.randf(FInfo.ColorStart.red,FInfo.ColorStart.red+ (FInfo.ColorEnd.red - FInfo.ColorStart.red) * FInfo.ColorVar);
      Par.Color.green = SP.randf(FInfo.ColorStart.green,FInfo.ColorStart.green+ (FInfo.ColorEnd.green - FInfo.ColorStart.green) * FInfo.ColorVar);
      Par.Color.blue = SP.randf(FInfo.ColorStart.blue,FInfo.ColorStart.blue+ (FInfo.ColorEnd.blue - FInfo.ColorStart.blue) * FInfo.ColorVar);
      Par.Color.alpha = SP.randf(FInfo.ColorStart.alpha,FInfo.ColorStart.alpha+ (FInfo.ColorEnd.alpha - FInfo.ColorStart.alpha) * FInfo.ColorVar);

      Par.ColorDelta.red = (FInfo.ColorEnd.red - Par.Color.red) / Par.TerminalAge;
      Par.ColorDelta.green = (FInfo.ColorEnd.green - Par.Color.green) / Par.TerminalAge;
      Par.ColorDelta.blue = (FInfo.ColorEnd.blue - Par.Color.blue) / Par.TerminalAge;
      Par.ColorDelta.alpha = (FInfo.ColorEnd.alpha - Par.Color.alpha) / Par.TerminalAge;
	  
	}
		
		
private function move( DeltaTime: Number):void
{
	  var Ang:Number;
	  var I:int;
		  
	  
	  while (I<FParticles.length)
	 {
	  var Par:Particle = FParticles[I];
	  Par.Age = Par.Age + DeltaTime;
	
         if (Par.Age >= Par.TerminalAge || Par.Color.alpha < 0.0)  
             {
              //      reset(Par); 
			   	 remove(Par);
			   continue;
		
	         }			

    Accel.x = Par.Location.x - FLocation.x;
    Accel.y = Par.Location.y - FLocation.y;




    Accel=SP.VectorNormalize(Accel);
    Accel2 = Accel;
    Accel.x=Accel.x*Par.RadialAccel;
    Accel.y=Accel.y*Par.RadialAccel;


    Ang = Accel2.x;
    Accel2.x = -Accel2.y;
    Accel2.y = Ang;




    Accel2.x=Accel2.x*Par.TangentialAccel;
    Accel2.y=Accel2.y*Par.TangentialAccel;

    Par.Velocity.x=Par.Velocity.x+(Accel.x + Accel2.x) * DeltaTime;
    Par.Velocity.y=Par.Velocity.y+(Accel.y + Accel2.y) * DeltaTime;

    Par.Velocity.y = Par.Velocity.y + (Par.Gravity * DeltaTime);

    Par.Location.x=Par.Location.x+(Par.Velocity.x * DeltaTime);
    Par.Location.y=Par.Location.y+(Par.Velocity.y * DeltaTime);


    Par.Spin = Par.Spin + (Par.SpinDelta * DeltaTime);
    Par.Size  = Par.Size + (Par.SizeDelta * DeltaTime);
		

    Par.Color.red = Par.Color.red     + (Par.ColorDelta.red * DeltaTime);
    Par.Color.green = Par.Color.green + (Par.ColorDelta.green * DeltaTime);
    Par.Color.blue = Par.Color.blue   + (Par.ColorDelta.blue * DeltaTime);
    Par.Color.alpha = Par.Color.alpha + (Par.ColorDelta.alpha * DeltaTime);
	
	

		 
	Par.item.x = Par.Location.x;
	Par.item.y = Par.Location.y;
	Par.item.color = Par.Color.getrgb();
	Par.item.alpha = Par.Color.alpha;
	Par.item.angle = Par.Spin*Par.Age;
	Par.item.scale = Par.Size;
	  
    I++;
	
	
		  
  }
}







}

}