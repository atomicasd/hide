class StealthPawn extends UTPawn;

var StealthGamePlayerController PC;
var float nextSoundPulse;
var float time;

var StealthHUD stealthHud;

defaultproperties
{
	//set defaults for regeneration properties
	GroundSpeed = 350;
	nextSoundPulse = 0;
	time = 0;
}

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

	function Tick(float timeDelta)
	{
		local SGameListenerPawn foundPawn;
		foreach OverlappingActors(class'SGameListenerPawn', foundPawn, 500)
		{
			`log("Found bot");
		}
	}

	function EndState(name NextStateName)
{
	time += deltaTime;
	if( time > nextSoundPulse )
	{
		`Log("Making pulse");
		if( bIsWalking )
		{
			MakeSoundPulse( 200 );
		}
		if( bIsMoving )
		{
			MakeSoundPulse( 300 );
		}
		nextSoundPulse = time + 1;
	}
}

function MakeSoundPulse( float radius )
{
	stealthHud.makePulseCircle( radius );
}

	{
	}
}

state Running
{
	function BeginState(name PreviousStateName)
	{
		GroundSpeed = 400;
	}

	function EndState(name NextStateName)
	{
	}
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	PC = GetALocalPlayerController();
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
	//set defaults for regeneration properties
	GroundSpeed = 200;
}