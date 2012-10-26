class HPawn_Player extends HPawn;

var     HFamilyInfo_Player      CharacterInfo;
var     HSoundBeacon            soundBeacon;
var     int                     waitSoundStep;

var     bool                    steppedOnNerve;
var     Vector                  steppedLocation;
var     Rotator                 steppedRotation;
var     HPawn_Nervorum          nervorumKilledBy;
var     float                   pullSpeed;
var     float                   waitTillPull;
var     float                   positionAlpha;
var     bool                    cameraFadeStarted;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	// Sets the FamilyInfo
	HSetCharacterClassFromInfo(class'HFamilyInfo_Player');

	// Creates players SoundBeacon
	soundBeacon = Spawn(class'HSoundBeacon',,, Location,,, true);
	soundBeacon.bIsPlayerSpawned=true;
	
}

simulated event ActuallyPlayFootStepSound(int FootDown)
{
	local int skipSteps;
	switch(HPlayerController(Controller).WalkState)
	{
	case Idle: skipSteps=0; break;
	case Walk: skipSteps=1; break;
	case Sneak: skipSteps=2; break;
	case Run: skipSteps=0; break;
	}
	if(waitSoundStep < skipSteps){
		waitSoundStep++;
	}else{
		waitSoundStep=0;
		if(HPlayerController(Controller).WalkState == Sneak)
			super.ActuallyPlayFootStepSound(0);
		else
			super.ActuallyPlayFootStepSound(1);
	}
}

function bool Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	soundBeacon.bIsPlayerDead=true;
	return super.Died(Killer, damageType, HitLocation);
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
	local HCamera pCamera;

	pCamera = HCamera( HPlayerController( GetALocalPlayerController() ).PlayerCamera);
	pCamera.FadeToNormal( 0.5 );
	soundBeacon.bIsPlayerDead=false;

}

exec function KillYourself()
{
	Suicide();
}

/*
 * Spawnes the soundBeacon
 */
event Tick(float TimeDelta)
{
	local int soundRadius;
	local Vector vectorToNervorum;
	local Vector normalizedVectorToNervorum;
	local HPlayerController pController;
	local HCamera pCamera;

	switch(HPlayer.WalkState)   
	{
	case Idle:  soundRadius=160;  break;
	case Sneak: soundRadius=200;  break;
	case Walk:  soundRadius=400;  break;
	case Run:   soundRadius=500; break;
	}
	
	soundBeacon.SetLocation(Location);
	soundBeacon.Radius=soundRadius;

	/*
	foreach WorldInfo.AllActors(class'HNervorum_GroundNerve', Nerve)
	{
		if(Nerve.CheckCollision())
			KillYourself();
	}
	*/
	
	if( steppedOnNerve )
	{
		if( waitTillPull < 0.0 )
		{
			vectorToNervorum = nervorumKilledBy.Location - Location;
			normalizedVectorToNervorum = Normal( vectorToNervorum );
			//steppedLocation += normalizedVectorToNervorum * pullSpeed;
		} else
		{
			waitTillPull -= TimeDelta;
		}
		vectorToNervorum = nervorumKilledBy.Location - Location;
		normalizedVectorToNervorum = Normal( vectorToNervorum );

		SetLocation( VLerp( steppedLocation, nervorumKilledBy.Location, positionAlpha/2 )  );
		positionAlpha += TimeDelta;
		if( positionAlpha > 0.7 && !cameraFadeStarted)
		{
			cameraFadeStarted = true;
			pController = HPlayerController( GetALocalPlayerController() );
			pCamera = HCamera( pController.PlayerCamera );
			pCamera.FadeToBlack( 1 );
		}


		steppedRotation = Rotator( vectorToNervorum );
		SetViewRotation( RInterpTo(Rotation, Rotator(vectorToNervorum), 0.015, 20000, true));

		if( VSize( vectorToNervorum ) < 10.0f )
		{
			KillYourself();
			steppedOnNerve = false;
			cameraFadeStarted = false;
		}
	}
}

function KillByNervorum( HPawn_Nervorum nervorum )
{
	if( !steppedOnNerve )
	{
		steppedOnNerve = true;
		pullSpeed = 2.0f;
		steppedLocation = Location;
		steppedRotation = GetViewRotation();
		nervorumKilledBy = nervorum;
		waitTillPull = 0.5;
		positionAlpha = 0.0f;
		cameraFadeStarted = false;
	}


}

defaultproperties
{
	InventoryManagerClass = None
	HCharacterInfo = class'HideGame.HFamilyInfo_Player'

	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		HiddenGame=true
	End Object

	Components.Add(NPCMesh0);
	
	GroundSpeed=200.0
	CrouchHeight=40
	CrouchedPct=+0.65
	bStatic = false
	bNoDelete = false
	bCanDoubleJump=false
	RagdollLifespan = 0.1f;
	
	waitTillPull = 0.5;
	cameraFadeStarted = false;
}