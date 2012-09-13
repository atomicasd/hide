class SGameLookerPawn extends UTPawn
	placeable;

var StealthGamePlayerController PC;

// members for the custom mesh
var SkeletalMesh defaultMesh;
//var MaterialInterface defaultMaterial0;
var AnimTree defaultAnimTree;
var array<AnimSet> defaultAnimSet;
var AnimNodeSequence defaultAnimSeq;
var PhysicsAsset defaultPhysicsAsset;

var SGameLookerAIController MyController;

var float Speed;

var SkeletalMeshComponent MyMesh;
var bool bplayed;
var Name AnimSetName;
var AnimNodeSequence MyAnimPlayControl;

var bool AttAcking;

var () array<NavigationPoint> MyNavigationPoints;

var(NPC) SkeletalMeshComponent NPCMesh;
var(NPC) class<AIController> NPCController;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	//if (Controller == none)
	//	SpawnDefaultController();
	SetPhysics(PHYS_Walking);
	if (MyController == none)
	{
		MyController = Spawn(class'StealthGame.SGameLookerAIController', self);
		MyController.SetPawn(self);		
	}


	
	PC = StealthGamePlayerController( GetALocalPlayerController() );
    //I am not using this
	//MyAnimPlayControl = AnimNodeSequence(MyMesh.Animations.FindAnimNode('AnimAttack'));
}

function SetAttacking(bool atacar)
{
	AttAcking = atacar;
}

function Tick(Float Delta)
{
	local StealthPawn victim;
	foreach self.OverlappingActors(class'StealthPawn', victim, 40)
	{
		victim.KillYourself();
	}
}

simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info)
{
	Mesh.SetSkeletalMesh(defaultMesh);
	//Mesh.SetMaterial(0,defaultMaterial0);
	Mesh.SetPhysicsAsset(defaultPhysicsAsset);
	Mesh.AnimSets=defaultAnimSet;
	Mesh.SetAnimTreeTemplate(defaultAnimTree);

}

DefaultProperties
{
    Begin Object Name=CollisionCylinder
        CollisionHeight=+44.000000
    End Object
 
	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		AnimtreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
	End Object
	NPCMesh=NPCMesh0
	Mesh=NPCMesh0
	Components.Add(NPCMesh0)
 
    ControllerClass=class'StealthGame.SGameListenerAIController';
   // InventoryManagerClass=class'Sandbox.SandboxInventoryManager'
    bJumpCapable=false
    bCanJump=false
 
    GroundSpeed=200.0
	PeripheralVision = 0.7
}