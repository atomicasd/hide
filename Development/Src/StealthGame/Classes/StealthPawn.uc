class StealthPawn extends UTPawn;

var StealthGamePlayerController PC;
var float nextSoundPulse;
var float time;
var float AdjustHeight;

var StealthHUD stealthHud;


function SetHudClass(StealthHUD hud)
{
	stealthHud = hud;
}

auto state Walking
{
	function BeginState(name PreviousStateName)
	{
		GroundSpeed = 200;
	}

	event Tick(float deltaTime)
	{
		time += deltaTime;
		if( time > nextSoundPulse )
		{
			MakeSoundPulse( 200 );

			nextSoundPulse = time + 0.50;
		}
	}

	function EndState(name NextStateName)
	{
	}
}

state Running
{
	function BeginState(name PreviousStateName)
	{
		GroundSpeed = 400;
	}

	event Tick(float deltaTime)
	{
		time += deltaTime;
		if( time > nextSoundPulse )
		{
			MakeSoundPulse( 300 );

			nextSoundPulse = time + 0.35;
		}
	}

	function EndState(name NextStateName)
	{
	}
}

state Crouching
{
	function BeginState(name PreviuosStateName)
	{
		GroundSpeed=100;
	}

	event Tick(float DeltaTime)
	{
		time += deltaTime;
		if( time > nextSoundPulse )
		{
			MakeSoundPulse( 100 );

			nextSoundPulse = time + 0.75;
		}
	}

	function EndState(name NextStateName)
	{
	}
}

state Idle
{
	function BeginState(name PreviousStateName)
	{
	}

	function EndState(name NextStateName)
	{
	}
}

function MakeSoundPulse( float radius )
{
	stealthHud.makePulseCircle( radius );
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	PC = StealthGamePlayerController(GetALocalPlayerController());
}

exec function KillYourself()
{
	Suicide();
}

exec function WalkPressed()
{
	GotoState('Running');
}

exec function WalkReleased()
{
	GotoState('Walking');
}

exec function CrouchPressed()
{
	StartCrouch(CrouchHeight);
	GotoState('Crouching');
}

exec function CrouchReleased()
{
	EndCrouch(CrouchHeight);
	GoToState('Walking');
}

defaultproperties
{
	GroundSpeed=200;
	nextSoundPulse = 0;
	time = 0;
}