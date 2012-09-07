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
			MakeSoundPulse( 300 );

			nextSoundPulse = time + 1;
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
			`log("Crouching");
			MakeSoundPulse( 100 );

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

exec function CrouchPressed()
{
	`Log("Crouch");
	StartCrouch(AdjustHeight);
	GotoState('Crouching');
}

exec function CrouchReleased()
{
	`Log("Crouch");
	EndCrouch(AdjustHeight);
	GoToState('Walking');
}

defaultproperties
{
	AdjustHeight=15;
	HeightAdjust=AdjustHeight;
	nextSoundPulse = 0;
	time = 0;
}