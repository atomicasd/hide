class HSoundGroup_Player extends HSoundGroup_Character;

struct HJumpingSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

var array<HJumpingSoundInfo> HJumpSounds;

static function SoundCue GetFootstepSound(int FootDown, name MaterialType)
{
	return super.GetFootstepSound(FootDown, MaterialType);
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
	HJumpSounds[0]=(Type=0, Sound=SoundCue'HidePackage.HPlayerSounds.playerJump01_Cue');
	HJumpSounds[1]=(Type=1, Sound=SoundCue'HidePackage.HPlayerSounds.playerJump02_Cue');
	HJumpSounds[2]=(Type=2, Sound=SoundCue'HidePackage.HPlayerSounds.playerJump03_Cue');
}
