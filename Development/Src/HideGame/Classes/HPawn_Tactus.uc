class HPawn_Tactus extends HPawn_Monster
	placeable;

// Character info
var HFamilyInfo_Tactus             CharacterInfo;

// Sound
var HSoundGroup_Obesus                 HSoundGroup;

var bool followingPlayer;

simulated function PostBeginPlay()
{
	SetPhysics(PHYS_Walking);
	if(ControllerClass == none)
	{
		//set the existing ControllerClass to our new NPCController class
		ControllerClass = class'HideGame.HAIController_Tactus';
	}
	
	// Setting PlayerInfo
	HSetCharacterClassFromInfo(class'HFamilyInfo_Tactus');
	addIdleSound(SoundCue'SoundPackage.tactus.tactusHeavyBreathing01_Cue');
	addIdleSound(SoundCue'SoundPackage.tactus.tactusHeavyBreathing02_Cue');
	addIdleSound(SoundCue'SoundPackage.tactus.tactusHeavyBreathing03_Cue');

	// Sets soundgroup
	HSoundGroup = HSoundGroup_Obesus(new SoundGroupClass);

	super.PostBeginPlay();
}

function Tick( float DeltaTime )
{
	local HPawn_Player victim;

	foreach self.OverlappingActors(class'HPawn_Player', victim, 200)
	{
		HAIController( Controller ).FeelPlayer();
	}
	super.Tick( DeltaTime );
}

/**
 * Sound functions
 */
function CreateAttackSound()
{
	HPlaySoundEffect(HSoundGroup.static.getAttackSounds());
}

/*
function CreateBreathingSound()
{
	HPlaySoundEffect(HSoundGroup.static.getBreathingSound());
}
*/

function CreateInvestigateSound()
{
	HPlaySoundEffect(HSoundGroup.static.getInvestigateSounds());
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Tactus'
	HCharacterInfo = class'HideGame.HFamilyInfo_Tactus'
	
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
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
		RBChannel=RBCC_Untitled3
		RBCollideWithChannels=(Untitled3=true)
		LightEnvironment=MyLightEnvironment
		bOverrideAttachmentOwnerVisibility=true
		bAcceptsDynamicDecals=FALSE
		SkeletalMesh=SkeletalMesh'MonsterPackage.HG_Monsters_Tactus_SkeletalMesh01'
		HiddenEditor=false
		bHasPhysicsAssetInstance=true
		TickGroup=TG_PreAsyncWork
		MinDistFactorForKinematicUpdate=0.2
		bChartDistanceFactor=true
		//bSkipAllUpdateWhenPhysicsAsleep=TRUE
		RBDominanceGroup=1
		// Nice lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
	End Object
	Mesh=WPawnSkeletalMeshComponent0
	Components.Add(WPawnSkeletalMeshComponent0)

	followingPlayer = false;

}


