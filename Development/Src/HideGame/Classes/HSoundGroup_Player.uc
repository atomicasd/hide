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

struct HSneakFootstepSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

var array<HJumpingSoundInfo> HJumpSounds;

var array<HFootstepSoundInfo> HFootstepSounds;

var array<HSneakFootstepSoundInfo> HSneakFootstepSounds;

static function SoundCue GetFootstepSound(int FootDown, name MaterialType)
{
	local int i;
	if(FootDown == 0){
		return GetSneakFootstepSound(FootDown, MaterialType);
	}

	i = Rand(default.HFootstepSounds.Length);

	return default.HFootstepSounds[i].Sound;
}

static function SoundCue GetSneakFootstepSound(int FootDown, name MaterialType)
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

	HSneakFootstepSounds[0]=(Type=0, Sound=SoundCue'HidePackage.HPlayerSounds.playerStepSneak02_Cue');
	HSneakFootstepSounds[1]=(Type=1, Sound=SoundCue'HidePackage.HPlayerSounds.playerStepSneak03_Cue');
	HSneakFootstepSounds[2]=(Type=2, Sound=SoundCue'HidePackage.HPlayerSounds.playerStepSneak06_Cue');

	HJumpSounds[0]=(Type=0, Sound=SoundCue'HidePackage.HPlayerSounds.playerJump01_Cue');
	HJumpSounds[1]=(Type=1, Sound=SoundCue'HidePackage.HPlayerSounds.playerJump02_Cue');
	HJumpSounds[2]=(Type=2, Sound=SoundCue'HidePackage.HPlayerSounds.playerJump03_Cue');
}
