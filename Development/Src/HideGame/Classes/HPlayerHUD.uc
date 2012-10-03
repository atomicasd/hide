class HPlayerHUD extends UTHUD;

/*
 * Destroys the hud. Will only run once
 */
singular event Destroyed()
{
	RemoveHud();

	Super.Destroyed();
}

function RemoveHud()
{
	
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	CreateHud();
}

/*
 * Initialize movie HUD
 */
function CreateHUD()
{

}

/*
 * Draws the HUD each update
 */
function DrawGameHud()
{
}

DefaultProperties
{
}
