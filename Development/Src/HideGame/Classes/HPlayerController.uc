class HPlayerController extends UTPlayerController;

enum PlayerWalkingState
{
	Idle,
	Walk,
	Sneak,
	Run
};

var     HideGame    hGame;

/*
 * Config variables
 */
var config  int     LevelsCleared;
var config  string  OnCurrentLevel;
var config  float   MasterVolume;
var config  float   MusicVolume;
var config  int     PlayerLifes;
var config  bool    Fullscreen;
var config  string  Resolution;
var config  float   Brightness;
var config  float   Sensitivity;

var config  name    UseBind;
var config  name    RunBind;
var config  name    SneakBind;
var config  name    PulseBind;
var config  name    JumpBind;

var config  name    OldUseBind;
var config  name    OldRunBind;
var config  name    OldSneakBind;
var config  name    OldPulseBind;
var config  name    OldJumpBind;

	
var     int     HPlayerLifes;

var     string  MapName;

var     bool    bInEndOfLevel;
var     bool    bChangedState;
var     bool    bIgnoreInput;
var     bool    bCanJump;

var     bool	pulseMade;
var     bool    pulseFadeOut; //If the pulse should go outwards or towards the player(end of pulse)
var     float	pulseMaxRadius;
var     float	pulseRadius;
var     float   fadeOutStart;
var     float   pulseTime;
var     float   pulseDensity;
var     float   HpulseTimer;
var     bool    pulseFadedIn;
var     bool    startPulseTimer;
var     float   pulseCooldownTimer;

var     PlayerWalkingState          WalkState;

/*****
 * Sound
 */
var     AudioComponent              HDeathSound;
var     array<SoundCue>             DeathSounds;
var     bool                        PlayDeathSound;
var     float                       WaitDeathSound;

var bool bFinishedGame;
var float timeTillMainMenu;

function SetBinds()
{
	PlayerInput.SetBind( OldUseBind, "" );
	PlayerInput.SetBind( OldRunBind, "" );
	PlayerInput.SetBind( OldSneakBind, "" );
	PlayerInput.SetBind( OldPulseBind, "" );
	PlayerInput.SetBind( OldJumpBind, "" );

	PlayerInput.SetBind( UseBind, "GBA_Use" );
	PlayerInput.SetBind( RunBind, "Run | Onrelease RunReleased" );
	PlayerInput.SetBind( SneakBind, "Sneak | Onrelease SneakReleased" );
	PlayerInput.SetBind( PulseBind, "FadeInHitEffect | Onrelease FadeOutHitEffect" );
	PlayerInput.SetBind( JumpBind, "GBA_Jump" );

	OldUseBind = UseBind;
	OldRunBind = RunBind;
	OldSneakBind = SneakBind;
	OldPulseBind = PulseBind;
	OldJumpBind = JumpBind;
}

simulated event PostBeginPlay()
{
	local FogVolumeSphericalDensityInfo A;

	super.PostBeginPlay();

	ServerSetCharacterClass(class'HFamilyInfo_Player');
	
	ForEach WorldInfo.AllActors(class'FogVolumeSphericalDensityInfo', A)
	{
		A.DensityComponent.StartDistance = 20000;
		A.ForceUpdateComponents();
	}

	HDeathSound = CreateAudioComponent(SoundCue'SoundPackage.Enviroment.monsterChewing01_Cue', 
										false, true, true, Location, true);

	HPlayerLifes = PlayerLifes;

	SetMusicVolume(MusicVolume);
	SetMasterVolume(MasterVolume);

	WalkState = Idle;
}

