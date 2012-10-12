class HVolume_Checkpoint extends HVolume
	placeable;

/*
 * This will move StartPoint to checkpoints location
 */
function Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, Vector HitNomal)
{
	local HPawn_Player HP;
	local HPlayerController HPC;
	local HPlayerStart PlayerStartActor;

	super.Touch(Other, OtherComp, HitLocation, HitNomal);

	HP=HPawn_Player(Other);
	HPC=HPlayerController(HP.Owner);
	
	if(HP != None)
	{
		if(HPC != None)
		{
			foreach WorldInfo.AllActors(class'HPlayerStart', PlayerStartActor)
			{
				`log("Checkpoint Location: "$Location);
				PlayerStartActor.SetLocation(Location);
				PlayerStartActor.SetRotation(Rotation);
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
			
		}
	}
}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=PickupMesh
		StaticMesh=StaticMesh'UN_SimpleMeshes.TexPropCube_Dup'
		Scale3D=(X=0.1,Y=1.4,Z=1.1)
		HiddenGame=true
	End Object

	Components.Add(PickupMesh)

	bNoEncroachCheck=false
	bStatic=false
	bHidden=false
	bCollideActors = true
	CollisionType=COLLIDE_TouchAll
}
