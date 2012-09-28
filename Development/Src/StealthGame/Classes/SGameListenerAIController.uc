class SGameListenerAIController extends AIController;

var SGameListenerPawn MyBadguy1;
var Pawn thePlayer;
var Actor theNoiseMaker;
var Vector noisePos;
var Pawn theBeacon;

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
var bool soundHeard;
var SoundSpot lastSoundSpot;

function NotifyOnSoundHeared(SoundSpot soundSpot)
{
	//if( !soundHeard )
	//{
		soundHeard = true;
		Worldinfo.Game.Broadcast(self, "I heard that");
		lastSoundSpot.Destroy();
		lastSoundSpot = soundSpot;
		//`Log("Sound Heard");
		GotoState('GoToLocation');
	//}
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

auto state Idle
{

Begin:
    Worldinfo.Game.Broadcast(self, "!!!!!!!  idle  !!!!!!!!");

	Pawn.Acceleration = vect(0,0,0);
	MyBadguy1.SetAttacking(false);

	//Sleep(IdleInterval);

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
	if( thePlayer.Health > 0 && CanSee(thePlayer) )
	{
		MoveToward(thePlayer, thePlayer, 0);
		//FindPat
	} else
	{
		GotoState('Idle');
	}
    goto 'Begin';
}

state GoToLocation 
{
Begin:

	while(soundHeard)
	{
		MoveTarget = FindPathToward( lastSoundSpot );
		//Next path node in the path
		if( Pawn.ReachedDestination( lastSoundSpot ) )
		{
			soundHeard = false;
			GotoState('Idle');
		}
		
		MoveTo( lastSoundSpot.Location );

		if( ActorReachable( MoveTarget ) )
		{
			MoveToward(MoveTarget, MoveTarget);	
		} 
		else
		{
			MoveTarget = FindPathToward( lastSoundSpot );
			if (MoveTarget != none)
			{
				MoveToward( MoveTarget, MoveTarget );	
			}
		}
		Sleep(1);
	}
}
state Chaseplayer
{
  Begin:
	
	MyBadguy1.SetAttacking(false);
    Pawn.Acceleration = vect(0,0,1);
	
    if (Pawn != none && thePlayer.Health > 0)
    {
		//Worldinfo.Game.Broadcast(self, "I can see you!!");
		
		if (ActorReachable(thePlayer))
		{
			distanceToPlayer = VSize(thePlayer.Location - Pawn.Location);
			if (distanceToPlayer < attackDistance)
			{
				GotoState('Attack');
			}
			else //if(distanceToPlayer < 300)
			{
				MoveToward(thePlayer, thePlayer, 20.0f);
				if(Pawn.ReachedDestination(thePlayer))
				{
					GotoState('Attack');
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
			}		
		}
    }
	goto 'Begin';
}

state Attack
{
 Begin:
	Pawn.Acceleration = vect(0,0,0);
	MyBadguy1.SetAttacking(true);
	Worldinfo.Game.Broadcast(self, "!!!!!!!  ATTACK  !!!!!!!!");
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


state FollowPath
{
/*	event SeePlayer(Pawn SeenPlayer)
	{
	    thePlayer = SeenPlayer;
        distanceToPlayer = VSize(thePlayer.Location - Pawn.Location);
		if (distanceToPlayer < perceptionDistance)
		{ 
        	Worldinfo.Game.Broadcast(self, "I can see you1");
			GotoState('Follow');
		}
    }*/

 Begin:

	while(followingPath)
	{
		MoveTarget = MyNavigationPoints[actual_node];
		
		if(Pawn.ReachedDestination(MoveTarget))
		{
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
		Sleep(1);
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

	soundHeard = false;

}