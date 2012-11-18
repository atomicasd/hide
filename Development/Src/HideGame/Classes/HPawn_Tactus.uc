class HPawn_Tactus extends HPawn_Monster
	placeable;

// Character info
var HFamilyInfo_Tactus             CharacterInfo;

// Sound
//var HSoundGroup_Tactus             HSoundGroup;

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

	// Sets soundgroup
	HSoundGroup = HSoundGroup_Tactus(new SoundGroup);
	
	super.PostBeginPlay();
}

function Tick( float DeltaTime )
{
	local HPawn_Player victim;

	foreach self.OverlappingActors(class'HPawn_Player', victim, 200)
	{
		HAIController( Controller ).FeelPlayer();
	}
	
	if(!IdleSound.IsPlaying())
	{
		playIdleSound();
		bAttackSound=false;
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

function CreateInvestigateSound()
{
	HPlaySoundEffect(HSoundGroup.static.getInvestigateSounds());
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Tactus'
	HCharacterInfo = class'HideGame.HFamilyInfo_Tactus'
	SoundGroup = class'HSoundGroup_Tactus'
	
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
		RBDominanceGroup=0
		// Nice lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
	End Object
	Mesh=WPawnSkeletalMeshComponent0
	Components.Add(WPawnSkeletalMeshComponent0)

	DrawScale=1.5

	IdleSounds[0] = SoundCue'SoundPackage.tactus.tactusHeavyBreathing01_Cue';
	IdleSounds[1] = SoundCue'SoundPackage.tactus.tactusHeavyBreathing02_Cue';
	IdleSounds[2] = SoundCue'SoundPackage.tactus.tactusHeavyBreathing03_Cue';

	followingPlayer = false;

}