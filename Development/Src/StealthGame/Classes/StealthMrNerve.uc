class StealthMrNerve extends Actor
	placeable;

var() int HandRadius;
var() float HandSpeed;
var() int handHeight;
var float Time;
var int speedCounter;
var StealthHUD myHUD;
var StealthGamePlayerController PC;
var array<StealthMrNerveHand> hands;

function PostBeginPlay()
{
	local Vector tempVector;

	super.PostBeginPlay();

	PC = StealthGamePlayerController(GetALocalPlayerController());
	myHUD = StealthHUD(PC.myHUD);

	tempVector.X = HandRadius;
	tempVector.Y = 0;
	tempVector.Z = handHeight;
	hands.AddItem(Spawn(class'StealthMrNerveHand',,, (Location + tempVector),,, false));
	tempVector.X = 0;
	tempVector.Y = HandRadius;
	hands.AddItem(Spawn(class'StealthMrNerveHand',,, (Location + tempVector),,, false));
	tempVector.X = -HandRadius;
	tempVector.Y = 0;
	hands.AddItem(Spawn(class'StealthMrNerveHand',,, (Location + tempVector),,, false));
	tempVector.X = 0;
	tempVector.Y = -HandRadius;
	hands.AddItem(Spawn(class'StealthMrNerveHand',,, (Location + tempVector),,, false));

	`Log("--------> Created mrNerve <--------");
}

event Tick(float DeltaTime)
{
	//local float speed;
	local StealthMrNerveHand target;
	local vector tempVector;
	local vector loc, norm;
	local StealthPawn traceHit;
	
	if(PC == None){
		PC = StealthGamePlayerController(GetALocalPlayerController());
		if(myHUD == None){
			myHUD = StealthHUD(PC.myHUD);
		}
	}

	Time += DeltaTime;

	tempVector.X = Location.X + Abs((Sin(Time) * HandRadius));
	tempVector.Y = Location.Y + Abs((Cos(Time) * HandRadius));
	tempVector.Z = Location.Z + handHeight;
	hands[0].SetLocation(tempVector);

	tempVector.X = Location.X - Abs((Cos(Time) * HandRadius));
	tempVector.Y = Location.Y + Abs((Sin(Time) * HandRadius));
	tempVector.Z = Location.Z + handHeight;
	hands[1].SetLocation(tempVector);
	
	tempVector.X = Location.X - Abs((Sin(Time) * HandRadius));
	tempVector.Y = Location.Y - Abs((Cos(Time) * HandRadius));
	tempVector.Z = Location.Z + handHeight;
	hands[2].SetLocation(tempVector);

	tempVector.X = Location.X + Abs((Cos(Time) * HandRadius));
	tempVector.Y = Location.Y - Abs((Sin(Time) * HandRadius));
	tempVector.Z = Location.Z + handHeight;
	hands[3].SetLocation(tempVector);

	foreach hands(target)
	{
		myHUD.Draw3DLineBetwenTargets(self, target);
		// Checks the line of sight between This PawnLocation and PC-Location. Returns the first collidable Pawn.
		foreach TraceActors(class'StealthPawn', traceHit, loc, norm, target.Location, Location)
		{
			traceHit.KillYourself();
		}
		
	}
	++speedCounter;
}

DefaultProperties
{
	Begin Object Class=SkeletalMeshComponent Name=MrNerve
		SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
	End Object

	Components.Add(MrNerve)

	handHeight=-50
	HandRadius=700
	HandSpeed=10
	speedCounter=0
	Time=0
}



