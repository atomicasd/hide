class HPlayerInput extends UDKPlayerInput within HPlayerController;

var     bool    SneakActivated;
var     bool	RunActivated;

// Activate Sneak. This will override Run
exec function Sneak()
{
	Pawn.StartCrouch(Pawn.CrouchHeight);
	SneakActivated = true;
	bChangedState = true;
}

// Deactivate Sneak.
exec function SneakReleased()
{
	Pawn.EndCrouch(Pawn.CrouchHeight);
	SneakActivated = false;
	bChangedState=true;
}

// Activate Run.
exec function Run()
{
	RunActivated = true;
	bChangedState=true;
}

// Deactivate Run.
exec function RunReleased()
{
	RunActivated = false;
	bChangedState=true;
}

function Tick( float DeltaTime )
{
	if(bChangedState)
	{
		if(vsize(GetALocalPlayerController().Pawn.Velocity) != 0 || SneakActivated)
		{
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
			WalkState = Idle;
		}
	}
}

DefaultProperties
{
}
