class HVolume_HelpMessage extends HVolume
placeable;

var() int DisplayMessageId;
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
			HPC.hGame.hHud.SetHelpMessage( DisplayMessageId );
		}
	}
}

/*
 * This will run when player moved out of the volume
 */
event UnTouch(Actor Other)
{

}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=PickupMesh
		StaticMesh=StaticMesh'UN_SimpleMeshes.TexPropCube_Dup'
		Scale3D=(X=0.75,Y=0.1,Z=0.75)
		HiddenGame=true
	End Object

	DisplayMessageId = 0;
	Components.Add(PickupMesh)
}
