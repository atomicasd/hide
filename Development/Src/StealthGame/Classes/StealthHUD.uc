class StealthHUD extends HUD;

var     StealthPawn                 PlayerPawn;
var     float                       circleSize;
var     float                       MaxCircleSize;
var     bool                        drawSoundBeaconCircle;
var     array<StealthSoundBeacon>   Beacons;

// This runs when the player press the "H" key
// This is added trough DefaultInput.ini
exec function makePulseCircle( float radius )
{
	local Vector derp;
	local StealthSoundBeacon SoundBeacon;

	PlayerPawn = StealthPawn(GetALocalPlayerController().Pawn);
	
	// This get the location of the player and add a new Pawn 
	// to the map with players set location.
	derp.X = PlayerPawn.Location.X;
	derp.Y = PlayerPawn.Location.Y;
	derp.Z = PlayerPawn.Location.Z;
	SoundBeacon = Spawn(class'StealthGame.StealthSoundBeacon',,,derp);
	SoundBeacon.MaxCircleSize = radius;
	Beacons.AddItem(SoundBeacon);
}

// Runs right before the game starts.
simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	
	// Sets the player pawn
	PlayerPawn = StealthPawn(GetALocalPlayerController().Pawn);
	PlayerPawn.SetHudClass( self );
}

event PostRender()
{
	local StealthSoundBeacon arrayItem;
	super.PostRender();
	
	// This will render the beacon
	foreach Beacons(arrayItem)
	{
		RenderThreeDeeCircle(arrayitem);
	}
}

// Renders a pulsing circle around the Targets Pawn
// This will also check if anything is inside this circle.
function RenderThreeDeeCircle(StealthSoundBeacon target)
{
	local Rotator Angle;
	local Vector Radius, Offsets[16];
	local Box ComponentsBoundingBox;
	local SGameListenerPawn victim;
	local int i;
	local SoundSpot soundSpot;
	local Vector soundSpotLocation;
	local bool firstSpawned;
	firstSpawned = false;

	target.CircleSize += 5;

	if (PlayerOwner == None)
	{
		return;
	}
	
	target.GetComponentsBoundingBox(ComponentsBoundingBox);
	
	Radius.X = target.CircleSize;
	
	i = 0;
	
	// This creates the cricle we want. 
	for (Angle.Yaw = 0; Angle.Yaw < 65536; Angle.Yaw += 4096)
	{
		// Calculate the offset
		Offsets[i] = target.Location + (Radius >> Angle) + Vect(0.f, 0.f, -15.f);
		i++;
	}
		
	// Draw The circle beacon
	for (i = 0; i < ArrayCount(Offsets); ++i)
	{
		if (i == ArrayCount(Offsets) - 1)
		{
			Draw3DLine(Offsets[i], Offsets[0], class'HUD'.default.RedColor);
		}
		else
		{
			Draw3DLine(Offsets[i], Offsets[i + 1], class'HUD'.default.RedColor);
		}
	}
	
	// Checks if the circle is hitting anything. 
	foreach target.OverlappingActors(class'SGameListenerPawn', victim, Radius.X)
	{
		if( !firstSpawned )
		{
			soundSpotLocation = target.Location;
			soundSpot = Spawn(class'StealthGame.SoundSpot',,,soundSpotLocation);
			firstSpawned = true;
		}
		victim.NotifyOnSoundHeared(soundSpot);
	}

	if(target.CircleSize >= target.MaxCircleSize)
	{
		beacons.RemoveItem(target);
		target.Destroy();
	}
}

defaultproperties
{
	MaxCircleSize=100;
	drawSoundBeaconCircle=false
}