class HPlayerController extends UTPlayerController;

enum PlayerWalkingState
{
	Idle,
	Walk,
	Sneak,
	Run
};

var     bool    bInEndOfLevel;
var     bool    bChangedState;

var     bool	pulseMade;
var     bool    pulseFadeOut; //If the pulse should go outwards or towards the player(end of pulse)
var     float	pulseMaxRadius;
var     float	pulseRadius;
var     float   fadeOutStart;

var     class<HInformation_Player>  HPlayerInfo;
var     HInformation_Player         PlayerInfo;
var     PlayerWalkingState          WalkState;

simulated event PostBeginPlay()
{
	local FogVolumeSphericalDensityInfo A;

	super.PostBeginPlay();

	ForEach WorldInfo.AllActors(class'FogVolumeSphericalDensityInfo', A)
	{
		A.DensityComponent.StartDistance = 20000;
		A.ForceUpdateComponents();
	}
	SpawnPlayerCamera();
	WalkState = Idle;
}

function EnablePulse()
{
	pulseMade = true;
	pulseRadius = 0.0f;
	pulseFadeOut = true;
}

function PulseFadeIn()
{
	pulseFadeOut = false;
}

function PlayerTick(float DeltaTime)
{
	local FogVolumeSphericalDensityInfo A;
	local FogVolumeSphericalDensityComponent B;
	if( pulseMade )
	{
		if( pulseFadeOut )
		{
			ForEach WorldInfo.AllActors(class'FogVolumeSphericalDensityInfo', A)
			{
				if( pulseRadius >= pulseMaxRadius )
				{
					pulseMade = false;
				} else
				{
					A.DensityComponent.StartDistance = pulseRadius;
					ForEach A.ComponentList( class'FogVolumeSphericalDensityComponent', B )
					{
					
						B.MaxDensity = (pulseMaxRadius + 900) / ( pulseMaxRadius/5 * pulseRadius);
						B.ForceUpdate(true);
					}
				
					A.ForceUpdateComponents();
				}

				pulseRadius += DeltaTime*2000 - ( (DeltaTime*2000) * (pulseRadius/pulseMaxRadius) );
			}
		} else {
			ForEach WorldInfo.AllActors(class'FogVolumeSphericalDensityInfo', A)
			{
				if( pulseRadius <= 1 )
				{
					ForEach A.ComponentList( class'FogVolumeSphericalDensityComponent', B )
					{
						if( fadeOutStart <= 0 )
						{
							B.MaxDensity = 0.0f;
							B.ForceUpdate(true);
							pulseMade = false;
							fadeOutStart = 0.5f;
						} else 
						{
							fadeOutStart -= DeltaTime;
							B.MaxDensity = fadeOutStart;
							B.ForceUpdate(true);
						}
					}
				} else 
				{
					A.DensityComponent.StartDistance = pulseRadius;
					ForEach A.ComponentList( class'FogVolumeSphericalDensityComponent', B )
					{
					
						B.MaxDensity = (pulseMaxRadius + 900) / ( pulseMaxRadius/5 * pulseRadius);
						B.ForceUpdate(true);
					}
				
					A.ForceUpdateComponents();
					pulseRadius -= DeltaTime*10000 - ( (DeltaTime*10000) * (pulseRadius/pulseMaxRadius) );
				}
			}
		}


	}

	// Player Input to change Walkingstate
	if(bChangedState)
	{
		switch(WalkState)
		{
		case Idle: 
			break;
		case Walk:
			Pawn.GroundSpeed = 250;
			break;
		case Sneak:
			Pawn.GroundSpeed = 150;
			break;
		case Run:
			Pawn.GroundSpeed = 400;
			break;
		}
		bChangedState=false;	
	}
	
	//this line is not need if you add this code to PlayerController.uc
	Super.PlayerTick(DeltaTime);
}

exec function makePulseCircle()
{
	pulseMade = true;
	pulseRadius = 1;
	pulseFadeOut = true;
	`log("Making pulse effect");
}

DefaultProperties
{
	HPlayerinfo = class'HideGame.HInformation_Player'
	InputClass = class'HideGame.HPlayerInput'
	CameraClass = class'HideGame.HCamera'

	//Points to the UTFamilyInfo class for your custom character
	//CharacterClass=class'UTFamilyInfo_Liandri_Male'
	
	pulseMade = false;
	pulseMaxRadius = 5000;
	pulseRadius = 1;
	pulseFadeOut = true;
	fadeOutStart = 0.5f;
}

