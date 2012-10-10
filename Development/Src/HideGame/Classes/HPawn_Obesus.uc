class HPawn_Obesus extends HPawn_Monster
	placeable;

var HFamilyInfo_Obesus CharacterInfo;


simulated function PostBeginPlay()
{
	SetPhysics(PHYS_Walking);
	if(ControllerClass == none)
	{
		//set the existing ControllerClass to our new NPCController class
		ControllerClass = class'HideGame.HAIController_Obesus';
	}
	
	// Setting PlayerInfo
	SetCharacterClassFromInfo(class'HFamilyInfo_Obesus');
	CharacterInfo = HFamilyInfo_Obesus( new HCharacterInfo );
	SetCharacterClassInformation(CharacterInfo);

	super.PostBeginPlay();
}

function CreateAttackSound()
{
	local SoundCue AttackSound;
	local HSoundGroup_Obesus HSoundGroup;

	HSoundGroup = HSoundGroup_Obesus(new SoundGroupClass);
	AttackSound = HSoundGroup.static.getAttackSounds();
		
	if(AttackSound != None)
	{
		PlaySound(AttackSound,false, true,,,true);
	}
}

function CreateBreathingSound()
{
	local SoundCue BreathSound;
	local HSoundGroup_Obesus HSoundGroup;

	HSoundGroup = HSoundGroup_Obesus(new SoundGroupClass);
	BreathSound = HSoundGroup.static.getBreathingSound();
		
	if(BreathSound != None)
	{
		PlaySound(BreathSound,false, true,,,true);
	}
}

function CreateInvestigateSound()
{
	local SoundCue InvestigateSound;
	local HSoundGroup_Obesus HSoundGroup;

	HSoundGroup = HSoundGroup_Obesus(new SoundGroupClass);
	InvestigateSound = HSoundGroup.static.getInvestigateSounds();
		
	if(InvestigateSound != None)
	{
		`Log("Play sound");
		PlaySound(InvestigateSound,false, true,,,true);
	}
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Obesus'
	HCharacterInfo = class'HideGame.HFamilyInfo_Obesus'
	
	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
		HiddenGame=true
	End Object
	
	NPCMesh=NPCMesh0
	Components.Add(NPCMesh0)

}


