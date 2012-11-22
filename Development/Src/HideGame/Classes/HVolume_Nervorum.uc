class HVolume_Nervorum extends HVolume;

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

}

/*
 * This will run when player moved out of the volume
 */
event UnTouch(Actor Other)
{

}

DefaultProperties
{
	Begin Object Class=CylinderComponent Name=Cylinder0
		HiddenEditor=false
		HiddenGame=false
		CollisionRadius=400
		CollisionHeight=100
		CollideActors=false
		bDrawBoundingBox=true
		bDrawNonColliding=true
	End Object
	bCollideActors = false
	HCylinder = Cylinder0

	bStatic=false
	bHidden=false
	bCollideActors = true

	Components.add(Cylinder0)
}
