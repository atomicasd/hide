class HAIController extends AIController;

var HPawn_Monster   aiPawn; //The pawn we're controlling
var Pawn            playerPawn; //The player pawn

var () array<NavigationPoint> MyNavigationPoints;

var     int         actual_node;
var     int         last_node;

var ()  float       waitAtNode;
var     float       waitCounter;

var float           perceptionDistance;

var float           distanceToPlayer;
var float           distanceToTargetNodeNearPlayer;

var Name AnimSetName;

var bool Attacking;
var float attackDistance;
var bool followingPath;
var Float IdleInterval;

//Sound
var bool soundHeard;
var bool canHear;
var bool canSee;
var bool shouldFollowPath;

var HSoundSpot lastSoundSpot;
var HLastSeenSpot lastPlayerSpot; //
var bool playerSeen;
var float investigateMaxDistance;
var float chaseMaxDistance;

function OnSoundHeard( HSoundSpot spot )
{
	soundHeard = true;
	if(lastSoundSpot != none)
	{
		lastSoundSpot.Destroy();
	}
	lastSoundSpot = spot;
	if( canHear )
		GotoState('GoToSoundSpot');
}

function SetAttacking(bool isAttacking)
{
	AttAcking = isAttacking;
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

		aiPawn = HPawn_Monster(Pawn);
		MyNavigationPoints = aiPawn.MyNavigationPoints;
		waitAtNode = aiPawn.waitAtNode;
		Pawn.SetMovementPhysics();

		if (Pawn.Physics == PHYS_Walking)
		{
			Pawn.SetPhysics(PHYS_Falling);
	    }
    }
}

auto state Idle
{
	event SeePlayer(Pawn SeenPlayer)
	{
		if( canSee )
		{
			playerPawn = SeenPlayer;
			distanceToPlayer = VSize(playerPawn.Location - Pawn.Location);
			if (distanceToPlayer < chaseMaxDistance)
			{ 
				`log("Chasing player");
				GotoState('ChasePlayer');
			} else if (distanceToPlayer < investigateMaxDistance)
			{
				if( lastPlayerSpot != none )
				{
					lastPlayerSpot.Destroy();
				}
				lastPlayerSpot = Spawn(class'HLastSeenSpot',,, playerPawn.Location,,, true);
				`log("Investigating spot");
				GotoState('GoToLastSeenPlayer');

			}
		}
    }
Begin:
	Pawn.Acceleration = vect(0,0,0);
	aiPawn.SetAttacking(false);

	if(shouldFollowPath)
	{
		//Worldinfo.Game.Broadcast(self, "!!!!!!!  Going to FollowPath  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		followingPath = true;
		actual_node = last_node;
		GotoState('FollowPath');
	} else 
	{
		Sleep(1);
		goto 'Begin';
	}
}

state FollowPath
{
	event SeePlayer(Pawn SeenPlayer)
	{
		if( canSee )
		{
			playerPawn = SeenPlayer;
			distanceToPlayer = VSize(playerPawn.Location - Pawn.Location);
			if (distanceToPlayer < chaseMaxDistance)
			{ 
				`log("Chasing player");
				GotoState('ChasePlayer');
			} else if (distanceToPlayer < investigateMaxDistance)
			{
				if( lastPlayerSpot != none )
				{
					lastPlayerSpot.Destroy();
				}
				lastPlayerSpot = Spawn(class'HLastSeenSpot',,, playerPawn.Location,,, true);
				`log("Investigating spot");
				GotoState('GoToLastSeenPlayer');

			}
		}
    }

 Begin:

	while(followingPath)
	{
		if(MyNavigationPoints.Length <= 0)
		{
			followingPath = false;
			GotoState('Idle');
		}
		MoveTarget = MyNavigationPoints[actual_node];

		if(Pawn.ReachedDestination(MoveTarget))
		{
			if(waitCounter >= waitAtNode)
			{
				actual_node++;

				if (actual_node >= MyNavigationPoints.Length)
				{
					actual_node = 0;
				}
				last_node = actual_node;

				MoveTarget = MyNavigationPoints[actual_node];

				waitCounter = 0.0f;
			} else 
			{
				waitCounter += 0.1f;
			}
		}	

		if (ActorReachable(MoveTarget)) 
		{
				MoveToward(MoveTarget, MoveTarget);	
		}
		else
		{
			MoveTarget = FindPathToward(MyNavigationPoints[actual_node]);
			if (MoveTarget != none)
			{

				//SetRotation(RInterpTo(Rotation,Rotator(MoveTarget.Location),1,90000,true));

				MoveToward(MoveTarget, MoveTarget);
			}
		}
		Sleep(0.1);
	}
}

