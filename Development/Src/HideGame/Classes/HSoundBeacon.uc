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
		MakeSoundPulse();
		CreateSound=false;
	}
}

// This creates the pulse
function MakeSoundPulse()
{
	local HSoundSpot    soundSpot;
	local HPawn_Monster target;

	foreach OverlappingActors(class'HPawn_Monster', target, Radius)
	{
		`Log("Monster here");
		soundSpot = Spawn(class'HSoundSpot',,,Location,,,true);
		target.OnSoundHeard(soundSpot);
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

	Radius=0
}
