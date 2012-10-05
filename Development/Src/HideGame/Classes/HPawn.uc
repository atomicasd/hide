class HPawn extends UTPawn;

var     HPlayerController   HPlayer;
var(NPC)    SkeletalMeshComponent   NPCMesh;

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
 * Removing dodge by overriding.
 */
function bool Dodge(eDoubleClickDir DoubleClickMove){return false;}

/*
 * Sets CharacterInfo for spawn
 */
simulated function SetCharacterClassInformation(HInformation_Character charInfo)
{
	if(charInfo != None)
	{
		`Log("Setting up character information");
		NPCMesh.SetSkeletalMesh(None);
		Mesh.AnimSets = charInfo.default.HAnimSet;
		Mesh.SetSkeletalMesh(charInfo.default.HSkeletalMesh);
		Mesh.SetPhysicsAsset(charInfo.default.HPhysicsAsset);
		Mesh.SetAnimTreeTemplate(charInfo.default.HAnimTreeTemplate);
	}else{
		`Log("---->Pawn information class not set<----");
	}

}

function PlayTeleportEffect(bool bOut, bool bSound){}

DefaultProperties
{
	SpawnSound=None
	MaxMultiJump=0
	MultiJumpRemaining=0
	bCanCrouch=true
}
