class StealthPawn extends UTPawn;

var StealthGamePlayerController PC;
var float nextSoundPulse;
var float time;

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
			`Log("Making pulse");

			MakeSoundPulse( 200 );

			nextSoundPulse = time + 1;
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
			`Log("Making pulse");
			
			MakeSoundPulse( 300 );

			nextSoundPulse = time + 1;
		}
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

defaultproperties
{
	GroundSpeed = 350;
	nextSoundPulse = 0;
	time = 0;
	GroundSpeed = 200;
}