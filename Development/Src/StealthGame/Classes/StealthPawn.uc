class StealthPawn extends UTPawn;

var PlayerController PC;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	PC = GetALocalPlayerController();
}

/*
simulated event Suicide()
{
	super.Suicide();
	Dead();
}
*/

exec function KillYourself()
{
	Suicide();
}

exec function WalkPressed()
{
	GroundSpeed = 150;
}

exec function WalkReleased()
{
	GroundSpeed = 300;
}

function Dead()
{
	local vector Position;
	
	Position.X = PC.Location.X;
	Position.Y = PC.Location.Y;
	Position.Z = PC.Location.Z - 50;

	`Log("Spawning new DeadClone");
	
	Spawn(class'StealthDeadBodyClone',,,Position,,,false);
}


defaultproperties
{
	//set defaults for regeneration properties
	GroundSpeed = 350;
}