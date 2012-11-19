class HPauseMenu extends GFxMoviePlayer;

var HPlayerController HPlayer;

var GFxClikWidget us_btn_restart;
var GFxClikWidget us_btn_mainMenu;
var GFxClikWidget us_btn_exitgame;
var GFxClikWidget us_cb_fullscreen;
var GFxClikWidget us_slider_soundAmbient;
var GFxClikWidget us_slider_soundEffects;
var GFxClikWidget us_slider_brightness;
var GFxClikWidget us_stepper_resolution;

var class<AudioComponent> Hmusic;
var AudioComponent MenuMusic;

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0);
	
	MenuMusic = new Hmusic;
	MenuMusic.SoundCue = SoundCue'MenuPackage.MainMenuSound.alphaMainMenuSound_Cue';
	MenuMusic.Play();

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
		case ('btn_exitgame'):
			us_btn_exit = GFxClikWidget(Widget);
			us_btn_exit.AddEventListener( 'CLIK_press', onExitButtonPress );
			break;
		case ('cb_fullscreen'):
		us_cb_fullscreen = GFxClikWidget(Widget);
		us_cb_fullscreen.AddEventListener('CLIK_select', onFullscreenChange );
		us_cb_fullscreen.SetBool("selected", HPlayer.Fullscreen);
		break;
		case ('slider_soundAmbient'):
			us_slider_soundAmbient = GFxClikWidget( Widget );
			us_slider_soundAmbient.AddEventListener( 'CLIK_change', onSoundAmbientChange );
			us_slider_soundAmbient.SetFloat("value", ( HPlayer.MusicVolume * 10 ) );
			break;
		case ('slider_soundEffects'):
			us_slider_soundEffects = GFxClikWidget( Widget );
			us_slider_soundEffects.AddEventListener( 'CLIK_change', onSoundEffectsChange );
			us_slider_soundEffects.SetFloat("value", ( HPlayer.MasterVolume * 10 ) );
			break;
		case ( 'slider_brightness' ):
			us_slider_brightness = GFxClikWidget( Widget );
			us_slider_brightness.AddEventListener( 'CLIK_change', onBrightnessChange );
			us_slider_brightness.SetFloat( "value", HPlayer.Brightness );
			break;
		case ( 'stepper_resolution' ):
			us_stepper_resolution = GFxClikWidget( Widget );
			us_stepper_resolution.AddEventListener( 'CLIK_change', onResolutionChange );
			switch ( HPlayer.Resolution )
			{
			case( "800x600" ):
				us_stepper_resolution.SetFloat( "selectedIndex", 0 );
				break;
			case( "1024x768" ):
				us_stepper_resolution.SetFloat( "selectedIndex", 1 );
				break;
			case( "1366x768" ):
				us_stepper_resolution.SetFloat( "selectedIndex", 2 );
				break;
			case( "1920x1080" ):
				us_stepper_resolution.SetFloat( "selectedIndex", 3 );
				break;
			default:
				break;
			}
		Default:
			break;
	}
	return true;
}

function onRestartButtonPress( GFxClikWidget.EventData ev )
{
	saveToConfig();
	ConsoleCommand( "RestartLevel" );
}

function onMenuButtonPress( GFxClikWidget.EventData ev )
{
	saveToConfig();
	ConsoleCommand( "Open HG-HideMenuMap" );
}

function onExitButtonPress( GFxClikWidget.EventData ev )
{
	saveToConfig();
	ConsoleCommand( "quit" );
}


function ClosePauseMenu()
{
	Close();
}

function onFullscreenChange( GFxClikWidget.EventData ev )
{
	HPlayer.SetFullscreen( us_cb_fullscreen.GetBool("_selected") );
}



function onResolutionChange( GFxClikWidget.EventData ev )
{
	//us_stepper_resolution.GetFloat( "selectedIndex" )
	switch ( us_stepper_resolution.GetFloat( "selectedIndex" ) )
		{
		case( 0 ):
			HPlayer.SetResolution( "800x600" );
			break;
		case( 1 ):
			HPlayer.SetResolution( "1024x768" );
			break;
		case( 2 ):
			HPlayer.SetResolution( "1366x768" );
			break;
		case( 3 ):
			HPlayer.SetResolution( "1920x1080" );
			break;
		default:
			break;
		}
	//us_stepper_resolution.ActionScriptVoid(
	//`log("test: " $ us_stepper_resolution.GetElementMemberString( 1, "selectedIndex" ) );
}
	

function onSoundAmbientChange( GFxClikWidget.EventData ev )
{
	HPlayer.SetMusicVolume( us_slider_soundAmbient.GetFloat("_value") / 10 );
}
function onSoundEffectsChange( GFxClikWidget.EventData ev )
{
	HPlayer.SetMasterVolume( us_slider_soundEffects.GetFloat("_value") / 10 );
}

function onBrightnessChange( GFxClikWidget.EventData ev )
{
	HPlayer.SetBrightnessValue( us_slider_brightness.GetFloat("_value") );
}

function saveToConfig()
{
	HPlayer.saveToConfig();
}

defaultproperties
{
	WidgetBindings.Add( ( WidgetName="btn_restart", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_quitToMenu", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_exitgame", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="cb_fullscreen", WidgetClass=class'GFxClikWidget') )
	WidgetBindings.Add( ( WidgetName="slider_soundAmbient", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="slider_soundEffects", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="slider_brightness", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="stepper_resolution", WidgetClass=class'GFxClikWidget' ) )
	
	Hmusic = class'AudioComponent'

	bCaptureInput = true;
	bShowHardwareMouseCursor = true;
    bEnableGammaCorrection=FALSE
	bIgnoreMouseInput = false
	bPauseGameWhileActive = true;
}