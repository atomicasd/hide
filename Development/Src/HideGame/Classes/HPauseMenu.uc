class HPauseMenu extends GFxMoviePlayer;

var HPlayerController HPlayer;

var GFxClikWidget us_btn_restart;
var GFxClikWidget us_btn_mainMenu;
var GFxClikWidget us_btn_exitgameYeah;
var GFxClikWidget us_btn_resetToDefault;
var GFxClikWidget us_cb_fullscreen;
var GFxClikWidget us_slider_soundAmbient;
var GFxClikWidget us_slider_soundEffects;
var GFxClikWidget us_slider_brightness;
var GFxClikWidget us_slider_sensitivity;
var GFxClikWidget us_stepper_resolution;

var String        toChange;
var GFxClikWidget us_btn_controlsNextToChange;
var GFxClikWidget us_btn_controlsNoButton;
var GFxClikWidget us_btn_controlsUse;
var GFxClikWidget us_btn_controlsRun;
var GFxClikWidget us_btn_controlsSneak;
var GFxClikWidget us_btn_controlsPulse;
var GFxClikWidget us_btn_controlsJump;

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
	AddCaptureKey( 'Escape' );
	
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
			us_slider_brightness.SetFloat( "value", ( HPlayer.Brightness * 5 ) - 1 );
			break;
		case ( 'slider_sensitivity' ):
			us_slider_sensitivity = GFxClikWidget( Widget );
			us_slider_sensitivity.AddEventListener( 'CLIK_change', onSensitivityChange );
			us_slider_sensitivity.SetFloat( "value", HPlayer.Sensitivity / 10 );
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
		case ( 'btn_controlsUse' ):
			us_btn_controlsUse = GFxClikWidget( Widget );
			us_btn_controlsUse.AddEventListener( 'CLIK_press', onUseButtonPress );
			us_btn_controlsUse.SetString( "label", ""$HPlayer.UseBind );
			break;
		case ( 'btn_controlsRun' ):
			us_btn_controlsRun = GFxClikWidget( Widget );
			us_btn_controlsRun.AddEventListener( 'CLIK_press', onRunButtonPress );
			us_btn_controlsRun.SetString( "label", ""$HPlayer.RunBind );
			break;
		case ( 'btn_controlsSneak' ):
			us_btn_controlsSneak = GFxClikWidget( Widget );
			us_btn_controlsSneak.AddEventListener( 'CLIK_press', onSneakButtonPress );
			us_btn_controlsSneak.SetString( "label", ""$HPlayer.SneakBind );
			break;
		case ( 'btn_controlsPulse' ):
			us_btn_controlsPulse = GFxClikWidget( Widget );
			us_btn_controlsPulse.AddEventListener( 'CLIK_press', onPulseButtonPress );
			us_btn_controlsPulse.SetString( "label", ""$HPlayer.PulseBind );
			break;
		case ( 'btn_controlsJump' ):
			us_btn_controlsJump = GFxClikWidget( Widget );
			us_btn_controlsJump.AddEventListener( 'CLIK_press', onJumpButtonPress );
			us_btn_controlsJump.SetString( "label", ""$HPlayer.JumpBind );
			break;
		case ( 'btn_resetToDefault'):
			us_btn_resetToDefault = GFxClikWidget( WIdget );
			us_btn_resetToDefault.AddEventListener( 'CLIK_press', onResetButtonPress );
			break;
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

function callconsolecommand( String cmd ) {
	ConsoleCommand( cmd );
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
	saveToConfig();
	MenuMusic.Stop();
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
	HPlayer.SetBrightnessValue( ( us_slider_brightness.GetFloat("_value") / 5 ) + 1 );
}

function onSensitivityChange( GFxClikWidget.EventData ev )
{
	HPlayer.SetSensitivity( us_slider_sensitivity.GetFloat( "_value" ) * 10 );
}

