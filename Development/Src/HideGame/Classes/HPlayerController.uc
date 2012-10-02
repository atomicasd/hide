class HPlayerController extends UTPlayerController;

var     bool	pulseMade;
var     float	pulseMaxRadius;
var     float	pulseRadius;

var     class<HInformation_Player>  HPlayerInfo;
var     HInformation_Player         PlayerInfo;

var     bool    bInEndOfLevel;

function CreatePlayerInformation()
{
	Playerinfo = new HPlayerInfo;
}

simulated event PostBeginPlay()
{
	local FogVolumeSphericalDensityInfo A;

	super.PostBeginPlay();

	ForEach WorldInfo.AllActors(class'FogVolumeSphericalDensityInfo', A)
	{
		A.DensityComponent.StartDistance = 20000;
		A.ForceUpdateComponents();
	}

	super.PostBeginPlay();
}

function EnablePulse()
{
	pulseMade = true;
	pulseRadius = 0;
}

function DisablePulse()
{
	local FogVolumeSphericalDensityInfo A;
	ForEach WorldInfo.AllActors(class'FogVolumeSphericalDensityInfo', A)
	{
		A.DensityComponent.StartDistance = 20000;
		A.ForceUpdateComponents();
	}
	super.PostBeginPlay();
}

function PlayerTick(float DeltaTime)
{
	local FogVolumeSphericalDensityInfo A;
	local FogVolumeSphericalDensityComponent B;
	if( pulseMade )
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

			pulseRadius += 20 - (20 * (pulseRadius/pulseMaxRadius) );
		}
	}
	
        //this line is not need if you add this code to PlayerController.uc
	Super.PlayerTick(DeltaTime);
}

exec function makePulseCircle()
{
	pulseMade = true;
	pulseRadius = 1;
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
	pulseMaxRadius = 2500;
	pulseRadius = 1;
}

