class HNervorum_GroundNerve extends Actor
	placeable;

// Mesh
var     SkeletalMeshComponent           Mesh;

// Nerves
var     array<HNervorum_GroundNerve>    ChildNerves;  
var     HPawn_Nervorum nervorumOwnedBy;

// Get name for bones to easy find the Location
var     name        Point1;
var     name        Point2;

// Location for bot bones to trace between
var     Vector      Location1;
var     Vector      Location2;

var     bool        bAlreadyOwned;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	Point1 = Mesh.GetBoneName(0);
	Point2 = Mesh.GetBoneName(1);

	Location1 = Mesh.GetBoneLocation(Point1);
	Location2 = Mesh.GetBoneLocation(Point2);

	// Needed for trace to work.
	Location1.Z += 2;
	Location2.Z += 2;
}

/*
 * Finds the nerves that collides with this nerves and adds them to Child list
 * Drops all the nerves that allready has a parent
 */
function findChildNerves()
{
	local HNervorum_GroundNerve nerve;
	foreach OverlappingActors(class'HNervorum_GroundNerve', nerve, 30)
	{
		if(!nerve.bAlreadyOwned){
			`log("---->Adding childnerve<-----");
			nerve.bAlreadyOwned = true;
			nerve.nervorumOwnedBy = nervorumOwnedBy;
			nerve.findChildNerves();
			ChildNerves.AddItem(nerve);
		}
	}
}

/*
 * Checks if we have collided with any childnerves to this nerve.
 */
function bool ChildCollision()
{
	local int i;

	for(i = 0; i < ChildNerves.Length; i++)
	{
		if(ChildNerves[i].CheckCollision()){
			return true;
		}

		if(ChildNerves[i].ChildCollision()){
			return true;
		}
	}

	return false;
}

/*
 * Checks collision with the help of trace
 */
function bool CheckCollision()
{   
	local   HPawn_Player    HitActor;
	local   vector          HitLoc, HitNorm;
    local   TraceHitInfo    hitInfo;

	foreach TraceActors(class'HPawn_Player', HitActor, HitLoc, 
                        HitNorm, Location2, Location1, ,hitInfo)
	{
		
		return true;
	}

	return false;
}

DefaultProperties
{
	Begin Object Class=SkeletalMeshComponent Name=Mesh01
		SkeletalMesh=SkeletalMesh'MonsterPackage.NerveBox'
		BlockActors=true
		CollideActors=true
	End Object

	bAlreadyOwned = false
	bCollideActors = true
	CollisionType=COLLIDE_TouchAll

	Mesh = Mesh01
	Components.add(Mesh01)
}
