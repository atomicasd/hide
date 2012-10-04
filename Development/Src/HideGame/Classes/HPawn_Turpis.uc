class HPawn_Turpis extends HPawn_Monster
	placeable;

var HInformation_Monster_Turpis CharacterInfo;

simulated function PostBeginPlay()
{

	SetPhysics(PHYS_Walking);
	if(ControllerClass == none)
	{
		//set the existing ControllerClass to our new NPCController class
		ControllerClass = class'HideGame.HAIController_Turpis';
	}

	CharacterInfo = HInformation_Monster_Turpis( new HCharacterInfo );
	SetCharacterClassInformation(CharacterInfo);

	super.PostBeginPlay();
	
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Turpis';
	HCharacterInfo = class'HideGame.HInformation_Monster_Turpis'
}


