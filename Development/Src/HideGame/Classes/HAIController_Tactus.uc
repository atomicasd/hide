class HAIController_Tactus extends HAIController;

var float timer;

function Tick(float DeltaTime)
{
	timer += DeltaTime;
 
	if(timer > 12)
	{
		//HPawn_Tactus(Pawn).CreateBreathingSound();
		timer = 0;
	}
}

DefaultProperties
{
	timer = 12
	canSee = false;
	shouldFollowPath = true;
	canHear = false;

	WalkSpeed = 420
	ChaseSpeed = 420
}

