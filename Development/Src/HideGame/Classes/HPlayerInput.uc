class HPlayerInput extends UDKPlayerInput within HPlayerController;

var     bool    SneakActivated;
var     bool	RunActivated;

exec function QuitGame()
{
	ConsoleCommand( "quit" );
}

// Activate Sneak. This will override Run
exec function Sneak()
{
	bDuck=1;
	bDuck=1;
	SneakActivated = true;
}

// Deactivate Sneak.
exec function SneakReleased()
{
	bDuck=0;
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

/*
 * Sets Walkstate to player
 */
function Tick( float DeltaTime )
{
	if(HPawn_Player(Pawn) != None)
	{
		if(vsize(GetALocalPlayerController().Pawn.Velocity) != 0)
		{
			bChangedState=true;
			if(SneakActivated)
			{
				WalkState = Sneak;
			}
			else if(RunActivated)
			{
				WalkState = Run;
			}
			else
			{
				WalkState = Walk;
			}
		}else{
			bChangedState=true;
			WalkState = Idle;
		}
	}

}

DefaultProperties
{
}
