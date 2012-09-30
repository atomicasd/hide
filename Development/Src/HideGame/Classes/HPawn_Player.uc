class HPawn_Player extends UTPawn;

enum PlayerWalkingState
{
	Idle,
	Walk,
	Sneak,
	Run
};

var     class<HInformation_Character>  CharInfo;
var     bool                        SneakActivated;
var     bool                        RunActivated;
var     PlayerWalkingState          PlayerState;

function PossesedBy(Controller C, bool bVehicleTransition)
{
	Super.PossessedBy(C, bVehicleTransition);
	SetCharacterInformation(GetCharInfo());
}

simulated function class<HInformation_Character> GetCharInfo()
{
	local HPlayerController HPC;

	HPC = HPlayerController(Controller);

	if ( HPC != None )
	{
		return HPC.hPlayerInfo;
	}

	return CharInfo;
}

// Sets CharacterInfo for spawn
simulated function SetCharacterInformation(class<HInformation_Character> HCharInfo)
{
	`log("Setting up charinfo");
	if(HCharInfo != CharInfo)
	{
		Mesh.AnimSets = HCharInfo.default.HAnimSet;
		Mesh.SetSkeletalMesh(HCharInfo.default.HSkeletalMesh);
		Mesh.SetPhysicsAsset(HCharInfo.default.HPhysicsAsset);
		Mesh.SetAnimTreeTemplate(HCharInfo.default.HAnimTreeTemplate);

		CharInfo = HCharInfo;
	}

	if(HPlayerController(Controller) != None)
	{
		HPlayerController(Controller).CreatePlayerInformation();
	}
}

// Activate Sneak. This will override Run
exec function Sneak()
{
	SneakActivated = true;
}

// Deactivate Sneak.
exec function SneakReleased()
{
	SneakActivated = false;
}

// Activate Run.
exec function Run()
{
	RunActivated = true;
}

// Deactivate Run.
exec function RunReleased()
{
	RunActivated = false;
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	PlayerState = Idle;
}

function tick( float DeltaTime )
{
	if(vsize(Velocity) != 0)
	{
		if(SneakActivated)
		{
			PlayerState = Sneak;
		}
		else if(RunActivated)
		{
			PlayerState = Run;
		}
		else
		{
			PlayerState = Walk;
		}
	}else{
		PlayerState = Idle;
	}

	switch(PlayerState)
	{
	case Idle: 
		break;
	case Walk:
		GroundSpeed = 250;
		break;
	case Sneak:
		GroundSpeed = 150;
		break;
	case Run:
		GroundSpeed = 400;
		break;
	}
}

defaultproperties
{
	GroundSpeed=250;
	bStatic = false;
	bNoDelete = false;
}