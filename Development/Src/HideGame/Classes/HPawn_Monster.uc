class HPawn_Monster extends HPawn;

// Default position
var     Vector                  startingPosition;
var     Rotator                 startingRotation;

// Controller
var     HAIController           MyController;
var     AnimNodeSequence        MyAnimPlayControl;

// Animation
var array<HAnimBlend_Monster>   HAnimBlend;

// Variables
var     bool                    AttAcking;
var     bool                    bplayed;
var     Name                    AnimSetName;

// AI
var()       array<NavigationPoint>  MyNavigationPoints;
var(NPC)    class<AIController>     NPCController;

// kismet variable
var ()  float       PawnGroundSpeed;
var ()  float       waitAtNode;

simulated function PostBeginPlay()
{
	startingPosition = Location;
	startingRotation = Rotation;
	super.PostBeginPlay();
}

function OnSoundHeard( HSoundSpot spot )
{
	HAIController(Controller).OnSoundHeard( spot );
}

function SetAttacking(bool atacar)
{
	AttAcking = atacar;
}

function Tick(Float Delta)
{
	local HPawn_Player victim;
	foreach self.OverlappingActors(class'HPawn_Player', victim, 40)
	{
		victim.KillYourself();
	}
}


// Resets the position of the monster and its default path
event Reset()
{
	MyController = HAIController(Controller);
	SetLocation(startingPosition);
	SetRotation(startingRotation);
	MyController.actual_node = 0;
	MyController.last_node = 0;
	MyController.GotoState('Idle');
	super.Reset();
}


/**
 * Animation
 */

// Initialize the animtree
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	local HAnimBlend_Monster BlendState;

	super.PostInitAnimTree(SkelComp);

	if(SkelComp == Mesh)
	{
		foreach mesh.AllAnimNodes(class'HAnimBlend_Monster', BlendState)
		{
			HAnimBlend[HAnimBlend.Length] = BlendState;
		}
	}
}

// Sets what animation we want to play
simulated event SetAnimState(MonsterState stateAnimType)
{
	local int i;

	for ( i = 0; i < HAnimBlend.Length; i++)
	{
		HAnimBlend[i].SetAnimState(stateAnimType);
	}
}

DefaultProperties
{
    Begin Object Name=CollisionCylinder
        CollisionHeight=+44.000000
    End Object
	
    bJumpCapable=false
    bCanJump=false
 
    GroundSpeed=200.0
	PeripheralVision = 0.7

	waitAtNode = 0.0f;

}