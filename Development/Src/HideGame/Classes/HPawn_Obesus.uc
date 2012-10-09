class HPawn_Obesus extends HPawn_Monster
	placeable;

var HInformation_Monster_Obesus CharacterInfo;

simulated function PostBeginPlay()
{
	SetPhysics(PHYS_Walking);
	if(ControllerClass == none)
	{
		//set the existing ControllerClass to our new NPCController class
		ControllerClass = class'HideGame.HAIController_Obesus';
	}
	
	// Setting PlayerInfo
	SetCharacterClassFromInfo(class'HFamilyInfo_Obesus');
	CharacterInfo = HInformation_Monster_Obesus(new HCharacterInfo);
	SetCharacterClassInformation(CharacterInfo);

	super.PostBeginPlay();
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Obesus'
	HCharacterInfo = class'HideGame.HInformation_Monster_Obesus'
	CurrCharClassInfo = class'HFamilyInfo_Obesus'
	
	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
		HiddenGame=true
	End Object
	
	NPCMesh=NPCMesh0
	Components.Add(NPCMesh0)
	GroundSpeed=240;

}


