class HPlayerController extends UTPlayerController;

var bool pulseMade;
var float pulseMaxRadius;
var float pulseRadius;


DefaultProperties
{
	CameraClass = class'HideGame.HCamera';

	//Points to the UTFamilyInfo class for your custom character
	CharacterClass=class'UTFamilyInfo_Liandri_Male'

	pulseMade = false;
	pulseMaxRadius = 3000;
	pulseRadius = 0;

}

function PlayerTick(float DeltaTime)
{
	local FogVolumeSphericalDensityInfo A;

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
				A.ForceUpdateComponents();
			}

			pulseRadius += 30.0f;
		}
	}
	
        //this line is not need if you add this code to PlayerController.uc
	Super.PlayerTick(DeltaTime);
}

exec function makePulseCircle()
{
	pulseMade = true;
	pulseRadius = 0;
	`log("Making pulse effect");
}