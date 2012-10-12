class HPawn_Turpis extends HPawn_Monster
	placeable;

var HFamilyInfo_Turpis CharacterInfo;

simulated function PostBeginPlay()
{
	SetPhysics(PHYS_Walking);
	if(ControllerClass == none)
	{
		//set the existing ControllerClass to our new NPCController class
		ControllerClass = class'HideGame.HAIController_Turpis';
	}

	HSetCharacterClassFromInfo(class'HFamilyInfo_Turpis');

	super.PostBeginPlay();
}

function PlayHissingSound()
{
	local SoundCue HSound;
	local HSoundGroup_Turpis SG;

	SG = HSoundGroup_Turpis(new SoundGroupClass);

	HSound = SG.GetHHissingSound();

	if(HSound != None)
	{
		PlaySound(HSound, false, true,,,true);
	}
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


