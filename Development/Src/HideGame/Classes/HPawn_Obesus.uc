class HPawn_Obesus extends HPawn_Monster;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	SetPhysics(PHYS_Walking);
	if (MyController == none)
	{
		MyController = Spawn(class'HideGame.HAIController_Obesus', self);
		MyController.SetPawn(self);		
	}

	PC = HPlayerController( GetALocalPlayerController() );
}

DefaultProperties
{
	ControllerClass = class'HAIController_Obesus';
}


