class HPlayerInput extends UDKPlayerInput within HPlayerController;

var     bool    SneakActivated;
var     bool	RunActivated;

// Activate Sneak. This will override Run
exec function Sneak()
{
	//Pawn.StartCrouch(-Pawn.CrouchHeight);
	SneakActivated = true;
}

// Deactivate Sneak.
exec function SneakReleased()
{
	//Pawn.EndCrouch(-Pawn.CrouchHeight);
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

DefaultProperties
{
}
