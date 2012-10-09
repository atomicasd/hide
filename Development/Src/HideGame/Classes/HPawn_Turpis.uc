class HPawn_Turpis extends HPawn_Monster
	placeable;

var HFamilyInfo_Turpis CharacterInfo;

simulated function PostBeginPlay()
{

	SetPhysics(PHYS_Walking);
	if(ControllerClass == none)
	{
		//set the existing ControllerClass to our new NPCController class
		ControllerClass = class'HideGame.HAIController_Turpis';
	}

	SetCharacterClassFromInfo(class'HFamilyInfo_Turpis');
	CharacterInfo = HFamilyInfo_Turpis( new HCharacterInfo );
	SetCharacterClassInformation(CharacterInfo);

	super.PostBeginPlay();
	
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Turpis';
	HCharacterInfo = class'HideGame.HFamilyInfo_Turpis'
	
	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
		HiddenGame=true
	End Object

	NPCMesh=NPCMesh0
	Components.Add(NPCMesh0)

	GroundSpeed = 220;

}


