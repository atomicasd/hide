class HLevelFailedMenu extends GFxMoviePlayer;

var HPlayerController   HPlayer;

var GFxClikWidget       us_btn_restart;
var GFxClikWidget       us_btn_mainMenu;
var GFxClikWidget       us_btn_exitgameYeah;

var class<AudioComponent>   HLevelFailedMusic;
var AudioComponent          LevelFailedMusic;

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0);
	LevelFailedMusic = new HLevelFailedMusic;
	LevelFailedMusic.SoundCue = SoundCue'MenuPackage.MainMenuSound.alphaMainMenuSound_Cue';
	LevelFailedMusic.Play();
	
	HPlayer = HPlayerController(GetPC());
	
    return TRUE;
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch(WidgetName)
	{
		case ('btn_restartLevel'):
			us_btn_restart = GFxClikWidget(Widget);
			us_btn_restart.AddEventListener( 'CLIK_press', onRestartButtonPress );
			break;
		case ('btn_quitToMenu'):
			us_btn_mainMenu = GFxClikWidget(Widget);
			us_btn_mainMenu.AddEventListener( 'CLIK_press', onMenuButtonPress );
			break;
		case ('btn_exitgameYeah'):
			us_btn_exitgameYeah = GFxClikWidget(Widget);
			us_btn_exitgameYeah.AddEventListener( 'CLIK_press', onExitButtonPress );
			break;
		Default:
			break;
	}
	return true;
}

function onRestartButtonPress( GFxClikWidget.EventData ev )
{
	LevelFailedMusic.Stop();
	ConsoleCommand( "Open HG-" $ HPlayer.OnCurrentLevel  );
}

function onMenuButtonPress( GFxClikWidget.EventData ev )
{
	LevelFailedMusic.Stop();
	ConsoleCommand( "Open HG-HideMenuMap" );
}

function onExitButtonPress( GFxClikWidget.EventData ev )
{
	LevelFailedMusic.Stop();
	ConsoleCommand( "quit" );
}

DefaultProperties
{
	WidgetBindings.Add( ( WidgetName="btn_restartLevel", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_quitToMenu", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_exitgameYeah", WidgetClass=class'GFxClikWidget' ) )

	HLevelFailedMusic = class'AudioComponent'

	bCaptureInput = true
	bShowHardwareMouseCursor = true
    bEnableGammaCorrection=false
	bIgnoreMouseInput = false
	bPauseGameWhileActive = true
}
