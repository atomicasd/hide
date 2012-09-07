class StealthPawn extends UTPawn;

var PlayerController PC;
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

function Tick( float deltaTime )
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