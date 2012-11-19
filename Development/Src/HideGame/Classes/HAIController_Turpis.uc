class HAIController_Turpis extends HAIController;

var bool SoundPlayed;

event Tick(float DeltaTime)
{
	if(soundHeard)
	{
		if(!SoundPlayed)
		{
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