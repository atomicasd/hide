class HPawn_Player extends HPawn;

var     class<HInformation_Player>  HCharacterInfo;
var     HInformation_Player         CharacterInfo;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	CharacterInfo = new HCharacterInfo;
	SetCharacterClassInformation(CharacterInfo);
}

exec function KillYourself()
{
	Suicide();
}

event Tick(float TimeDelta)
{
}

defaultproperties
{
	InventoryManagerClass = class'HideGame.HInventoryManager'
	HCharacterInfo = class'HideGame.HInformation_Player'

	GroundSpeed=210.0
	CrouchHeight=45
	bStatic = false
	bNoDelete = false
}