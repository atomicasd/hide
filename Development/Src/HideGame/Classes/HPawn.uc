class HPawn extends UTPawn;

var     HPlayerController   HPlayer;

simulated function PostBeginPlay()
{
	local HPlayerController HPC;

	super.PostBeginPlay();
	
	ForEach WorldInfo.AllControllers(class'HPlayerController', HPC)
	{
		HPlayer=HPC;
	}
}

/*
 * Sets CharacterInfo for spawn
 */
simulated function SetCharacterClassInformation(HInformation_Character charInfo)
{
	if(charInfo != None)
	{
		`Log("Setting up character information");
		Mesh.AnimSets = charInfo.default.HAnimSet;
		Mesh.SetSkeletalMesh(charInfo.default.HSkeletalMesh);
		Mesh.SetPhysicsAsset(charInfo.default.HPhysicsAsset);
		Mesh.SetAnimTreeTemplate(charInfo.default.HAnimTreeTemplate);
	}else{
		`Log("---->Pawn information class not set<----");
	}
}


DefaultProperties
{
}
