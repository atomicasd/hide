class HVolume_Nervorum extends HVolume
	placeable;

var(CylinderComponent)  CylinderComponent   HCylinder;

var                     HPawn_Nervorum      HOwner;

function PostBeginPlay()
{
	local HPawn_Nervorum HPN;

	super.PostBeginPlay();

	HPN=HPawn_Nervorum(Owner);
	HOwner = HPN;
}

/*
 * This will move StartPoint to checkpoints location
 */
function Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, Vector HitNomal)
{
	local HPawn_Player HP;
	local HPlayerController HPC;

	super.Touch(Other, OtherComp, HitLocation, HitNomal);

	HP=HPawn_Player(Other);
	HPC=HPlayerController(HP.Owner);

	if(HP != None)
	{
		if(HPC != None)
		{
			if(HOwner != None)
			{
				HOwner.bTraceNerves = true;
			}
		}
	}
}

/*
 * This will run when player moved out of the volume
 */
event UnTouch(Actor Other)
{
	local HPawn_Player HP;
	local HPlayerController HPC;

	super.UnTouch(Other);

	HP=HPawn_Player(Other);
	HPC=HPlayerController(HP.Owner);

	if(HP != None)
	{
		if(HPC != None)
		{
			if(HOwner != None)
			{
				HOwner.bTraceNerves = false;
			}
		}
	}
}

DefaultProperties
{
	Begin Object Class=CylinderComponent Name=Cylinder0
		HiddenEditor=false
		HiddenGame=false
		CollisionRadius=400
		CollisionHeight=100
		CollideActors=true
		bDrawBoundingBox=true
		bDrawNonColliding=true
	End Object

	HCylinder = Cylinder0

	bStatic=false
	bHidden=false
	bCollideActors = true
	CollisionType=COLLIDE_TouchAll

	Components.add(Cylinder0)
}
