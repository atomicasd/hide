class SGameListenerPawn extends UTPawn
	placeable;

// members for the custom mesh
var SkeletalMesh defaultMesh;
//var MaterialInterface defaultMaterial0;
var AnimTree defaultAnimTree;
var array<AnimSet> defaultAnimSet;
var AnimNodeSequence defaultAnimSeq;
var PhysicsAsset defaultPhysicsAsset;

var SGameListenerAIController MyController;

var float Speed;

var SkeletalMeshComponent MyMesh;
var bool bplayed;
var Name AnimSetName;
var AnimNodeSequence MyAnimPlayControl;

var bool AttAcking;

var () array<NavigationPoint> MyNavigationPoints;

var(NPC) SkeletalMeshComponent NPCMesh;
var(NPC) class<AIController> NPCController;

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
	PeripheralVision = 0.9;
}

function NotifyOnSoundHeared()
{
	MyController.NotifyOnSoundHeared();
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	//if (Controller == none)
	//	SpawnDefaultController();
	SetPhysics(PHYS_Walking);
	if (MyController == none)
	{
		MyController = Spawn(class'StealthGame.SGameListenerAIController', self);
		MyController.SetPawn(self);		
	}

    //I am not using this
	//MyAnimPlayControl = AnimNodeSequence(MyMesh.Animations.FindAnimNode('AnimAttack'));
}

function SetAttacking(bool atacar)
{
	AttAcking = atacar;
}



/*simulated event Tick(float DeltaTime)
{
	local StealthPawn gv;

	super.Tick(DeltaTime);
	//MyController.Tick(DeltaTime);

	
	//foreach CollidingActors(class'UTPawn', gv, 200) 
	foreach VisibleCollidingActors(class'StealthPawn', gv, 100)
	{
		if(gv != none)
		{
			if(gv.Health > 0)
			{
				//Worldinfo.Game.Broadcast(self, "Colliding with player : " @ gv.Name);
				gv.Health -= 5;
				gv.IsInPain();
			}
		}
	}
}*/

simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info)
{
	Mesh.SetSkeletalMesh(defaultMesh);
	//Mesh.SetMaterial(0,defaultMaterial0);
	Mesh.SetPhysicsAsset(defaultPhysicsAsset);
	Mesh.AnimSets=defaultAnimSet;
	Mesh.SetAnimTreeTemplate(defaultAnimTree);

}