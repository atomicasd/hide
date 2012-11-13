class HSoundGroup_Character extends UTPawnSoundGroup;

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

var Array<HFootstepSoundInfo> HFootstepSounds;

var array<HSneakFootstepSoundInfo> HSneakFootstepSounds;

static function SoundCue GetSneakFootstepSound(int FootDown, name MaterialType)
{
	local int i;

	i = Rand(default.HSneakFootstepSounds.Length);

	return default.HSneakFootstepSounds[i].Sound;
}

static function SoundCue GetFootstepSound(int FootDown, name MaterialType)
{
	local int i;
	`log("Foot");
	if(FootDown == 0){
		return GetSneakFootstepSound(FootDown, MaterialType);
	}else{
		i = Rand(default.HFootstepSounds.Length);

		return default.HFootstepSounds[i].Sound;
	}
}

DefaultProperties
{
	DefaultLandingSound=SoundCue'SoundPackage.Enviroment.Silence_Cue'
	DyingSound=SoundCue'SoundPackage.Enviroment.Silence_Cue'
	GibSound=SoundCue'SoundPackage.Enviroment.Silence_Cue'
}
