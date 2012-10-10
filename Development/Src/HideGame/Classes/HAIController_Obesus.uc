class HAIController_Obesus extends HAIController;

var float timer;
var bool CreateInvestigateSound;

function Tick(float DeltaTime)
{
	timer += DeltaTime;

	if(timer > 14)
	{
		HPawn_Obesus(Pawn).CreateBreathingSound();
		timer = 0;
	}

	if(CreateInvestigateSound)
	{
		if(playerSeen)
		{
			HPawn_Obesus(Pawn).CreateInvestigateSound();
			CreateInvestigateSound=false;
		}
	}else{
		if(!playerSeen)
		{
			HPawn_Obesus(Pawn).CreateInvestigateSound();
			CreateInvestigateSound=true;
		}
	}
	/*
	if(bChasePlayer)
	{
		HPawn_Obesus(Pawn).CreateAttackSound();
		bChasePlayer=false;
	}
	*/
}

DefaultProperties
{
	timer = 14
	CreateInvestigateSound=true;
	canSee = true;
	shouldFollowPath = true;
}

