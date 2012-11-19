class HPawn_Turpis extends HPawn_Monster
	placeable;

// Information
var HFamilyInfo_Turpis CharacterInfo;

// Sound
//var HSoundGroup_Turpis HSoundGroup;

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
	HSoundGroup = HSoundGroup_Turpis(new SoundGroup);

	playIdleSound();

	super.PostBeginPlay();
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Turpis';
	HCharacterInfo = class'HideGame.HFamilyInfo_Turpis'
	SoundGroup = class'HSoundGroup_Turpis'

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
		RBDominanceGroup=0
		// Nice lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
	End Object
	Mesh=WPawnSkeletalMeshComponent0
	Components.Add(WPawnSkeletalMeshComponent0)

	IdleSounds[0] = SoundCue'SoundPackage.turpis.turpisBreathing01_Cue';
	IdleSounds[1] = SoundCue'SoundPackage.turpis.turpisBreathing02_Cue';
	IdleSounds[2] = SoundCue'SoundPackage.turpis.turpisBreathing03_Cue';

	DrawScale=13.0

	GroundSpeed = 200.0
}


