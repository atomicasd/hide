class StealthSoundBeacon extends Pawn
	placeable;

var SkeletalMeshComponent SoundBeacon;

DefaultProperties
{
	// Remove collisions, so we can spawn this inside another Actor
	bBlockActors=false
}