function InitConfig()
{
	local array<string> lvlName;

	MapName = WorldInfo.GetMapName();
	lvlName = SplitString(MapName);

	if(lvlName[0] != "HideMenuMap")
	{
		OnCurrentLevel=MapName;
	}
		
	/* Log variables in the config file */
	`Log("---------> MapName :        " $WorldInfo.GetMapName());
	`Log("---------> LevelsCleared:   " $LevelsCleared);
	`Log("---------> OnCurrentLevel:  " $OnCurrentLevel);
	`Log("---------> Master Sound lvl:" $MasterVolume);
	`Log("---------> Music Sound lvl: " $MusicVolume);
	`Log("---------> Fullscreen:      " $Fullscreen);
	`Log("---------> Resolution:      " $Resolution);
	
	SetMusicVolume(MusicVolume);
	SetMasterVolume(MasterVolume);	
	SetFullscreen( Fullscreen ); // and resolution.
	SetBrightnessValue( Brightness );
	SetSensitivity( Sensitivity );
	SaveToConfig();
}

function playerDied()
{
	--HPlayerLifes;

	PlayDeathSound = true;
	WaitDeathSound = 0;
	if(HPlayerLifes <= 0)
	{
		hGame.hHud.ShowLevelFailedMenu();	
	}
}

function Spawned()
{
	PlayDeathSound = false;
	HDeathSound.Stop();
}

simulated event GetPlayerViewPoint( out vector out_Location, out Rotator out_Rotation )
{
	local Actor TheViewTarget;

	// sometimes the PlayerCamera can be none and we probably do not want this
	// so we will check to see if we have a CameraClass.  Having a CameraClass is
	// saying:  we want a camera so make certain one exists by spawning one
	if( PlayerCamera == None )
	{
		if( CameraClass != None )
		{
			// Associate Camera with PlayerController
			PlayerCamera = Spawn(CameraClass, Self);
			if( PlayerCamera != None )
				PlayerCamera.InitializeFor( Self );
			else
				`log("Couldn't Spawn Camera Actor for Player!!");
		}

		TheViewTarget = GetViewTarget();

		if( TheViewTarget != None )
		{
			out_Location = TheViewTarget.Location;
			out_Rotation = TheViewTarget.Rotation;
		}
		else
		{
			out_Location = Location;
			out_Rotation = Rotation;
		}
	}
	else
		PlayerCamera.GetCameraViewPoint(out_Location, out_Rotation);
}

function EnablePulse()
{
	IgnoreInput(true);
	pulseMade = true;
	pulseRadius = 0.0f;
	pulseFadeOut = true;
	fadeOutStart = 0.0f;
	pulseDensity = 1.0f;
	pulseFadedIn = false;
	
}

function TriggerRemoteKismetEvent( name EventName )
{
	local array<SequenceObject> AllSeqEvents;
	local Sequence GameSeq;
	local int i;

	GameSeq = WorldInfo.GetGameSequence();
	if (GameSeq != None)
	{
		// reset the game sequence
		GameSeq.Reset();

		// find any Level Reset events that exist
		GameSeq.FindSeqObjectsByClass(class'SeqEvent_RemoteEvent', true, AllSeqEvents);

		// activate them
		for (i = 0; i < AllSeqEvents.Length; i++)
		{
			if(SeqEvent_RemoteEvent(AllSeqEvents[i]).EventName == EventName)
				SeqEvent_RemoteEvent(AllSeqEvents[i]).CheckActivate(WorldInfo, None);
		}
	}
}

function PulseFadeIn()
{
	pulseFadeOut = false;
}

