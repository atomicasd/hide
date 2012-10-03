class HPawn extends UTPawn;

var     HPlayerController   HPlayer;
var     class<HInformation_Character>   CharInfo;

simulated function PostBeginPlay()
{
	local HPlayerController HPC;

	super.PostBeginPlay();
	
	ForEach WorldInfo.AllControllers(class'HPlayerController', HPC)
	{
		HPlayer=HPC;
	}

	SetCharacterInformation(GetCharInfo());
}

/*
function PossesedBy(Controller C, bool bVehicleTransition)
{
	`log("<<<<<<<<<Setting up charinfo>>>>>>>>>");
	Super.PossessedBy(C, bVehicleTransition);
}
*/

/*
 * Returns the information to the pawn.
 */
simulated function class<HInformation_Character> GetCharInfo()
{
	local HPlayerController HPC;

	HPC = HPlayerController(Controller);

	if ( HPC != None )
	{
		return HPC.HPlayerInfo;
	}

	return CharInfo;
}

/*
 * Sets CharacterInfo for spawn
 */
simulated function SetCharacterInformation(class<HInformation_Character> HCharInfo)
{
	if(HCharInfo != CharInfo)
	{
		Mesh.AnimSets = HCharInfo.default.HAnimSet;
		Mesh.SetSkeletalMesh(HCharInfo.default.HSkeletalMesh);
		Mesh.SetPhysicsAsset(HCharInfo.default.HPhysicsAsset);
		Mesh.SetAnimTreeTemplate(HCharInfo.default.HAnimTreeTemplate);

		CharInfo = HCharInfo;
	}

	if(HPlayerController(Controller) != None)
	{
		HPlayerController(Controller).CreatePlayerInformation();
	}
}


DefaultProperties
{
}
