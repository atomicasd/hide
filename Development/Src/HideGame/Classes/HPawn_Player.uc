class HPawn_Player extends HPawn
	placeable;

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
		if(HPlayerController(Controller).WalkState == Sneak){
			super.ActuallyPlayFootStepSound(0);
		}else
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
	local HPlayerController PC;
	PC = HPlayerController( GetALocalPlayerController() );
	Suicide();
	PC.DisablePulse();

}

/*
 * Spawnes the soundBeacon
 */
event Tick(float TimeDelta)
{
	local int soundRadius;
	local Vector vectorToNervorum;
	local HPlayerController pController;
	local HCamera pCamera;
	local HNervorum_GroundNerve nerve;

	switch(HPlayer.WalkState)   
	{
	case Idle:  soundRadius=140;  break;
	case Sneak: soundRadius=180;  break;
	case Walk:  soundRadius=400;  break;
	case Run:   soundRadius=500; break;
	}
	
	soundBeacon.SetLocation(Location);
	soundBeacon.Radius=soundRadius;
	
	foreach OverlappingActors(class'HNervorum_GroundNerve', nerve,200)
	{
		if(nerve.CheckCollision() )
		{
			nerve.nervorumOwnedBy.RotateTowardsPawn( self );
			KillByNervorum( nerve.nervorumOwnedBy );
		}
	}
	
	if( steppedOnNerve )


	{
		if( waitTillPull < 0.0 )
		{
			vectorToNervorum = nervorumKilledBy.Location - Location;
			//steppedLocation += normalizedVectorToNervorum * pullSpeed;
		} else
		{
			waitTillPull -= TimeDelta;
		}
		vectorToNervorum = nervorumKilledBy.Location - Location;

		SetLocation( VLerp( steppedLocation, nervorumKilledBy.Location, positionAlpha/3 )  );
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

	//ArmsMesh[0].SetRotation(Rotation);
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

	Components.Remove(WPawnSkeletalMeshComponent)

	/*
	Begin Object Class=UDKSkeletalMeshComponent Name=FirstPersonArms0
		SkeletalMesh=SkeletalMesh'MonsterPackage.HG_PLayerArms01'
		Translation=(Z=15)
		Scale=4
		PhysicsAsset=None
		DepthPriorityGroup=SDPG_Foreground
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=true
		bOnlyOwnerSee=false
		bOverrideAttachmentOwnerVisibility=true
		bAcceptsDynamicDecals=FALSE
		AbsoluteTranslation=false
		AbsoluteRotation=true
		AbsoluteScale=true
		bSyncActorLocationToRootRigidBody=false
		CastShadow=false
		TickGroup=TG_DuringASyncWork
	End Object
	//ArmsMesh[0]=FirstPersonArms0

	Begin Object Class=UDKSkeletalMeshComponent Name=FirstPersonArms20
		SkeletalMesh=SkeletalMesh'MonsterPackage.HG_PLayerArms01'
		PhysicsAsset=None
		DepthPriorityGroup=SDPG_Foreground
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=true
		bOnlyOwnerSee=false
		bOverrideAttachmentOwnerVisibility=true
		HiddenGame=false
		bAcceptsDynamicDecals=FALSE
		AbsoluteTranslation=false
		AbsoluteRotation=true
		AbsoluteScale=true
		bSyncActorLocationToRootRigidBody=false
		CastShadow=false
	End Object
	//ArmsMesh[1]=FirstPersonArms20

	//Components.add(FirstPersonArms0)
	//Components.add(FirstPersonArms20)
	*/

	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		HiddenGame=true
	End Object

	Components.Add(NPCMesh0);
	
	GroundSpeed=200.0
	CrouchHeight=40
	AirSpeed = 1;
	CrouchedPct=+0.65
	bStatic = false
	bNoDelete = false
	bCanDoubleJump=false
	RagdollLifespan = 0.1f;

	IdleSounds[0] = SoundCue'SoundPackage.Enviroment.Silence_Cue'
	
	waitTillPull = 0.5;
	cameraFadeStarted = false;
}