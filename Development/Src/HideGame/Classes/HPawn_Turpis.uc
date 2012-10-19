class HPawn_Turpis extends HPawn_Monster
	placeable;

var HFamilyInfo_Turpis CharacterInfo;
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

	super.PostBeginPlay();
}

function PlayHissingSound()
{
	HPlaySoundEffect(HSoundGroup.GetHHissingSound());
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Turpis';
	HCharacterInfo = class'HideGame.HFamilyInfo_Turpis'
	
	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		SkeletalMesh=SkeletalMesh'MonsterPackage.TurpisRiggedQuick'
		HiddenGame=true
	End Object

	NPCMesh=NPCMesh0
	Components.Add(NPCMesh0)

	GroundSpeed = 200.0
}


