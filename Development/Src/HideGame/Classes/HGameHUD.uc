class HGameHUD extends UTHUDBase;

var HPauseMenu PauseMenu;

exec function ShowMenu()
{
	// if using GFx HUD, use GFx pause menu
	TogglePauseMenu();
}

function TogglePauseMenu()
{
    if ( PauseMenu != none && PauseMenu.bMovieIsOpen )
	{
          //PauseMenu.PlayCloseAnimation();
	}
    else
    {
		CloseOtherMenus();

        if (PauseMenuMovie == None)
        {
            PauseMenu = new class'HPauseMenu';
            PauseMenu.MovieInfo = SwfMovie'MenuPackage.PauseMenu';
            PauseMenu.bEnableGammaCorrection = FALSE;
            PauseMenu.LocalPlayerOwnerIndex = class'Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));
            PauseMenu.SetTimingMode(TM_Real);
            PlayerOwner.SetPause(True);
			
        }

        SetVisible(false);
        PauseMenu.Start();
        //PauseMenu.PlayOpenAnimation();
        //PauseMenu.AddFocusIgnoreKey('Escape');
    }
}

DefaultProperties
{
}