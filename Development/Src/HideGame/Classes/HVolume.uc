class HVolume extends Actor;

/*
 * Base class for Volume that checks when player has entered an area.
 */

defaultproperties
{
	bNoEncroachCheck=false
	bStatic=true
	bHidden=false
	bCollideActors = true
	CollisionType=COLLIDE_TouchAll
}
