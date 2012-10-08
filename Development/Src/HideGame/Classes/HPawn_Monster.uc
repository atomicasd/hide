class HPawn_Monster extends HPawn;

var     Vector                  startingPosition;
var     Rotator                 startingRotation;
var     HAIController           MyController;
var     AnimNodeSequence        MyAnimPlayControl;
var     class<HInformation_Monster>  HCharacterInfo;

var     bool                    AttAcking;
var     bool                    bplayed;
var     Name                    AnimSetName;

var()       array<NavigationPoint>  MyNavigationPoints;
var(NPC)    class<AIController>     NPCController;

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

event Reset()
{
	MyController = HAIController(Controller);
	`Log("Reseting monster");
	SetLocation(startingPosition);
	SetRotation(startingRotation);
	MyController.actual_node = 0;
	MyController.last_node = 0;
	MyController.GotoState('Idle');
	super.Reset();
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