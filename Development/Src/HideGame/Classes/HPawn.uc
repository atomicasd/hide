class HPawn extends UTPawn;

var     class<HFamilyInfo_Character>    HCharacterInfo;
var     HPlayerController               HPlayer;

// Sounds
var     class<HSoundGroup_Character>    SoundGroup;
var     HSoundGroup_Character           HSoundGroup;
var     array<SoundCue>                 IdleSounds;
var     AudioComponent                  IdleSound;

simulated function PostBeginPlay()
{
	local HPlayerController HPC;

	super.PostBeginPlay();
	
	ForEach WorldInfo.AllControllers(class'HPlayerController', HPC)
	{
		HPlayer=HPC;
	}
}

/*
 * Removing abilities by overriding.
 */

function bool Dodge(eDoubleClickDir DoubleClickMove){return false;}
function PlayTeleportEffect(bool bOut, bool bSound){}
function DoDoubleJump( bool bUpdating ) {}

/*
 * Sets CharacterInfo for pawn
 */
function HSetCharacterClassFromInfo(class<HFamilyInfo_Character> HInfo)
{
	SetCharacterClassFromInfo(HInfo);

	if(HInfo != None)
	{
		Mesh.AnimSets = HInfo.default.HAnimSet;
		Mesh.SetAnimTreeTemplate(HInfo.default.HAnimTreeTemplate);
		
	}else{
		`Log("---->Pawns information class not set <----");
	}
}	


/**
 * Sound functions
 **/
function playIdleSound()
{
	if(IdleSound == None)
		newIdleSound(getIdleSound());
	else
		IdleSound.SoundCue = getIdleSound();

	IdleSound.Play();
}

function stopIdleSound()
{
	if(IdleSound != None)
		IdleSound.Stop();
}

function newIdleSound(SoundCue Sound)
{
	IdleSound = CreateAudioComponent(Sound, false, false, true,, true);
}

/**
 * Sound list
 */
function SoundCue getIdleSound()
{
	local int i;

	i = rand(IdleSounds.Length);

	return IdleSounds[i];
}

function addIdleSound(SoundCue Sound)
{
	IdleSounds.AddItem(Sound);
}

/**
 * Spesific sound
 */
function HPlaySoundEffect(SoundCue SoundToPlay)
{
	stopIdleSound();

	if(SoundToPlay != None)
	{
		PlaySound(SoundToPlay,false, true,,,true);
	}
}

simulated function PlayAttackSound()
{
	//HPlaySoundEffect(HSoundGroup.static.getAttackSounds());
}

DefaultProperties
{
	MaxMultiJump=0
	MultiJumpRemaining=0
	bCanCrouch=true
	IdleSounds[0] = SoundCue'SoundPackage.Enviroment.Silence_Cue'

	SoundGroup = class'HSoundGroup_Character'
}
