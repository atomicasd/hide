class HVolume_EndOfLevel extends HVolume
placeable;

var(CollisionCylinder) CylinderComponent CollisionCylinder;

/*
 * If volume is touched. Load the new Level
 */
event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, Vector HitNomal)
{
	local HPawn_Player HP;
	local HPlayerController HPC;

	`Log("Touch");

	super.Touch(Other, OtherComp, HitLocation, HitNomal);

	HP=HPawn_Player(Other);
	HPC=HPlayerController(HP.Owner);

	if(HP != None)
	{
		if(HPC != None)
		{
			HPC.bInEndOfLevel = true;
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
			HPC.bInEndOfLevel = false;
		}
	}
}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=PickupMesh
		StaticMesh=StaticMesh'UN_SimpleMeshes.TexPropCube_Dup'
		Scale3D=(X=0.25,Y=0.25,Z=0.5)
	End Object

	Components.Add(PickupMesh)

	Begin Object Class=CylinderComponent Name=CollisionCylinder1
		CollisionRadius=64.0
		CollisionHeight=161.0
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		BlockActors=true
		CollideActors=true
	End Object
	
	CollisionCylinder = CollisionCylinder1;
	Components.Add(CollisionCylinder1);

	bNoEncroachCheck=false
	bStatic=false
	bHidden=false
	bCollideActors = true
	CollisionType=COLLIDE_TouchAll
}
