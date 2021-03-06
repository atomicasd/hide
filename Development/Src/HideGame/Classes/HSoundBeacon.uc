class HSoundBeacon extends Actor
	placeable;

var(SoundProperties)   bool    CreateSound;
var(SoundProperties)   int     Radius;

var     bool    bSoundCreated;
var     bool    bIsPlayerSpawned;
var     bool    bIsPlayerDead;

/*
 * Runs this one time, then destroyes itself if player has spawned it.
 */
event Tick(float DeltaTime)
{
	if(bIsPlayerSpawned && !bIsPlayerDead)
	{
		MakeSoundPulse();
	}else if(CreateSound){
		`Log("PulseRadius: "$Radius);
		MakeSoundPulse();
		CreateSound=false;
		OnDestroy(new class'SeqAct_Destroy');
	}else{
		`Log("ButtonPulse");
	}
}

// This creates the pulse
function MakeSoundPulse()
{
	local Vector        TraceFrom;
	local HSoundSpot    soundSpot;
	local HPawn_Monster target;

	// Trace
	local vector            hitlocation, hitnormal;
	local TraceHitInfo      hitInfo;
	local BlockingVolume    tracedBlocking;
	local InterpActor       TracedInter;
	local bool              SoundTroughWall;

	TraceFrom = Location;

	foreach OverlappingActors(class'HPawn_Monster', target, Radius)
	{
		foreach TraceActors(class'BlockingVolume', tracedBlocking, hitlocation, hitnormal, target.Location, TraceFrom, ,hitInfo)
		{
			`log("What A wall?");
			SoundTroughWall = true;
		}
		foreach TraceActors(class'InterpActor', TracedInter, hitlocation, hitnormal, target.Location, TraceFrom,, hitInfo)
		{
			`log("What a door?");
			SoundTroughWall = true;
		}
		if(!SoundTroughWall)
		{
			soundSpot = Spawn(class'HSoundSpot',,,Location,,,true);
			target.OnSoundHeard(soundSpot);
		}
	}
	bSoundCreated=true;
}

DefaultProperties
{
	Begin Object class=SpriteComponent name=sprite1
		Sprite=Texture2D'EditorResources.S_Actor'
		HiddenGame=true
		HiddenEditor=false
	End Object

	Components.add(sprite1)

	

	Radius=1000
	CreateSound=true
}
