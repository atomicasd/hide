class HPawn_Tactus extends HPawn_Monster
	placeable;

// Character info
var HFamilyInfo_Tactus             CharacterInfo;

// Sound
var HSoundGroup_Obesus                 HSoundGroup;

var bool followingPlayer;

simulated function PostBeginPlay()
{
	SetPhysics(PHYS_Walking);
	if(ControllerClass == none)
	{
		//set the existing ControllerClass to our new NPCController class
		ControllerClass = class'HideGame.HAIController_Tactus';
	}
	
	// Setting PlayerInfo
	HSetCharacterClassFromInfo(class'HFamilyInfo_Tactus');

	// Sets soundgroup
	HSoundGroup = HSoundGroup_Obesus(new SoundGroupClass);

	super.PostBeginPlay();
}

function Tick( float DeltaTime )
{
	local HPawn_Player victim;

	foreach self.OverlappingActors(class'HPawn_Player', victim, 200)
	{
		HAIController( Controller ).FeelPlayer();
	}
	super.Tick( DeltaTime );
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
	ControllerClass = class'HideGame.HAIController_Tactus'
	HCharacterInfo = class'HideGame.HFamilyInfo_Tactus'
	
	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		SkeletalMesh=SkeletalMesh'MonsterPackage.ObesusRiggedQuick'
		HiddenGame=true
	End Object
	followingPlayer = false;
	NPCMesh=NPCMesh0
	Components.Add(NPCMesh0)

}


