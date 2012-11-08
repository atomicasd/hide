class HMainMenu extends GFxMoviePlayer;

var HPlayerController HPlayer;

var GFxClikWidget  newGameBtn;
var GFxClikWidget  exitBtn;
var GFxClikWidget  lvl1Btn;
var GFxClikWidget  lvl2Btn;
var GFxClikWidget  brightnessSlider;
var class<AudioComponent> Hmusic;
var AudioComponent MenuMusic;

function bool Start( optional bool StartPaused = false )
{
	super.Start();
	Advance( 0 );

	MenuMusic = new Hmusic;

	MenuMusic.SoundCue = SoundCue'MenuPackage.MainMenuSound.alphaMainMenuSound_Cue';
	MenuMusic.Play();

	return true;
}

event bool WidgetInitialized( name WidgetName, name WidgetPath, GFxObject Widget )
{
	
	switch( WidgetName )
	{
	case ( 'btn_newgame' ):
		newGameBtn = GFxClikWidget( Widget );
		newGameBtn.AddEventListener( 'CLIK_press', onNewGameButtonPress );
		HPlayer.IgnoreInput(false);
		break;
	case ( 'btn_exitgame' ):
		exitBtn = GFxClikWidget( Widget );
		exitBtn.AddEventListener( 'CLIK_press', onExitButtonPress );
		break;
	case ( 'btn_level1' ):
		lvl1Btn = GFxClikWidget( Widget );
		lvl1Btn.AddEventListener( 'CLIK_press', onLvl1ButtonPress );
		break;
	case ( 'btn_level2' ):
		lvl2Btn = GFxClikWidget( Widget );
		lvl2Btn.AddEventListener( 'CLIK_press', onLvl2ButtonPress );
		break;
	case ( 'slider_brightness' ):
		brightnessSlider = GFxClikWidget( Widget );
		brightnessSlider.AddEventListener( 'CLIK_valueChange', onBrightnessSlider );
		break;
	default:
		break;
	}
	return true;
}

function onExitButtonPress( GFxClikWidget.EventData ev )
{
	ConsoleCommand( "quit" );
}
function onNewGameButtonPress( GFxClikWidget.EventData ev )
{
	ConsoleCommand( "Open HG-Lvl-1" );
}

function onLvl1ButtonPress( GFxClikWidget.EventData ev )
{
	ConsoleCommand( "Open HG-Lvl-1" );
}

function onLvl2ButtonPress( GFxClikWidget.EventData ev )
{
	ConsoleCommand( "Open HG-Lvl-2" );
}

function onBrightnessSlider( GFxClikWidget.EventData ev )
{
	`log("yes");
	//ConsoleCommand( "Open HG-Lvl02" );
}


/*
final function ConsoleCommand( string Cmd, optional bool bWriteToLog )
{
	if( PlayerOwner != none )
		PlayerOwner.ConsoleCommand( Cmd, bWriteToLog );
		
}
*/

DefaultProperties
{
	WidgetBindings.Add( ( WidgetName="btn_newgame", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_exitgame", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_level1", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="btn_level2", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="slider_brightness", WidgetClass=class'GFxClikWidget' ) )
	bCaptureInput = true;
	Hmusic = class'AudioComponent'
}
