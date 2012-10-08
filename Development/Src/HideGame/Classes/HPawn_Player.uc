class HPawn_Player extends HPawn;

var     class<HInformation_Player>  HCharacterInfo;
var     HInformation_Player         CharacterInfo;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	CharacterInfo = new HCharacterInfo;
	SetCharacterClassInformation(CharacterInfo);
}

exec function KillYourself()
{
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

defaultproperties
{
	InventoryManagerClass = class'HideGame.HInventoryManager'
	HCharacterInfo = class'HideGame.HInformation_Player'
	
	
	/*
	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
	End Object
	*/
	
	SpawnSound=SoundCue'A_Ambient_NonLoops.Thunder.Thunder_Distant_Stereo_01_Cue'
	GroundSpeed=210.0
	CrouchHeight=45
	bStatic = false
	bNoDelete = false
	bCanDoubleJump=false
}