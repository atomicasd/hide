class HPawn_Turpis extends HPawn_Monster
	placeable;

// Information
var HFamilyInfo_Turpis CharacterInfo;

// Sound
var HSoundGroup_Turpis HSoundGroup;

simulated function PostBeginPlay()
{
	SetPhysics(PHYS_Walking);
	if(ControllerClass == none)
	{
		//set the existing ControllerClass to our new NPCController class
		ControllerClass = class'HideGame.HAIController_Turpis';
	}

	// Sets family info
	HSetCharacterClassFromInfo(class'HFamilyInfo_Turpis');

	// Sound
	HSoundGroup = HSoundGroup_Turpis(new SoundGroupClass);
	addIdleSound(SoundCue'SoundPackage.Enviroment.Silence_Cue');

	playIdleSound();

	super.PostBeginPlay();
}

/**
 * Sound
 */

// Play hissing sound
function PlayHissingSound()
{
	HPlaySoundEffect(HSoundGroup.GetHHissingSound());
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Turpis';
	HCharacterInfo = class'HideGame.HFamilyInfo_Turpis'
	SoundGroupClass = class'HideGame.HSoundGroup_Turpis'

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
		SkeletalMesh=SkeletalMesh'MonsterPackage.HG_Monsters_Turpis_SkeletalMesh02'
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

	DrawScale=13.0

	GroundSpeed = 200.0
}


