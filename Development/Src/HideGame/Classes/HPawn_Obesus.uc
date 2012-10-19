class HPawn_Obesus extends HPawn_Monster
	placeable;

var HFamilyInfo_Obesus          CharacterInfo;
var HAudioComponent_IdleSounds  HIdleSound;
var HSoundGroup_Obesus          HSoundGroup;

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
	HSoundGroup = HSoundGroup_Obesus(new SoundGroupClass);

	super.PostBeginPlay();
}

function CreateAttackSound()
{
	PlaySoundEffect(HSoundGroup.static.getAttackSounds());
}

function CreateBreathingSound()
{
	PlaySoundEffect(HSoundGroup.static.getBreathingSound());
}

function CreateInvestigateSound()
{
	PlaySoundEffect(HSoundGroup.static.getInvestigateSounds());
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Obesus'
	HCharacterInfo = class'HideGame.HFamilyInfo_Obesus'
	
	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		SkeletalMesh=SkeletalMesh'MonsterPackage.ObesusRiggedQuick'
		HiddenGame=true
	End Object
	
	NPCMesh=NPCMesh0
	Components.Add(NPCMesh0)

}


