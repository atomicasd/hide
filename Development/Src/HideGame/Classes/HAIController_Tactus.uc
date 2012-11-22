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

DefaultProperties
{
	canSee = false;
	shouldFollowPath = true;
	canHear = false;

	WalkSpeed = 420
	ChaseSpeed = 420
}

