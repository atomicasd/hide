class HAIController_Tactus extends HAIController;

var bool SoundPlayed;

function Tick(float DeltaTime)
{
	if(bChasePlayer)
	{
		if(!SoundPlayed)
		{
			HPawn_Monster(Pawn).PlayAttackSound();
			SoundPlayed=true;
		}
	}else{
		SoundPlayed=false;
	}
}

function SetWalkAnimSpeed()
{
	aiPawn.SetAnimRateScale( 6 );
}

function SetRunAnimSpeed()
{
	aiPawn.SetAnimRateScale( 10 );
}

function SetIdleAnimSpeed()
{
	aiPawn.SetAnimRateScale( 1 );
}

function SetInvestigateAnimSpeed()
{
	aiPawn.SetAnimRateScale( 3 );
}
DefaultProperties
{
	canSee = false;
	shouldFollowPath = true;
	canHear = false;

	WalkSpeed = 420
	ChaseSpeed = 420
}

