class HSoundGroup_Player extends HSoundGroup_Character;

var bool bSkipSoundStep;

struct HJumpingSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

struct HFootstepSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

var array<HJumpingSoundInfo> HJumpSounds;

var array<HFootstepSoundInfo> HFootstepSounds;

static function SoundCue GetFootstepSound(int FootDown, name MaterialType)
{
	local int i;

	i = Rand(default.HFootstepSounds.Length);

	return default.HFootstepSounds[i].Sound;
}

static function SoundCue GetJumpSound(name MaterialType)
{
	local int i;

	i = Rand(3);

	`log("Jump sound: " $i);

	return default.HJumpSounds[i].Sound;
}

DefaultProperties
{
	HFootstepSounds[0]=(Type=0, Sound=SoundCue'HidePackage.HPlayerSounds.playerStep02_Cue');
	HFootstepSounds[1]=(Type=1, Sound=SoundCue'HidePackage.HPlayerSounds.playerStep03_Cue');
	HFootstepSounds[2]=(Type=2, Sound=SoundCue'HidePackage.HPlayerSounds.playerStep06_Cue');

	HJumpSounds[0]=(Type=0, Sound=SoundCue'HidePackage.HPlayerSounds.playerJump01_Cue');
	HJumpSounds[1]=(Type=1, Sound=SoundCue'HidePackage.HPlayerSounds.playerJump02_Cue');
	HJumpSounds[2]=(Type=2, Sound=SoundCue'HidePackage.HPlayerSounds.playerJump03_Cue');
}
