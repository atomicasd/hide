class HPauseMenu extends GFxMoviePlayer;

//var GFxObject  PauseMC;
var GFxClikWidget pmRestart, pmMainMenu, pmExit;


var bool bRollOver;
var string focusedButton;

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0);
	//AddCaptureKey('Enter');
	//AddCaptureKey('Space');
	//AddFocusIgnoreKey('Escape');
	
    return TRUE;
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch(WidgetName)
	{
		case ('btn_restartLevel'):
			pmRestart = GFxClikWidget(Widget);
			pmRestart.AddEventListener( 'CLIK_press', onRestartButtonPress );
			break;
		case ('btn_quitToMenu'):
			pmMainMenu = GFxClikWidget(Widget);
			pmMainMenu.AddEventListener( 'CLIK_press', onMenuButtonPress );
			break;
		case ('btn_exitgame'):
			pmExit = GFxClikWidget(Widget);
			pmExit.AddEventListener( 'CLIK_press', onExitButtonPress );
			break;
		Default:
			break;
	}
	return true;
}

function onRestartButtonPress( GFxClikWidget.EventData ev )
{
	ConsoleCommand( "RestartLevel" );
}

function onMenuButtonPress( GFxClikWidget.EventData ev )
{
	ConsoleCommand( "Open HG-HideMenuMap" );
}

function onExitButtonPress( GFxClikWidget.EventData ev )
{
	ConsoleCommand( "quit" );
}


function ClosePauseMenu()
{
	Close();
}

defaultproperties
{
	bShowHardwareMouseCursor = true;
    bEnableGammaCorrection=FALSE
	bIgnoreMouseInput = false
	bPauseGameWhileActive = true;
	bCaptureInput = true;
	WidgetBindings.Add( ( WidgetName="btn_restartLevel", WidgetClass=class'GFxClikWidget' ) )

	WidgetBindings.Add( ( WidgetName="btn_quitToMenu", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_exitgame", WidgetClass=class'GFxClikWidget' ) )
}