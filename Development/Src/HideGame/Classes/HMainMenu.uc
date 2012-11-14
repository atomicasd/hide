class HMainMenu extends GFxMoviePlayer;


var HPlayerController HPlayer;

var GFxClikWidget us_btn_newgame;
var GFxClikWidget us_btn_exitgame;
var GFxClikWidget us_btn_level1;
var GFxClikWidget us_btn_level2;
var GFxClikWidget us_cb_fullscreen;
var GFxClikWidget us_slider_soundAmbient;
var GFxClikWidget us_slider_soundEffects;
var GFxClikWidget us_slider_brightness;
var GFxClikWidget us_stepper_resolution;

var class<AudioComponent> Hmusic;
var AudioComponent MenuMusic;

//var class<PlayerController> pc;

function bool Start( optional bool StartPaused = false )
{
	super.Start();
	Advance( 0 );

	MenuMusic = new Hmusic;
	MenuMusic.SoundCue = SoundCue'MenuPackage.MainMenuSound.alphaMainMenuSound_Cue';
	MenuMusic.Play();

	HPlayer = HPlayerController(GetPC());

	return true;
}

event bool WidgetInitialized( name WidgetName, name WidgetPath, GFxObject Widget )
{
	
	switch( WidgetName )
	{
	case ( 'btn_newgame' ):
		us_btn_newgame = GFxClikWidget( Widget );
		us_btn_newgame.AddEventListener( 'CLIK_press', onNewGameButtonPress );
		break;
	case ( 'btn_exitgame' ):
		us_btn_exitgame = GFxClikWidget( Widget );
		us_btn_exitgame.AddEventListener( 'CLIK_press', onExitButtonPress );
		break;
	case ( 'btn_level1' ):
		us_btn_level1 = GFxClikWidget( Widget );
		us_btn_level1.AddEventListener( 'CLIK_press', onLevel1ButtonPress );
		break;
	case ( 'btn_level2' ):
		us_btn_level2 = GFxClikWidget( Widget );
		us_btn_level2.AddEventListener( 'CLIK_press', onLevel2ButtonPress );
		//if ( HPlayer.getUnlockedLevels() < 2 )
		us_btn_level2.GotoAndStop( "disabled" );
		break;
	case ('cb_fullscreen'):
		us_cb_fullscreen = GFxClikWidget(Widget);
		us_cb_fullscreen.AddEventListener('CLIK_select', onFullscreenChange );
		//"check om fullscreen er paa:
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
		us_slider_brightness.AddEventListener( 'CLIK_valueChange', onBrightnessChange );
		break;
	case ( 'stepper_resolution' ):
		us_stepper_resolution = GFxClikWidget( Widget );
		us_stepper_resolution.AddEventListener( 'CLIK_change', onResolutionChange );
		break;
	default:
		break;
	}
	return true;
}

function onExitButtonPress( GFxClikWidget.EventData ev )
{
	saveToConfig();
	ConsoleCommand( "quit" );
}
function onNewGameButtonPress( GFxClikWidget.EventData ev )
{
	saveToConfig();
	ConsoleCommand( "Open HG-Lvl-1" );
}

function onLevel1ButtonPress( GFxClikWidget.EventData ev )
{
	saveToConfig();
	ConsoleCommand( "Open HG-Lvl-1" );
}
function onLevel2ButtonPress( GFxClikWidget.EventData ev )
{
	saveToConfig();
	ConsoleCommand( "Open HG-Lvl-2" );
}


function onFullscreenChange( GFxClikWidget.EventData ev )
{
	HPlayer.Fullscreen = us_cb_fullscreen.GetBool("_selected");
	if ( HPlayer.Fullscreen )
		ConsoleCommand( "setres 1366x768f" );
	else
		ConsoleCommand( "setres 1366x768w" );
}

function onResolutionChange( GFxClikWidget.EventData ev )
{
	//us_stepper_resolution.GetFloat( "selectedIndex" )
	switch ( us_stepper_resolution.GetFloat( "selectedIndex" ) )
		{
		case( 0 ):
			ConsoleCommand( "setres 800x600" );
			break;
		case( 1 ):
			ConsoleCommand( "setres 1024x768" );
			break;
		case( 2 ):
			ConsoleCommand( "setres 1366x768" );
			break;
		case( 3 ):
			ConsoleCommand( "setres 1920x1080" );
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
	`log("yes");
	//ConsoleCommand( "Open HG-Lvl02" );
}

function saveToConfig()
{
	HPlayer.saveToConfig();
}


DefaultProperties
{
	WidgetBindings.Add( ( WidgetName="btn_newgame", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_exitgame", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_level1", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_level2", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="cb_fullscreen", WidgetClass=class'GFxClikWidget') )
	WidgetBindings.Add( ( WidgetName="slider_soundAmbient", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="slider_soundEffects", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="slider_brightness", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="stepper_resolution", WidgetClass=class'GFxClikWidget' ) )

	Hmusic = class'AudioComponent'

	bCaptureInput = true;
}