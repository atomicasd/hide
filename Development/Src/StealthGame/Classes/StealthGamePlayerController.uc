class StealthGamePlayerController extends UTPlayerController;

var class<UTFamilyInfo> CharacterClass;

function pawnDied(Pawn p)
{
	local vector Position;
	local StealthPawn PC;
	local StealthDeadBodyClone clone;

	PC = StealthPawn(GetALocalPlayerController().Pawn);
	
	Position.X = PC.Location.X;
	Position.Y = PC.Location.Y;
	Position.Z = PC.Location.Z;

	`Log("Spawning new Dead Clone");

	Spawn(class'StealthDeadBodyClone',,,Position,,,false);

	super.PawnDied(p);
}
state() Dead
{
	function SpawnDeadClone()
	{
		local vector Position;
		//PC = GetALocalPlayerController();
	
		Position.X = Location.X;
		Position.Y = Location.Y;
		Position.Z = Location.Z;

		`Log("Spawning new DeadClone");
	
		Spawn(class'StealthDeadBodyClone',,,Position,,,false);
	}
}

simulated event PostBeginPlay()
{
  super.PostBeginPlay();
   
  SetupPlayerCharacter();
}

/** Set player's character info class & perform any other initialization */
function SetupPlayerCharacter()
{
  //Set character to our custom character
  ServerSetCharacterClass(CharacterClass);
}

defaultproperties
{
  //Points to the UTFamilyInfo class for your custom character
  CharacterClass=class'UTFamilyInfo_Liandri_Male'
}
/**
 * Draw a crosshair. This function is called by the Engine.HUD class.
 */
function DrawHUD( HUD H )
{
	local float CrosshairSize;
	//super.DrawHUD(H);

	H.Canvas.SetDrawColor(0,255,0,255);

	H.Canvas.SetPos(10, 10);
	H.Canvas.DrawText( "Test" );

	CrosshairSize = 4;

	H.Canvas.SetPos(H.CenterX - CrosshairSize, H.CenterY);
	H.Canvas.DrawRect(2*CrosshairSize + 1, 1);

	H.Canvas.SetPos(H.CenterX, H.CenterY - CrosshairSize);
	H.Canvas.DrawRect(1, 2*CrosshairSize + 1);
}

/*
 * The default state for the player controller
 */
auto state PlayerWaiting
{
	/*
	 * The function called when the user presses the fire key (left mouse button by default)
	 */
	exec function StartFire( optional byte FireModeNum )
	{

		showTargetInfo();
	}
}

/*
 * Print information about the thing we are looking at
 */
function showTargetInfo()
{
	local vector loc, norm, end;
	local TraceHitInfo hitInfo;
	local Actor traceHit;

	end = Location + normal(vector(Rotation))*32768; // trace to "infinity"
	traceHit = trace(loc, norm, end, Location, true,, hitInfo);

	ClientMessage("");

	if (traceHit == none)
	{
		ClientMessage("Nothing found, try again.");
		return;
	}

	// Play a sound to confirm the information
	ClientPlaySound(SoundCue'A_Vehicle_Cicada.SoundCues.A_Vehicle_Cicada_TargetLock');

	// By default only 4 console messages are shown at the time
 	ClientMessage("Hit: "$traceHit$"  class: "$traceHit.class.outer.name$"."$traceHit.class);
 	ClientMessage("Location: "$loc.X$","$loc.Y$","$loc.Z);
 	ClientMessage("Material: "$hitInfo.Material$"  PhysMaterial: "$hitInfo.PhysMaterial);
	ClientMessage("Component: "$hitInfo.HitComponent);
}