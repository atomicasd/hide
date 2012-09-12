class StealthPawn extends UTPawn;

var StealthGamePlayerController PC;
var float nextSoundPulse;
var float time;
var float AdjustHeight;
var bool buttonPressed;

var StealthHUD stealthHud;


function SetHudClass(StealthHUD hud)
{
	stealthHud = hud;
}

auto state Idle
{
	function BeginState(name PreviousStateName)
	{
	}

	event Tick(float DeltaTime)
	{
		time += deltaTime;
		if( time > nextSoundPulse )
		{
			MakeSoundPulse( 250 );

			nextSoundPulse = time + 0.75;
		}

		if(!buttonPressed){
			if(vSize(Velocity) != 0){
				GoToState('Walking');
				`log("Walking");
			}
		}
	}


	function EndState(name NextStateName)
	{
	}
}

state Walking
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
			MakeSoundPulse( 400 );

			nextSoundPulse = time + 0.50;
		}

		if(vSize(Velocity) == 0){
			GotoState('idle');
			`log("IDLE");
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
			MakeSoundPulse( 750 );

			nextSoundPulse = time + 0.35;
		}
		
		if(vSize(Velocity) == 0){
			GotoState('idle');
			`log("IDLE");
		}

		if(!buttonPressed){
			if(vSize(Velocity) != 0){
				GoToState('Walking');
				`log("Walking");
			}
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
			MakeSoundPulse( 150 );

			nextSoundPulse = time + 0.75;
		}

		if(!buttonPressed){
			if(vSize(Velocity) != 0){
				GoToState('Walking');
				`log("Walking");
			}
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
	buttonPressed=true;
	GotoState('Running');
	`log("Running");
}

exec function WalkReleased()
{
	GotoState('Walking');
	buttonPressed=false;
}

exec function CrouchPressed()
{
	buttonPressed=true;
	StartCrouch(CrouchHeight);
	GotoState('Crouching');
	`log("Crouching");
}

exec function CrouchReleased()
{
	EndCrouch(CrouchHeight);
	buttonPressed=false;
}

defaultproperties
{
	GroundSpeed=200;
	nextSoundPulse = 0;
	time = 0;
	buttonPressed=false
}