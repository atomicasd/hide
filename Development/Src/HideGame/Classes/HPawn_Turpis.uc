class HPawn_Turpis extends HPawn_Monster
	placeable;

simulated function PostBeginPlay()
{

	SetPhysics(PHYS_Walking);
	if(ControllerClass == none)
	{
		//set the existing ControllerClass to our new NPCController class
		ControllerClass = class'HideGame.HAIController_Turpis';
	}

	super.PostBeginPlay();
	
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Turpis';
}


