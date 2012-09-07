class StealthPawn extends UTPawn;

var StealthGamePlayerController PC;

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