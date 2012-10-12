class HMainMenu extends GFxMoviePlayer;

var GFxClikWidget  newGameBtn;
var GFxClikWidget  exitBtn;
var class<AudioComponent> Hmusic;
var AudioComponent MenuMusic;

function bool Start( optional bool StartPaused = false )
{
	
	super.Start();
	Advance( 0 );

	MenuMusic = new Hmusic;
	`Log("Sound");
	MenuMusic.SoundCue = SoundCue'MenuPackage.MainMenuSound.alphaMainMenuSound_Cue';
	MenuMusic.Play();

	return true;
}

event bool WidgetInitialized( name WidgetName, name WidgetPath, GFxObject Widget )
{
	
	switch( WidgetName )
	{
	case ( 'newGameBtn' ):
		newGameBtn = GFxClikWidget( Widget );
		newGameBtn.AddEventListener( 'CLIK_press', onNewGameButtonPress );
		break;
	case ( 'exitBtn' ):
		exitBtn = GFxClikWidget( Widget );
		exitBtn.AddEventListener( 'CLIK_press', onExitButtonPress );
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
	ConsoleCommand( "Open lvl01" );
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
	WidgetBindings.Add( ( WidgetName="newGameBtn", WidgetClass=class'GFxClikWidget' ) )
	WidgetBindings.Add( ( WidgetName="exitBtn", WidgetClass=class'GFxClikWidget' ) )

	Hmusic = class'AudioComponent'
}
