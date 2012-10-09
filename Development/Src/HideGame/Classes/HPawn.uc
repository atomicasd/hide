class HPawn extends UTPawn;

var     class<HFamilyInfo_Character>  HCharacterInfo;
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
function PlayTeleportEffect(bool bOut, bool bSound){}
function DoDoubleJump( bool bUpdating ) {}

/*
 * Sets CharacterInfo for pawn
 */
simulated function SetCharacterClassInformation(HFamilyInfo_Character charInfo)
{
	if(charInfo != None)
	{
		`Log("---->Setting up character information<----");
		
		Mesh.AnimSets = charInfo.default.HAnimSet;
		`Log("---->"$Mesh.AnimSets[0]);
	    Mesh.SetSkeletalMesh(charInfo.default.HSkeletalMesh);
		`Log("---->"$Mesh.SkeletalMesh);
		Mesh.SetPhysicsAsset(charInfo.default.HPhysicsAsset);
		`Log("---->"$Mesh.PhysicsAsset);
		Mesh.SetAnimTreeTemplate(charInfo.default.HAnimTreeTemplate);
		`Log("---->"$Mesh.AnimTreeTemplate);

		`Log("---->Finished ----");
	}else{
		`Log("---->Pawn information class not set<----");
	}

}


DefaultProperties
{
	MaxMultiJump=0
	MultiJumpRemaining=0
	bCanCrouch=true
}
