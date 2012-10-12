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
function HSetCharacterClassFromInfo(class<HFamilyInfo_Character> HInfo)
{
	SetCharacterClassFromInfo(HInfo);
	`Log("---->    Character class info set    <----");

	if(HInfo != None)
	{
		Mesh.AnimSets = HInfo.default.HAnimSet;
		Mesh.SetAnimTreeTemplate(HInfo.default.HAnimTreeTemplate);
		`Log("---->  Animasion asstets finished    <----");
	}else{
		`Log("---->Pawns information class not set <----");
	}
}

DefaultProperties
{
	MaxMultiJump=0
	MultiJumpRemaining=0
	bCanCrouch=true
}
