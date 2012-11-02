class HPauseMenu extends GFxMoviePlayer;

//var GFxObject  PauseMC;
var GFxClikWidget pmResume, pmRestart, pmOptions, pmControls, pmMainMenu;


var bool bRollOver;
var string focusedButton;

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0);
	//AddCaptureKey('Enter');
	//AddCaptureKey('Space');
	AddFocusIgnoreKey('Escape');
	
    return TRUE;
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch(WidgetName)
	{
		case ('btn_resume'):
			pmResume = GFxClikWidget(Widget);
			pmResume.AddEventListener( 'CLIK_press', onResumeButtonPress );
			break;
		case ('btn_exitToMainMenu'):
			pmResume = GFxClikWidget(Widget);
			pmResume.AddEventListener( 'CLIK_press', onExitButtonPress );
			break;
		Default:
			break;
	}
	return true;
}

function onResumeButtonPress( GFxClikWidget.EventData ev )
{
	ClosePauseMenu();
}

function onExitButtonPress( GFxClikWidget.EventData ev )
{
	ConsoleCommand( "Open HG-HideMenuMap" );
}

function ClosePauseMenu()
{
	Close();
}

defaultproperties
{
	
    bEnableGammaCorrection=FALSE
	bIgnoreMouseInput = false
	bPauseGameWhileActive = true;
	bCaptureInput = true;
	WidgetBindings.Add( ( WidgetName="btn_resume", WidgetClass=class'GFxClikWidget' ) )

	WidgetBindings.Add( ( WidgetName="btn_exitToMainMenu", WidgetClass=class'GFxClikWidget' ) )
}