function PlayerTick(float DeltaTime)
{
	local FogVolumeSphericalDensityInfo A;
	local FogVolumeSphericalDensityComponent B;
	

	if( pulseMade )
	{
		if( pulseFadeOut )
		{
			ForEach WorldInfo.AllActors(class'FogVolumeSphericalDensityInfo', A)
			{
				if( pulseRadius >= pulseMaxRadius )
				{
					pulseMade = false;
				} else
				{
					A.DensityComponent.StartDistance = pulseRadius;
					ForEach A.ComponentList( class'FogVolumeSphericalDensityComponent', B )
					{
					
						//B.MaxDensity = (pulseMaxRadius + 900) / ( pulseMaxRadius/5 * pulseRadius);
						B.MaxDensity = pulseDensity;
						B.ForceUpdate(true);
					}
				
					A.ForceUpdateComponents();
				}

				pulseRadius += DeltaTime*2000 - ( (DeltaTime*2000) * (pulseRadius/pulseMaxRadius) );
			}
		} else {
			ForEach WorldInfo.AllActors(class'FogVolumeSphericalDensityInfo', A)
			{
				if( pulseRadius <= 3 )
				{
					IgnoreInput(false);

					pulseFadedIn = true;
					pulseMade = false;
					A.DensityComponent.StartDistance = pulseRadius;
					ForEach A.ComponentList( class'FogVolumeSphericalDensityComponent', B )
					{
						hGame.MakeMapSolid();
						B.MaxDensity = 0.0f;
						B.ForceUpdate(true);
					}
				} else
				{
					A.DensityComponent.StartDistance = pulseRadius;
					ForEach A.ComponentList( class'FogVolumeSphericalDensityComponent', B )
					{
					
						//B.MaxDensity = (pulseMaxRadius + 900) / ( pulseMaxRadius/5 * pulseRadius);
						B.MaxDensity = pulseDensity;
						B.ForceUpdate(true);
					}
				
					A.ForceUpdateComponents();
				}
				
				pulseRadius -= DeltaTime*2000;
			}
		}
	}

	if(startPulseTimer)
	{
		if(hpulseTimer > 0)
		{
			hpulseTimer -= DeltaTime;
		}else{
			startPulseTimer = false;
		}   
	}

	if(PlayDeathSound)
	{
		WaitDeathSound += DeltaTime;
		if(WaitDeathSound >= 1)
		{
			if(!HDeathSound.IsPlaying())
			{
				HDeathSound.SoundCue = getDeathSound();
				HDeathSound.Play();
			}
		}
	}
	
	if(HPawn_Player(Pawn) != None)
	{
		// Player Input to change Walkingstate
		if(bChangedState)
		{
			switch(WalkState)
			{
			case Idle: 
				break;
			case Walk:
				Pawn.GroundSpeed = 180;
				HPawn_Player( Pawn ).SetFootAnimState(FS_Walk);
				break;
			case Sneak:
				Pawn.GroundSpeed = 180;
				HPawn_Player( Pawn ).SetFootAnimState(FS_Sneak);
				break;
			case Run:
				Pawn.GroundSpeed = 250;
				HPawn_Player( Pawn ).SetFootAnimState(FS_Run);
				break;
			}
			bChangedState=false;	
		}
	}

	if(bFinishedGame)
	{
		timeTillMainMenu -= DeltaTime;
		if( timeTillMainMenu <= 0.0)
		{
			ConsoleCommand( "Open HG-HideMenuMap" );
		}
	}
	
	//this line is not need if you add this code to PlayerController.uc
	Super.PlayerTick(DeltaTime);
}

exec function makePulseCircle()
{
	pulseMade = true;
	pulseRadius = 1;
	pulseFadeOut = true;
	fadeOutStart = 0.0f;
	`log("Making pulse effect");
}

/**
 * Input functions
 */

// Activate the pulse ability and freezes the player
exec function ActivatePulse()
{
	HPawn_Player(Pawn).ActivatedPulse();
	hGame.MakeMapTransparent();
	IgnoreInput(true);
	pulseMade = true;
	pulseRadius = 0.0f;
	pulseFadeOut = true;
	fadeOutStart = 0.0f;
	pulseDensity = 1.0f;
	pulseFadedIn = false;
}

// Disable the pulse effect, and starts the cooldown
exec function DisablePulse()
{
	HPawn_Player(Pawn).DeactivatedPulse();
	IgnoreInput(false);
	pulseFadeOut = false;
	pulseFadedIn = true;
//	startPulseTimer = true;
}

// Ignores mouse and move input
function IgnoreInput(bool bIgnore)
{
	bIgnoreInput = bIgnore;
	//ClientIgnoreLookInput(bIgnore);
	ClientIgnoreMoveInput(bIgnore);
}

// Need this so player cant jump when he uses pulse
function CheckJumpOrDuck()
{
	if(!bIgnoreInput && bCanJump){
		super.CheckJumpOrDuck();
	}
}

function FinishGame()
{
	local HPawn_Monster p;
	hGame.ShowFinishGamePicture();
	IgnoreInput(true);
	bFinishedGame = true;

	//Reset all monster on map to default settings.
	foreach WorldInfo.AllPawns(class'HPawn_Monster', p)
	{
		p.Reset();
	}
}

/**
 * Config functions
 */
// Set Master Volume
function SetMasterVolume(float Volume)
{
	MasterVolume = Volume;
	SetAudioGroupVolume('Master', Volume);
}

// Set Music Volume
function SetMusicVolume(float Volume)
{
	MusicVolume = Volume;
	SetAudioGroupVolume('Music', Volume);
}

// set Brightness value;
function SetBrightnessValue( float value )
{
	Brightness = value;
	`log(" Brightness: " $ Brightness);
	ConsoleCommand( "GAMMA " $ Brightness );
}

