class HPlayerController extends UTPlayerController;

enum PlayerWalkingState
{
	Idle,
	Walk,
	Sneak,
	Run
};

var     bool    bInEndOfLevel;
var     bool    bChangedState;
var     bool    bIgnoreInput;

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

	WalkState = Idle;
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
						//B.MaxDensity = (pulseMaxRadius + 900) / ( pulseMaxRadius/5 * pulseRadius);
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
				Pawn.GroundSpeed = 150;
				break;
			case Sneak:
				Pawn.GroundSpeed = 150;
				break;
			case Run:
				Pawn.GroundSpeed = 200;
				break;
			}
			bChangedState=false;	
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
	if(hpulseTimer <= 0)
	{
		hpulseTimer = pulseCooldownTimer;
		IgnoreInput(true);
		pulseMade = true;
		pulseRadius = 0.0f;
		pulseFadeOut = true;
		fadeOutStart = 0.0f;
		pulseDensity = 1.0f;
		pulseFadedIn = false;
	}
}

// Disable the pulse effect, and starts the cooldown
exec function DisablePulse()
{
	IgnoreInput(false);
	pulseFadeOut = false;
	pulseFadedIn = true;
	startPulseTimer = true;
}

// Ignores mouse and move input
function IgnoreInput(bool bIgnore)
{
	bIgnoreInput = bIgnore;
	ClientIgnoreLookInput(bIgnore);
	ClientIgnoreMoveInput(bIgnore);
}

// Need this so player cant jump when he uses pulse
function CheckJumpOrDuck()
{
	if(!bIgnoreInput){
		super.CheckJumpOrDuck();
	}
}


/**
 * Sound functions
 */
// Set Master Volume
function SetMasterVolume(float Volume)
{
	SetAudioGroupVolume('Master', Volume);
}

// Set Music Volume
function SetMusicVolume(float Volume)
{
	SetAudioGroupVolume('Music', Volume);
}

// Last functions thats sets sound to the musicgroup
function SetAudioGroupVolume( name GroupName, float Volume )
{
	super.SetAudioGroupVolume( GroupName, Volume );
}



DefaultProperties
{
	InputClass = class'HideGame.HPlayerInput';
	CameraClass = class'HCamera';
	
	pulseMade = false;
	pulseMaxRadius = 1000;
	pulseRadius = 1;
	pulseFadeOut = true;
	fadeOutStart = 0.5f;
	pulseTime = 5.0f;
	pulseDensity = 1.0f;
	pulseFadedIn = false;
	pulseCooldownTimer = 5;
}

