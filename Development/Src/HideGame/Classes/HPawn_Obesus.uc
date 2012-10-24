class HPawn_Obesus extends HPawn_Monster
	placeable;

// Character info
var HFamilyInfo_Obesus                  CharacterInfo;

// Sound
var HSoundGroup_Obesus                  HSoundGroup;

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

/**
 * Sound functions
 */
function CreateAttackSound()
{
	HPlaySoundEffect(HSoundGroup.static.getAttackSounds());
}

function CreateBreathingSound()
{
	HPlaySoundEffect(HSoundGroup.static.getBreathingSound());
}

function CreateInvestigateSound()
{
	HPlaySoundEffect(HSoundGroup.static.getInvestigateSounds());
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


