class HNervorum_Tentacle extends Actor
	placeable;

// Mesh
var     SkeletalMeshComponent           Mesh;


var     bool        bAlreadyOwned;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
}

function SetTentacleLocation( Vector nervorumPos, Vector playerPos )
{
	local Vector halfPos;
	local Vector dScale;
	local float  distance;
	local float newscale;
	halfPos.X = (playerPos.X - nervorumPos.X) * 0.5;
	halfPos.Y = (playerPos.Y - nervorumPos.Y) * 0.5;
	halfPos.Z = (playerPos.Z - nervorumPos.Z) * 0.5;
	distance = VSize( playerPos - nervorumPos );
	//the value is the X value of the bounding box of the tentacle
	newscale = (distance/28.565821);
	
	SetLocation(nervorumPos);
	SetRotation(Rotator( playerPos - nervorumPos ) );
	dScale.X = newscale;
	dScale.Y = 3;
	dScale.Z = 3;
	SetDrawScale3D( dScale );
}

DefaultProperties
{
	Begin Object Class=SkeletalMeshComponent Name=Mesh01
		SkeletalMesh=SkeletalMesh'MonsterPackage.HG_Monsters_Nervorum_Tentacle001'
		BlockActors=true
		CollideActors=true
		Scale3D=(X=1,Y=1,Z=1)
	End Object
	bAlreadyOwned = false
	bCollideActors = true
	CollisionType=COLLIDE_TouchAll

	Mesh = Mesh01
	Components.add(Mesh01)
}
