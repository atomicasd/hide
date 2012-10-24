class HPawn_Player extends HPawn;

var     HFamilyInfo_Player      CharacterInfo;
var     HSoundBeacon            soundBeacon;
var     int                     waitSoundStep;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	// Sets the FamilyInfo
	HSetCharacterClassFromInfo(class'HFamilyInfo_Player');

	// Creates players SoundBeacon
	soundBeacon = Spawn(class'HSoundBeacon',,, Location,,, true);
	soundBeacon.bIsPlayerSpawned=true;
}

simulated event ActuallyPlayFootStepSound(int FootDown)
{
	local int skipSteps;
	switch(HPlayerController(Controller).WalkState)
	{
	case Idle: skipSteps=0; break;
	case Walk: skipSteps=1; break;
	case Sneak: skipSteps=2; break;
	case Run: skipSteps=0; break;
	}
	if(waitSoundStep < skipSteps){
		waitSoundStep++;
	}else{
		waitSoundStep=0;
		if(HPlayerController(Controller).WalkState == Sneak)
			super.ActuallyPlayFootStepSound(0);
		else
			super.ActuallyPlayFootStepSound(1);
	}
}

function bool Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	soundBeacon.bIsPlayerDead=true;
	return super.Died(Killer, damageType, HitLocation);
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
	soundBeacon.bIsPlayerDead=false;
}

exec function KillYourself()
{
	Suicide();
}

/*
 * Spawnes the soundBeacon
 */
event Tick(float TimeDelta)
{
	local int soundRadius;

	switch(HPlayer.WalkState)   
	{
	case Idle:  soundRadius=160;  break;
	case Sneak: soundRadius=200;  break;
	case Walk:  soundRadius=400;  break;
	case Run:   soundRadius=500; break;
	}
	
	soundBeacon.SetLocation(Location);
	soundBeacon.Radius=soundRadius;
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
	CrouchHeight=40
	CrouchedPct=+0.65
	bStatic = false
	bNoDelete = false
	bCanDoubleJump=false
}