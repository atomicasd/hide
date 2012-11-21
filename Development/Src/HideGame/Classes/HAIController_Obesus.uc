class HAIController_Obesus extends HAIController;

var float timer;
var bool CreateInvestigateSound;

function Tick(float DeltaTime)
{
	timer += DeltaTime;

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

function SetWalkAnimSpeed()
{
	aiPawn.SetAnimRateScale( 5 );
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
	timer = 12
	CreateInvestigateSound=true;
	canSee = true;
	shouldFollowPath = true;

	WalkSpeed = 200
	ChaseSpeed = 330
}