// set Sensitivity value;
function SetSensitivity( float sens )
{
	Sensitivity = sens;
	ConsoleCommand( "SetSensitivity " $ Sensitivity );
}
// Last functions thats sets sound to the musicgroup
function SetAudioGroupVolume( name GroupName, float Volume )
{
	`log(GroupName $" Volume: "$Volume);
	super.SetAudioGroupVolume( GroupName, Volume );
	SaveToConfig();
}

// Set Fullscreen
function SetFullscreen( bool fs )
{
	Fullscreen = fs;
	if ( Fullscreen )
		ConsoleCommand( "setres " $ Resolution $ "f" );
	else
		ConsoleCommand( "setres " $ Resolution $ "w" );
}

function SetResolution( string res ) 
{
	Resolution = res;
	ConsoleCommand( "setres " $ Resolution );
}

function float getMusicVolume()
{
	return MusicVolume;
}

function float getMasterVolume()
{
	return MasterVolume;
}

// This is where u set the Config vars. but how to actually "use" these idk.
// something like PlayerInput.SetBind( UseBind, "GBA_USE" ); but ehduntknow.
function setKeyBinding( name theKey, string cmd ) {
	
	switch ( cmd ) {
	case "Use":
		UseBind = theKey;
		break;
	case "Run":
		RunBind = theKey;
		break;
	case "Sneak":
		SneakBind = theKey;
		PlayerInput.SetBind( SneakBind, "GBA_Duck" );
		break;
	case "Pulse":
		PulseBind = theKey;
		break;
	case "Jump":
		JumpBind = theKey;
		break;
	default:
		break;
	}


}

function saveToConfig()
{
	SaveConfig();
}

function increasLevelCleared()
{
	++LevelsCleared;
}

function int getLevelNumber()
{
	local string        MapName0;
	local int           MapNumber;
	local array<string> MapArray;

	MapName0 = WorldInfo.GetMapName();
	MapArray = SplitString(MapName0, "-");

	MapNumber = int(MapArray[1]);

	return MapNumber;
}

/*****************
 * DeathSound
 * ***************/

function SoundCue getDeathSound()
{
	return DeathSounds[rand(DeathSounds.Length)];
}

DefaultProperties
{
	InputClass = class'HideGame.HPlayerInput'
	CameraClass = class'HCamera'
	
	pulseMade = false
	pulseMaxRadius = 1000
	pulseRadius = 1
	pulseFadeOut = true
	fadeOutStart = 0.5f
	pulseTime = 5.0f
	pulseDensity = 1.0f
	pulseFadedIn = false
	pulseCooldownTimer = 5
	bCanJump=true

	bFinishedGame = false
	timeTillMainMenu = 23.0f

	DeathSounds[0] = SoundCue'SoundPackage.Enviroment.monsterChewing01_Cue';
	DeathSounds[1] = SoundCue'SoundPackage.Enviroment.monsterChewing02_Cue';
	DeathSounds[2] = SoundCue'SoundPackage.Enviroment.monsterChewing03_Cue';
}
