class HSoundGroup_Player extends HSoundGroup_Character;

var bool bSkipSoundStep;

struct HJumpingSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

var array<HJumpingSoundInfo> HJumpSounds;

static function SoundCue GetJumpSound(name MaterialType)
{
	local int i;

	i = Rand(3);

	return default.HJumpSounds[i].Sound;
}

DefaultProperties
{
	HFootstepSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.Player.playerStep02_Cue');
	HFootstepSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.Player.playerStep03_Cue');
	HFootstepSounds[2]=(Type=2, Sound=SoundCue'SoundPackage.Player.playerStep06_Cue');

	HSneakFootstepSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.Player.playerStepSneak02_Cue');
	HSneakFootstepSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.Player.playerStepSneak03_Cue');
	HSneakFootstepSounds[2]=(Type=2, Sound=SoundCue'SoundPackage.Player.playerStepSneak06_Cue');

	HJumpSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.Player.playerJump01_Cue');
	HJumpSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.Player.playerJump02_Cue');
	HJumpSounds[2]=(Type=2, Sound=SoundCue'SoundPackage.Player.playerJump03_Cue');
}
