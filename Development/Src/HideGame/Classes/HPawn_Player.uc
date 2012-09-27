class HPawn_Player extends UTPawn;

enum PlayerWalkingState
{
	Idle,
	Walk,
	Sneak,
	Run
};

var bool SneakActivated;
var bool RunActivated;
var PlayerWalkingState PlayerState;

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