function saveToConfig()
{
	HPlayer.SetBinds();
	HPlayer.saveToConfig();
}

function onUseButtonPress( GFxClikWidget.EventData ev )
{
	//if ( us_btn_controlsNextToChange == us_btn_controlsUse )
	//us_btn_controlsUse.SetString( "label", "Press Key" );
	us_btn_controlsNextToChange = us_btn_controlsUse;
	toChange = "Use";
	ActionScriptVoid( "enableCustomizeMode" );
}
function onRunButtonPress( GFxClikWidget.EventData ev )
{
	//us_btn_controlsRun.SetString( "label", "Press Key" );
	us_btn_controlsNextToChange = us_btn_controlsRun;
	toChange = "Run";
	ActionScriptVoid( "enableCustomizeMode" );
}
function onSneakButtonPress( GFxClikWidget.EventData ev )
{
	//us_btn_controlsSneak.SetString( "label", "Press Key" );
	us_btn_controlsNextToChange = us_btn_controlsSneak;
	toChange = "Sneak";
	ActionScriptVoid( "enableCustomizeMode" );
}
function onPulseButtonPress( GFxClikWidget.EventData ev )
{
	//us_btn_controlsPulse.SetString( "label", "Press Key" );
	us_btn_controlsNextToChange = us_btn_controlsPulse;
	toChange = "Pulse";
	ActionScriptVoid( "enableCustomizeMode" );
}
function onJumpButtonPress( GFxClikWidget.EventData ev )
{
	//us_btn_controlsJump.SetString( "label", "Press Key" );
	us_btn_controlsNextToChange = us_btn_controlsJump;
	toChange = "Jump";
	ActionScriptVoid( "enableCustomizeMode" );
}
function whatKey( bool esc )
{
	local name theKey;

	theKey = HPlayer.PlayerInput.PressedKeys[0];

	us_btn_controlsNextToChange.SetString( "label", ""$theKey );
	`log("test: " $ theKey );
	HPlayer.setKeyBinding( theKey, toChange );

	us_btn_controlsNextToChange = us_btn_controlsNoButton;
	toChange = "";

	ActionScriptVoid( "disableCustomizeMode" );
}

function onResetButtonPress( GFxClikWidget.EventData ev )
{
	HPlayer.setKeyBinding( 'LeftMouseButton', "Use" );
	us_btn_controlsUse.SetString( "label", ""$Hplayer.UseBind );

	HPlayer.setKeyBinding( 'LeftShift', "Run" );
	us_btn_controlsRun.SetString( "label", ""$Hplayer.RunBind );

	HPlayer.setKeyBinding( 'LeftControl', "Sneak" );
	us_btn_controlsSneak.SetString( "label", ""$Hplayer.SneakBind );

	HPlayer.setKeyBinding( 'RightMouseButton', "Pulse" );
	us_btn_controlsPulse.SetString( "label", ""$Hplayer.PulseBind );

	HPlayer.setKeyBinding( 'Spacebar', "Jump" );
	us_btn_controlsJump.SetString( "label", ""$Hplayer.JumpBind );
}

defaultproperties
{
	WidgetBindings.Add( ( WidgetName="btn_restart", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_quitToMenu", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_exitgameYeah", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_resetToDefault", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="cb_fullscreen", WidgetClass=class'GFxClikWidget') )
	WidgetBindings.Add( ( WidgetName="slider_soundAmbient", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="slider_soundEffects", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="slider_brightness", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="slider_sensitivity", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="stepper_resolution", WidgetClass=class'GFxClikWidget' ) )
	
	WidgetBindings.Add( ( WidgetName="btn_controlsUse", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_controlsRun", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_controlsSneak", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_controlsPulse", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_controlsJump", WidgetClass=class'GFxClikWidget' ) )
	
	Hmusic = class'AudioComponent'

	bShowHardwareMouseCursor = true
	bIgnoreMouseInput = false
	bPauseGameWhileActive = true
}