class StealthGame extends UTGame;

defaultproperties
{
	DefaultPawnClass=class'StealthPawn'

    PlayerControllerClass=class'StealthGamePlayerController'

	HUDType=class'StealthGame.StealthHUD'
	bUseClassicHUD=true 

	bDelayedStart=false
}

event PostLogin( PlayerController NewPlayer )
{
    super.PostLogin(NewPlayer);
    NewPlayer.ClientMessage("Welcome to the grid "$NewPlayer.PlayerReplicationInfo.PlayerName);
    NewPlayer.ClientMessage("Point at an object and press the left mouds button to retrieve the target's information");
}

event PlayerController Login(string Portal, string Options, const UniqueNetID UniqueID, out string ErrorMessage)
{
	local PlayerController PC;
	PC = super.Login(Portal, Options, UniqueID, ErrorMessage);
	ChangeName(PC, "Stealthy", true);
    return PC;
}