state Chaseplayer
{
  Begin:

	aiPawn.SetAttacking(false);
    Pawn.Acceleration = vect(0,0,1);

    if (Pawn != none && playerPawn.Health > 0)
    {
		//If we can directly reach the player
		if ( ActorReachable(playerPawn) )
		{
			distanceToPlayer = VSize(playerPawn.Location - Pawn.Location);
			if (distanceToPlayer < attackDistance)
			{
				//GotoState('Attack');
			}
			else //if(distanceToPlayer < 300)
			{
				MoveToward(playerPawn, playerPawn, 10.0f);
				if(Pawn.ReachedDestination(playerPawn))
				{
					//GotoState('Attack');
				}
			}
		}
		else
		{
			//Find path to player
			MoveTarget = FindPathToward(playerPawn,,perceptionDistance + (perceptionDistance/2));
			if (MoveTarget != none)
			{
				//Worldinfo.Game.Broadcast(self, "Moving toward Player");

				distanceToPlayer = VSize(MoveTarget.Location - Pawn.Location);
				if (distanceToPlayer < 100)
					MoveToward(MoveTarget, playerPawn, 10.0f);
				else
					MoveToward(MoveTarget, MoveTarget, 10.0f);	

				//MoveToward(MoveTarget, MoveTarget);
			}
			else
			{
				GotoState('Idle');
			}
		}
    } else
    {
		GotoState('Idle');
    }
	goto 'Begin';
}

state GoToSoundSpot
{
Begin:

	while(soundHeard)
	{
		MoveTarget = FindPathToward( lastSoundSpot );
		//Next path node in the path
		if( Pawn.ReachedDestination( lastSoundSpot ) )
		{
			soundHeard = false;
			Sleep(8);
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
		Sleep(0.1);
	}
}

state GoToLastSeenPlayer
{
	event SeePlayer(Pawn SeenPlayer)
	{
		if( canSee )
		{
			playerPawn = SeenPlayer;
			distanceToPlayer = VSize(playerPawn.Location - Pawn.Location);
			if (distanceToPlayer < chaseMaxDistance)
			{ 
				`log("Chasing player");
				GotoState('ChasePlayer');
			} else if (distanceToPlayer < investigateMaxDistance)
			{
				if( lastPlayerSpot != none )
				{
					lastPlayerSpot.Destroy();
				}
				lastPlayerSpot = Spawn(class'HLastSeenSpot',,, playerPawn.Location,,, true);
				`log("Investigating spot");
				GotoState('GoToLastSeenPlayer');
			}
		}
    }
Begin:
	playerSeen = true;
	while(playerSeen)
	{
		MoveTarget = FindPathToward( lastPlayerSpot );
		//Next path node in the path
		if( Pawn.ReachedDestination( lastPlayerSpot ) )
		{
			playerSeen = false;
			Sleep(8);
			GotoState('Idle');
		}

		MoveTo( lastPlayerSpot.Location );

		if( ActorReachable( MoveTarget ) )
		{
			MoveToward(MoveTarget, MoveTarget);	
		} 
		else
		{
			MoveTarget = FindPathToward( lastPlayerSpot );
			if (MoveTarget != none)
			{
				MoveToward( MoveTarget, MoveTarget );	
			}
		}
		Sleep(1);
	}
};

defaultproperties
{
    attackDistance = 50
    investigateMaxDistance = 1300
	chaseMaxDistance = 900;
	
	AnimSetName ="ATTACK"
	actual_node = 0
	last_node = 0
	followingPath = true
	IdleInterval = 2.5f

	waitAtNode = 0.0f;

	soundHeard = false;

	canHear = false;
	canSee = false;
	shouldFollowPath = false;
	playerSeen = false;
}