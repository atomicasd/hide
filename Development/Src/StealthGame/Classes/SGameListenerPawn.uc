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

DefaultProperties
{
    Begin Object Name=CollisionCylinder
        CollisionHeight=+44.000000
    End Object
 
    Begin Object Class=SkeletalMeshComponent Name=SandboxPawnSkeletalMesh
        SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
        AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
        AnimTreeTemplate=AnimTree'SandboxContent.Animations.AT_CH_Human'
        HiddenGame=FALSE
        HiddenEditor=FALSE
    End Object
 
    Mesh=SandboxPawnSkeletalMesh
 
    Components.Add(SandboxPawnSkeletalMesh)
    ControllerClass=class'StealthGame.SGameListenerAIController';
   // InventoryManagerClass=class'Sandbox.SandboxInventoryManager'
    bJumpCapable=false
    bCanJump=false
 
    GroundSpeed=450.0
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



simulated event Tick(float DeltaTime)
{
	local UTPawn gv;

	super.Tick(DeltaTime);
	//MyController.Tick(DeltaTime);

	
	//foreach CollidingActors(class'UTPawn', gv, 200) 
	foreach VisibleCollidingActors(class'UTPawn', gv, 100)
	{
		if(AttAcking && gv != none)
		{
			if(gv.Name == 'MyPawn_0' && gv.Health > 0)
			{
				//Worldinfo.Game.Broadcast(self, "Colliding with player : " @ gv.Name);
				gv.Health -= 1;
				gv.IsInPain();
			}
		}
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