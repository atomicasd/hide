class StealthHUD extends HUD;

var StealthPawn PlayerPawn;
var StealthSoundBeacon SoundBeacon;
var float circleSize;
var float MaxCircleSize;
var bool drawSoundBeaconCircle;
var array<Pawn> pawns;

// This runs when the player press the "H" key
// This is added trough DefaultInput.ini
exec function makePulseCircle()
{
	local Vector derp;

	PlayerPawn = StealthPawn(GetALocalPlayerController().Pawn);

	drawSoundBeaconCircle=true;
	
	// This get the location of the player and add a new Pawn 
	// to the map with players set location.
	derp.X = PlayerPawn.Location.X;
	derp.Y = PlayerPawn.Location.Y;
	derp.Z = PlayerPawn.Location.Z;
	SoundBeacon = Spawn(class'StealthGame.StealthSoundBeacon',,,derp);
}

// Runs right before the game starts.
simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	
	// Sets the player pawn
	PlayerPawn = StealthPawn(GetALocalPlayerController().Pawn);
}

event PostRender()
{
	super.PostRender();
	
	// This will render the beacon
	if(drawSoundBeaconCircle)
	{
		RenderThreeDeeCircle(SoundBeacon);
	}
}

// Renders a pulsing circle around the Targets Pawn
// This will also check if anything is inside this circle.
function RenderThreeDeeCircle(Pawn target)
{
	local Rotator Angle;
	local Vector Radius, Offsets[16];
	local Box ComponentsBoundingBox;
	local float Width, Height;
	local SGameListenerPawn victim;
	local int i;
	
	circleSize += 0.05f;

	if (PlayerOwner == None)
	{
		return;
	}
	
	target.GetComponentsBoundingBox(ComponentsBoundingBox);
	
	Width = (ComponentsBoundingBox.Max.X - ComponentsBoundingBox.Min.X) * circleSize;
	Height = ComponentsBoundingBox.Max.Y - ComponentsBoundingBox.Min.Y;
	Radius.X = (Width > Height) ? Width : Height;
	
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
	foreach target.OverlappingActors(class'Pawn', victim, Radius.X)
	{
		if(victim != target && victim != PlayerPawn)
		{			`log("Ring collision");

			
		}
	}

	if(circleSize >= MaxCircleSize)
	{
		`Log("Destroyed: "$SoundBeacon.Destroy());
		circleSize = 0;
		drawSoundBeaconCircle=false;
	}

}

defaultproperties
{
	MaxCircleSize=10;
	circleSize=0.0
	drawSoundBeaconCircle=false
}