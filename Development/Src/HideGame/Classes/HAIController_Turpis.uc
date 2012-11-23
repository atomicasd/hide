class HAIController_Turpis extends HAIController;

var bool SoundPlayed;

event Tick(float DeltaTime)
{
	if(soundHeard)
	{
		if(!SoundPlayed)
		{
			HPawn_Monster(Pawn).PlayAttackSound();
			`log("SOUND ATTACKU!");
			SoundPlayed=true;
		}
	}else{
		SoundPlayed=false;
	}
}
function SetWalkAnimSpeed()
{
	aiPawn.SetAnimRateScale( 1.3 );
}

function SetRunAnimSpeed()
{
	aiPawn.SetAnimRateScale( 5 );
}

function SetIdleAnimSpeed()
{
	aiPawn.SetAnimRateScale( 1 );
}

function SetInvestigateAnimSpeed()
{
	aiPawn.SetAnimRateScale( 1.3 );
}
DefaultProperties
{
	canSee = false;
	canHear = true;
	shouldFollowPath = true;

	WalkSpeed = 140
	ChaseSpeed = 330
}