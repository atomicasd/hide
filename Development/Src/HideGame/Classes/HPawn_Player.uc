class HPawn_Player extends HPawn;

var     class<HInformation_Player>  HCharacterInfo;
var     HInformation_Player         CharacterInfo;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	SetCharacterClassInformation(CharacterInfo);
	MaxFootstepDistSq=10;
}

function bool Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local HPawn_Monster p;

	//Reset all monster on map to default settings.
	foreach WorldInfo.AllPawns(class'HPawn_Monster', p)
	{
		p.Reset();
	}

	return super.Died(Killer, damageType, HitLocation);
}

exec function KillYourself()
{
	`Log("Die");
	Suicide();
}

event Tick(float TimeDelta)
{
	local int soundRadius;
	local HSoundSpot soundSpot;
	local HPawn_Monster target;

	switch(HPlayer.WalkState)   
	{
	case Idle:  soundRadius=150;  break;
	case Walk:  soundRadius=600;  break;
	case Sneak: soundRadius=300;  break;
	case Run:   soundRadius=1500; break;
	}

	foreach OverlappingActors(class'HPawn_Monster', target, soundRadius)
	{
		soundSpot = Spawn(class'HSoundSpot',,, Location,,, true);
		target.OnSoundHeard(soundSpot);
	}

	
}

simulated function ActuallyPlayFootstepSound(int FootDown)
{
	local SoundCue FootSound;

	FootSound = SoundGroupClass.static.GetFootstepSound(FootDown, GetMaterialBelowFeet());
	if (FootSound != None)
	{
		PlaySound(FootSound, false, true,,, true);
	}
}

defaultproperties
{
	InventoryManagerClass = None
	HCharacterInfo = class'HideGame.HInformation_Player'
	
	GroundSpeed=210.0
	CrouchHeight=45
	bStatic = false
	bNoDelete = false
	bCanDoubleJump=false
}