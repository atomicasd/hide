class StealthSoundBeacon extends Pawn
	placeable;

var()   float   CircleSize;
var()   float   MaxCircleSize;

var SkeletalMeshComponent SoundBeacon;

DefaultProperties
{
	// Remove collisions, so we can spawn this inside another Actor
	bBlockActors=false
	CircleSize=0
	MaxCircleSize=0
}
