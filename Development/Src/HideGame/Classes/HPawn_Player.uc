class HPawn_Player extends UTPawn;

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
}

function PossesedBy(Controller C, bool bVehicleTransition)
{
	`log("<<<<<<<<<Setting up charinfo>>>>>>>>>");
	Super.PossessedBy(C, bVehicleTransition);
	SetCharacterInformation(GetCharInfo());
}

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

// Sets CharacterInfo for spawn
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

/**
 * Event called from native code when Pawn stops crouching.
 * Called on non owned Pawns through bIsCrouched replication.
 * Network: ALL
 *
 * @param	HeightAdjust	height difference in unreal units between default collision height, and actual crouched cylinder height.
 */
simulated event EndCrouch(float HeightAdjust)
{
	OldZ += HeightAdjust;
	Super.EndCrouch(HeightAdjust);

	// offset mesh by height adjustment
	CrouchMeshZOffset = 0.0;
}

/**
 * Event called from native code when Pawn starts crouching.
 * Called on non owned Pawns through bIsCrouched replication.
 * Network: ALL
 *
 * @param	HeightAdjust	height difference in unreal units between default collision height, and actual crouched cylinder height.
 */
simulated event StartCrouch(float HeightAdjust)
{
	OldZ -= HeightAdjust;
	Super.StartCrouch(HeightAdjust);

	// offset mesh by height adjustment
	CrouchMeshZOffset = HeightAdjust;
}

event Tick(float TimeDelta)
{
}

defaultproperties
{
	InventoryManagerClass = class'HideGame.HInventoryManager'
	
	//bCanCrouch=true
	bStatic = false
	bNoDelete = false
}