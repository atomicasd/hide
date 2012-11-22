class HPawn_Nervorum extends HPawn_Monster
	placeable;

// Nerves
var array<HNervorum_GroundNerve>    ChildNerves;
var bool                            bTraceNerves;   
var HVolume_Nervorum                vol;           

// Character info
var HFamilyInfo_Nervorum            CharacterInfo;

// Sound
var     bool                        bMakeAttackSound;
//var HSoundGroup_Nervorum            HSoundGroup;

var Rotator lastTouchedRotation;

simulated function PostBeginPlay()
{
	local HNervorum_GroundNerve nerve;

	super.PostBeginPlay();

	SetPhysics(PHYS_Walking); 
	if(ControllerClass == none)
	{
		//set the existing ControllerClass to our new NPCController class
		ControllerClass = class'HideGame.HAIController_Nervorum';
	}
	
	// Setting PlayerInfo
	HSetCharacterClassFromInfo(class'HFamilyInfo_Nervorum');

	// Sets soundgroup
	HSoundGroup = HSoundGroup_Nervorum(new SoundGroup);

	// Find the nerves on the ground
	foreach OverlappingActors(class'HNervorum_GroundNerve', nerve, 60)
	{
		ChildNerves.AddItem(nerve);
		nerve.bAlreadyOwned = true;
		nerve.nervorumOwnedBy = self;
		nerve.findChildNerves();
	}

	// Spawns a collision cylinder to check when player is close.
	// We do not want to trace when player is not close
	vol = Spawn(class'HVolume_Nervorum', self,, Location,,, true);
	vol.SetOwner(self);
}

/*
 * Updates the nerve on the ground and checks collision
 */
event Tick(float DeltaTime)
{
	local PlayerController PC;
	local HPawn_Player pPawn;
	local int i;
	PC = GetALocalPlayerController();
	pPawn = HPawn_Player( PC.Pawn );

	bTraceNerves = false;

	super.Tick(DeltaTime);

	if(bTraceNerves)
	{
		for(i = 0; i < ChildNerves.Length; i++)
		{
			if(ChildNerves[i].CheckCollision() || ChildNerves[i].ChildCollision())
			{
				if( pPawn != none && pPawn.Health > 0 ) 
				{
					pPawn.KillByNervorum( self );
					RotateTowardsPawn( pPawn );
				}
			}
		}
	}
	SetRotation( lastTouchedRotation);
}

function RotateTowardsPawn( Pawn thePawn )
{
	lastTouchedRotation = Rotator( thePawn.Location - Location );
}

function EncroachedBy( Actor other )
{

}

simulated function PlayAttackSound()
{
	HPlaySoundEffect(HSoundGroup.static.getAttackSounds());
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Nervorum'
	HCharacterInfo = class'HideGame.HFamilyInfo_Nervorum'
	SoundGroup = class'HSoundGroup_Nervorum'
	
	Components.Remove(WPawnSkeletalMeshComponent)

	Begin Object Class=SkeletalMeshComponent Name=WPawnSkeletalMeshComponent0
		bCacheAnimSequenceNodes=FALSE
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		bOwnerNoSee=true
		CastShadow=true
		BlockRigidBody=TRUE
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=TRUE
		bUpdateKinematicBonesFromAnimation=false
		bCastDynamicShadow=true
		RBChannel=RBCC_Untitled3
		RBCollideWithChannels=(Untitled3=true)
		LightEnvironment=MyLightEnvironment
		bOverrideAttachmentOwnerVisibility=true
		bAcceptsDynamicDecals=FALSE
		SkeletalMesh=SkeletalMesh'MonsterPackage.HG_Monsters_Nervorum_Skeletal001'
		HiddenEditor=false
		bHasPhysicsAssetInstance=false
		TickGroup=TG_PreAsyncWork
		MinDistFactorForKinematicUpdate=0.2
		bChartDistanceFactor=true
		//bSkipAllUpdateWhenPhysicsAsleep=TRUE
		RBDominanceGroup=0
		// Nice lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
	End Object
	Mesh=WPawnSkeletalMeshComponent0
	Components.Add(WPawnSkeletalMeshComponent0)

	DrawScale=10.0

	IdleSounds[0] = SoundCue'SoundPackage.nervorum.nervorumBreathing01_Cue';
	IdleSounds[1] = SoundCue'SoundPackage.nervorum.nervorumBreathing02_Cue';
	IdleSounds[2] = SoundCue'SoundPackage.nervorum.nervorumBreathing03_Cue';
	IdleSounds[3] = SoundCue'SoundPackage.nervorum.nervorumBreathing04_Cue';

	bTraceNerves=false
	bCanBeDamaged = false;

	killPlayerOnTouch = false;
	bMakeAttackSound = true;
}
