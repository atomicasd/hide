class HPawn_Player extends HPawn;

var     HFamilyInfo_Player      CharacterInfo;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	SetCharacterClassFromInfo(class'HFamilyInfo_Player');
	CharacterInfo = HFamilyInfo_Player( new HCharacterInfo );
	SetCharacterClassInformation(CharacterInfo);
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
	case Idle:  soundRadius=170;  break;
	case Sneak: soundRadius=200;  break;
	case Walk:  soundRadius=400;  break;
	case Run:   soundRadius=500; break;
	}

	foreach OverlappingActors(class'HPawn_Monster', target, soundRadius)
	{
		soundSpot = Spawn(class'HSoundSpot',,, Location,,, true);
		target.OnSoundHeard(soundSpot);
	}
}

defaultproperties
{
	InventoryManagerClass = None
	HCharacterInfo = class'HideGame.HFamilyInfo_Player'

	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		HiddenGame=true
	End Object

	Components.Add(NPCMesh0);
	
	GroundSpeed=200.0
	CrouchHeight=45
	bStatic = false
	bNoDelete = false
	bCanDoubleJump=false
}