class SGameListenerAIController extends AIController;

var SGameListenerPawn MyBadguy1;
var Pawn thePlayer;
var Actor theNoiseMaker;
var Vector noisePos;

var () array<NavigationPoint> MyNavigationPoints;
var NavigationPoint MyNextNavigationPoint;

var int actual_node;
var int last_node;

var float perceptionDistance;
var float hearingDistance;
var float attackDistance;
var int attackDamage;

var float distanceToPlayer;
var float distanceToTargetNodeNearPlayer;

var Name AnimSetName;

var bool AttAcking;
var bool followingPath;
var bool noiseHeard;
var Float IdleInterval;

function NotifyOnSoundHeared()
{
	GotoState('Follow');
	Worldinfo.Game.Broadcast(self, "Heard sound");
}

function SetPawn(SGameListenerPawn NewPawn)
{
    MyBadguy1 = NewPawn;
	Possess(MyBadguy1, false);
	MyNavigationPoints = MyBadguy1.MyNavigationPoints;
}

function Possess(Pawn aPawn, bool bVehicleTransition)
{
    if (aPawn.bDeleteMe)
	{
		`Warn(self @ GetHumanReadableName() @ "attempted to possess destroyed Pawn" @ aPawn);
		 ScriptTrace();
		 GotoState('Dead');
    }
	else
	{
		Super.Possess(aPawn, bVehicleTransition);
		Pawn.SetMovementPhysics();
		
		if (Pawn.Physics == PHYS_Walking)
		{
			Pawn.SetPhysics(PHYS_Falling);
	    }
    }
}

function Tick(Float Delta)
{
	//if(IsInState('Attack'))
	//{	

	//}
	
}

state Idle
{

    event SeePlayer(Pawn SeenPlayer)
	{
	    thePlayer = SeenPlayer;
        distanceToPlayer = VSize(thePlayer.Location - Pawn.Location);
        if (distanceToPlayer < perceptionDistance)
        { 
        	//Worldinfo.Game.Broadcast(self, "I can see you!!");
            GotoState('Follow');
        }
    }

Begin:
    Worldinfo.Game.Broadcast(self, "!!!!!!!  idle  !!!!!!!!");

	Pawn.Acceleration = vect(0,0,0);
	MyBadguy1.SetAttacking(false);

	Sleep(IdleInterval);

	Worldinfo.Game.Broadcast(self, "!!!!!!!  Going to FollowPath  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
	followingPath = true;
	actual_node = last_node;
	GotoState('FollowPath');

}

state Follow
{
Begin:
    thePlayer = GetALocalPlayerController().Pawn;
    //Target is an Actor variable defined in my custom AI Controller.
    //Of course, you would normally verify that the Pawn is not None before proceeding.
	if( thePlayer.Health > 0 )
	{
		MoveToward(thePlayer, thePlayer, 128);
	} else
	{
		GotoState('Idle');
	}
 
    goto 'Begin';
}

state Chaseplayer
{
  Begin:
	
	MyBadguy1.SetAttacking(false);
    Pawn.Acceleration = vect(0,0,1);
	
    while (Pawn != none && thePlayer.Health > 0)
    {
		Worldinfo.Game.Broadcast(self, "I can see you!!");
		
		if (ActorReachable(thePlayer))
		{
			distanceToPlayer = VSize(thePlayer.Location - Pawn.Location);
			if (distanceToPlayer < attackDistance)
			{
				GotoState('Attack');
				break;
			}
			else //if(distanceToPlayer < 300)
			{
				MoveToward(thePlayer, thePlayer, 20.0f);
				if(Pawn.ReachedDestination(thePlayer))
				{
					GotoState('Attack');
					break;
				}
			}
		}
		else
		{
			MoveTarget = FindPathToward(thePlayer,,perceptionDistance + (perceptionDistance/2));
			if (MoveTarget != none)
			{
				//Worldinfo.Game.Broadcast(self, "Moving toward Player");

				distanceToPlayer = VSize(MoveTarget.Location - Pawn.Location);
				if (distanceToPlayer < 100)
					MoveToward(MoveTarget, thePlayer, 20.0f);
				else
					MoveToward(MoveTarget, MoveTarget, 20.0f);	
		
				//MoveToward(MoveTarget, MoveTarget);
			}
			else
			{
				GotoState('Idle');
				break;
			}		
		}

		Sleep(1);
    }
}

state Attack
{
 Begin:
	Pawn.Acceleration = vect(0,0,0);
	MyBadguy1.SetAttacking(true);
	while(true && thePlayer.Health > 0)
	{   
		//Worldinfo.Game.Broadcast(self, "Attacking Player");

		distanceToPlayer = VSize(thePlayer.Location - Pawn.Location);
        if (distanceToPlayer > attackDistance * 2)
        { 
			MyBadguy1.SetAttacking(false);
            GotoState('Chaseplayer');
			break;
        }
		Sleep(1);
	}
	MyBadguy1.SetAttacking(false);
}


auto state FollowPath
{
	event SeePlayer(Pawn SeenPlayer)
	{
	    thePlayer = SeenPlayer;
        distanceToPlayer = VSize(thePlayer.Location - Pawn.Location);
        if (distanceToPlayer < perceptionDistance)
        { 
        	//Worldinfo.Game.Broadcast(self, "I can see you!!");
			noiseHeard = true;
			followingPath = false;
            GotoState('Chaseplayer');
        }
    }

 Begin:

	while(followingPath)
	{
		MoveTarget = MyNavigationPoints[actual_node];
		
		if(Pawn.ReachedDestination(MoveTarget))
		{
			//WorldInfo.Game.Broadcast(self, "Encontrei o node");
			actual_node++;
			
			if (actual_node >= MyNavigationPoints.Length)
			{
				actual_node = 0;
			}
			last_node = actual_node;
			
			MoveTarget = MyNavigationPoints[actual_node];
		}	

		if (ActorReachable(MoveTarget)) 
		{
			//distanceToPlayer = VSize(MoveTarget.Location - Pawn.Location);
			//if (distanceToPlayer < perceptionDistance / 3)
			//	MoveToward(MoveTarget, MyNavigationPoints[actual_node + 1]);	
			//else
				MoveToward(MoveTarget, MoveTarget);	
		}
		else
		{
			MoveTarget = FindPathToward(MyNavigationPoints[actual_node]);
			if (MoveTarget != none)
			{
				
				//SetRotation(RInterpTo(Rotation,Rotator(MoveTarget.Location),Delta,90000,true));
				
				MoveToward(MoveTarget, MoveTarget);
			}
		}

		Sleep(0.1);
	}
}

defaultproperties
{
    attackDistance = 50
    attackDamage = 10
    perceptionDistance = 2000

	AnimSetName ="ATTACK"
	actual_node = 0
	last_node = 0
	followingPath = true
	IdleInterval = 2.5f

}