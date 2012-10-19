class HPawn_Obesus extends HPawn_Monster
	placeable;

var HFamilyInfo_Obesus                  CharacterInfo;
var class<HAudioComponent_IdleSounds>   HIS;
var HAudioComponent_IdleSounds          HIdleSound;
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

	HIdleSound = new HIS;
	HIdleSound.SoundCue = SoundCue'SoundPackage.obesus.obesusBreathing01_Cue';
	HIdleSound.addIdleSound(SoundCue'SoundPackage.obesus.obesusBreathing01_Cue');
	HIdleSound.addIdleSound(SoundCue'SoundPackage.obesus.obesusBreathing02_Cue');
	HIdleSound.addIdleSound(SoundCue'SoundPackage.obesus.obesusBreathing03_Cue');
	HIdleSound.addIdleSound(SoundCue'SoundPackage.obesus.obesusBreathing04_Cue');


	super.PostBeginPlay();
}

function CreateAttackSound()
{
	HIdleSound.Stop();
	HPlaySoundEffect(HSoundGroup.static.getAttackSounds());
}

function CreateBreathingSound()
{
	`Log("Yeah");
	HIdleSound.HPlay();
	//HPlaySoundEffect(HSoundGroup.static.getBreathingSound());
}

function CreateInvestigateSound()
{
	HIdleSound.Stop();
	HPlaySoundEffect(HSoundGroup.static.getInvestigateSounds());
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Obesus'
	HCharacterInfo = class'HideGame.HFamilyInfo_Obesus'
	HIS = class'HideGame.HAudioComponent_IdleSounds'
	
	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		SkeletalMesh=SkeletalMesh'MonsterPackage.ObesusRiggedQuick'
		HiddenGame=true
	End Object
	
	NPCMesh=NPCMesh0
	Components.Add(NPCMesh0)

}


