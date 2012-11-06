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

	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		SkeletalMesh = SkeletalMesh'MonsterPackage.HG_Monsters_Turpis_SkeletalMesh02'
		HiddenGame=true
	End Object
	
	NPCMesh=NPCMesh0
	Components.Add(NPCMesh0)

	GroundSpeed = 200.0
}


