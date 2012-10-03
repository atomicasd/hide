class HPawn_Player extends UTPawn;


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
	
	//bCanCrouch=true
	CrouchHeight=45
	bStatic = false
	bNoDelete = false
}