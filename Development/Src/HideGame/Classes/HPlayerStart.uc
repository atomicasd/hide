class HPlayerStart extends PlayerStart;

var     Vector      defaultLocation;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	defaultLocation = Location;
}

DefaultProperties
{
	bStatic=false
	bBlocked=true
	bNoAutoConnect=true
	bDestinationOnly=true
}
