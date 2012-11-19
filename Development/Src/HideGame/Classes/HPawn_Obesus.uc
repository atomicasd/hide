class HPawn_Obesus extends HPawn_Monster
	placeable;

// Character info
var HFamilyInfo_Obesus      CharacterInfo;
     
// Sound
//var HSoundGroup_Obesus      HSoundGroup;

simulated function PostBeginPlay()
{
	SetPhysics(PHYS_Walking); 
	if(ControllerClass == none)
	{
		//set the existing ControllerClass to our new NPCController class
		ControllerClass = class'HideGame.HAIController_Obesus';
	}
	
	// Setting PlayerInfo
	HSetCharacterClassFromInfo(class'HFamilyInfo_Obesus');

	// Sets soundgroup
	HSoundGroup = HSoundGroup_Obesus(new SoundGroup);

	// Sound
	playIdleSound();

	super.PostBeginPlay();
}

/**
 * Sound functions
 */

function CreateInvestigateSound()
{
	HPlaySoundEffect(HSoundGroup.static.getInvestigateSounds());
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Obesus'
	HCharacterInfo = class'HideGame.HFamilyInfo_Obesus'
	SoundGroup = class'HSoundGroup_Obesus'

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
		SkeletalMesh=SkeletalMesh'MonsterPackage.HG_Monsters_Obesus_SkeletalMesh01'
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

	DrawScale=30.0

	IdleSounds[0] = SoundCue'SoundPackage.obesus.obesusBreathing01_Cue';
	IdleSounds[1] = SoundCue'SoundPackage.obesus.obesusBreathing02_Cue';
	IdleSounds[2] = SoundCue'SoundPackage.obesus.obesusBreathing03_Cue';
	IdleSounds[3] = SoundCue'SoundPackage.obesus.obesusBreathing04_Cue';
	
	/*
	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		SkeletalMesh=SkeletalMesh'MonsterPackage.HG_Monsters_Obesus_SkeletalMesh01'
		HiddenGame=true
	End Object
	*/

}


