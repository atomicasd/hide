class HPawn_Obesus extends HPawn_Monster
	placeable;

// Character info
var HFamilyInfo_Obesus      CharacterInfo;
     
// Sound
var HSoundGroup_Obesus      HSoundGroup;

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

	addIdleSound(SoundCue'SoundPackage.obesus.obesusBreathing01_Cue');
	addIdleSound(SoundCue'SoundPackage.obesus.obesusBreathing02_Cue');
	addIdleSound(SoundCue'SoundPackage.obesus.obesusBreathing03_Cue');
	addIdleSound(SoundCue'SoundPackage.obesus.obesusBreathing04_Cue');

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

simulated function PlayAttackSound()
{
	`log("Attack-uu!");
	HPlaySoundEffect(HSoundGroup.static.getAttackSounds());
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


