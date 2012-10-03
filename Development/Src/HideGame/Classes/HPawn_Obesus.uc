class HPawn_Obesus extends HPawn_Monster
	placeable;

simulated function PostBeginPlay()
{

	SetPhysics(PHYS_Walking);
	if(ControllerClass == none)
	{
		//set the existing ControllerClass to our new NPCController class
		ControllerClass = class'HideGame.HAIController_Obesus';
	}

	super.PostBeginPlay();
	PC = HPlayerController( GetALocalPlayerController() );
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Obesus';
}


