class HSoundGroup_Character extends UTPawnSoundGroup;

var Array<SoundCue> HFootstepSounds;

var array<SoundCue> HSneakFootstepSounds;

var Array<SoundCue> HAttackSounds;

var Array<SoundCue> HInvestigateSounds;

var Array<SoundCue> HJumpSounds;

static function SoundCue GetJumpSound(name MaterialType)
{
	local int i;

	i = Rand(default.HJumpSounds.Length);

	return default.HJumpSounds[i];
}

static function SoundCue getInvestigateSounds()
{
	local int i;

	i = Rand(default.HInvestigateSounds.Length);

	return default.HInvestigateSounds[i];
}

static function SoundCue getAttackSounds()
{
	local int i;

	i = Rand(default.HAttackSounds.Length);

	return default.HAttackSounds[i];
}

static function SoundCue GetSneakFootstepSound(int FootDown, name MaterialType)
{
	local int i;

	i = Rand(default.HSneakFootstepSounds.Length);

	return default.HSneakFootstepSounds[i];
}

static function SoundCue GetFootstepSound(int FootDown, name MaterialType)
{
	local int i;
	if(FootDown == 0){
		return GetSneakFootstepSound(FootDown, MaterialType);
	}else{
		i = Rand(default.HFootstepSounds.Length);

		return default.HFootstepSounds[i];
	}
}

DefaultProperties
{
	DefaultLandingSound=SoundCue'SoundPackage.Enviroment.Silence_Cue'
	DyingSound=SoundCue'SoundPackage.Enviroment.Silence_Cue'
	GibSound=SoundCue'SoundPackage.Enviroment.Silence_Cue'

	HSneakFootstepSounds[0] = SoundCue'SoundPackage.Enviroment.Silence_Cue'
}
