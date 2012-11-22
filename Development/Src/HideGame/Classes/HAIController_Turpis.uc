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

DefaultProperties
{
	canSee = false;
	canHear = true;
	shouldFollowPath = true;

	WalkSpeed = 140
	ChaseSpeed = 330
}