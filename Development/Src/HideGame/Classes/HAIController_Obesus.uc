class HAIController_Obesus extends HAIController
	dependson(UTCharInfo);

Function PostBeginPlay()
{
	local UTPlayerReplicationInfo PRI;
	// copy visual properties
 	PRI = UTPlayerReplicationInfo(PlayerReplicationInfo);
 	if (PRI != None)
 	{
		//Get the chosen character class for this character
		PRI.CharClassInfo = class'HFamilyInfo_Obesus';
		//PRI.CharClassInfo = class'UTCharInfo'.static.FindFamilyInfo(BotInfo.FamilyID);
	}
}

Function Tick(float DeltaTime)
{
	//HPawn_Obesus(Pawn).PlayJumpingSound();
	//Pawn.PlaySound(GetFootstepSound(0, Pawn.GetMaterialBelowFeet()), false, true,,,false);
}

DefaultProperties
{
	canSee = true;
	shouldFollowPath = true;
}

