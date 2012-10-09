class HPawn_Obesus extends HPawn_Monster
	placeable;

var HFamilyInfo_Obesus CharacterInfo;
var float timer;


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

function Tick(float DeltaTime)
{
	local SoundCue BreathSound;
	local HSoundGroup_Obesus HSoundGroup;

	HSoundGroup = HSoundGroup_Obesus(new SoundGroupClass);
	timer += DeltaTime;

	if(timer > 10)
	{
		BreathSound = HSoundGroup.static.getBreathingSound();
		
		if(BreathSound != None)
		{
			`Log("Play sound");
			PlaySound(BreathSound,false, true,,,true);
		}
		timer = 0;
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
	GroundSpeed=240;

}


