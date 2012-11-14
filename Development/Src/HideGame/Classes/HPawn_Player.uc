class HPawn_Player extends HPawn
	placeable;

var     SkeletalMeshComponent   PlayerArms;
var    array<MaterialInterface> ArmMaterials;
var     HFamilyInfo_Player      CharacterInfo;
var     HSoundBeacon            soundBeacon;
var     int                     waitSoundStep;
var     float                   waitForJump;
var     bool                    canJump;

var     bool                    steppedOnNerve;
var     Vector                  steppedLocation;
var     Rotator                 steppedRotation;
var     HPawn_Nervorum          nervorumKilledBy;
var     float                   pullSpeed;
var     float                   waitTillPull;
var     float                   positionAlpha;
var     bool                    cameraFadeStarted;

var array<HAnimBlend_PlayerHand> HAnimBlend;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	// Sets the FamilyInfo
	HSetCharacterClassFromInfo(class'HFamilyInfo_Player');

	// Creates players SoundBeacon
	soundBeacon = Spawn(class'HSoundBeacon',,, Location,,, true);
	soundBeacon.bIsPlayerSpawned=true;

	SetAnimState(HS_IDLE);
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
	HPlayer.playerDied();
	return super.Died(Killer, damageType, HitLocation);
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
	local HCamera pCamera;

	pCamera = HCamera( HPlayerController( GetALocalPlayerController() ).PlayerCamera);
	pCamera.FadeToNormal( 0.5 );
	soundBeacon.bIsPlayerDead=false;

	setHandMaterial(HPlayerController(Controller).HPlayerLifes);
	SetAnimState(HS_IDLE);
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

	if(!canJump)
	{
		waitForJump += TimeDelta;

		if(waitForJump >= 0.2)
		{
			HPlayer.bCanJump=true;
		}
	}

	PlayerArms.SetRotation(Rotation);
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

event Landed(vector HitNormal, actor FloorActor)
{
	super.Landed(HitNormal, FloorActor);
	HPlayer.bCanJump=false;
	waitForJump=0;
	Velocity.X *= 0.1;
	Velocity.Y *= 0.1;
}


/*************************
 * Animation
 *************************/


/*
 * Sets CharacterInfo for pawn
 */
function HSetCharacterClassFromInfo(class<HFamilyInfo_Character> HInfo)
{
	super.HSetCharacterClassFromInfo(HInfo);

	if(HInfo != None)
	{
		PlayerArms.AnimSets = HInfo.default.HAnimSet;
		PlayerArms.SetAnimTreeTemplate(HInfo.default.HAnimTreeTemplate);
		
	}else{
		`Log("---->Player information class not set <----");
	}

	PostInitAnimTree(PlayerArms);
}

// Initialize the animtree
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	local HAnimBlend_PlayerHand BlendState;

	//super.PostInitAnimTree(SkelComp);

	if(SkelComp == PlayerArms)
	{
		foreach PlayerArms.AllAnimNodes(class'HAnimBlend_PlayerHand', BlendState)
		{
			`Log("---------------->Derp<---------------------");
			HAnimBlend[HAnimBlend.Length] = BlendState;
		}
	}
}

// Sets what animation we want to play
simulated event SetAnimState(HandState stateAnimType)
{
	local int i;

	for ( i = 0; i < HAnimBlend.Length; i++)
	{
		HAnimBlend[i].SetAnimState(stateAnimType);
	}
}

function setHandMaterial(int LifeLeft)
{
	`Log("----------------------------------->HandMeterial: " $LifeLeft);
    PlayerArms.SetMaterial(0, ArmMaterials[LifeLeft]);
}

defaultproperties
{
	InventoryManagerClass = None
	HCharacterInfo = class'HideGame.HFamilyInfo_Player'

	Components.Remove(WPawnSkeletalMeshComponent)

	Begin Object Class=UDKSkeletalMeshComponent Name=FirstPersonArms0
		SkeletalMesh=SkeletalMesh'PlayerPackage.HG_PLayerArms01'
		bHasPhysicsAssetInstance=false
		LightEnvironment=MyLightEnvironment
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
		bAcceptsLights=true
		bAcceptsDynamicLights=true
		Translation=(Z=15)
		Scale=1
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
		bSyncActorLocationToRootRigidBody=true
		CastShadow=true
		TickGroup=TG_DuringASyncWork
	End Object
	PlayerArms=FirstPersonArms0
	Components.add(FirstPersonArms0)
	
	GroundSpeed=200.0
	CrouchHeight=40
	AirSpeed = 1;
	CrouchedPct=+0.65
	bStatic = false
	bNoDelete = false
	bCanDoubleJump=false
	RagdollLifespan = 0.1f;

	IdleSounds[0] = SoundCue'SoundPackage.Enviroment.Silence_Cue'

	ArmMaterials[0] = Material'PlayerPackage.Materials.HandMaterial01'
	ArmMaterials[1] = Material'PlayerPackage.Materials.HandMaterial01'
	ArmMaterials[2] = Material'PlayerPackage.Materials.HandMaterial02'
	ArmMaterials[3] = Material'PlayerPackage.Materials.HandMaterial03'
	ArmMaterials[4] = Material'PlayerPackage.Materials.HandMaterial04'
	ArmMaterials[5] = Material'PlayerPackage.Materials.HandMaterial05'
	ArmMaterials[6] = Material'PlayerPackage.Materials.HandMaterial06'
	ArmMaterials[7] = Material'PlayerPackage.Materials.HandMaterial07'
	ArmMaterials[8] = Material'PlayerPackage.Materials.HandMaterial08'
	ArmMaterials[9] = Material'PlayerPackage.Materials.HandMaterial09'
	ArmMaterials[10] = Material'PlayerPackage.Materials.HandMaterial010'
	
	waitTillPull = 0.5;
	cameraFadeStarted = false;
}