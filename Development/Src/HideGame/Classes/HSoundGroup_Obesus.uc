class HSoundGroup_Obesus extends HSoundGroup_Character;

struct HFootstepSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

struct HAttackSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

struct HLaughterSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

struct HBreathingSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

struct HInvestigateSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

var Array<HFootstepSoundInfo> HFootstepSounds;

var Array<HAttackSoundInfo> HAttackSounds;

var Array<HLaughterSoundInfo> HLaughterSounds;

var Array<HBreathingSoundInfo> HBreathingSounds;

var Array<HInvestigateSoundInfo> HInvestigateSounds;

static function SoundCue GetFootstepSound(int FootDown, name MaterialType)
{
	local int i;

	i = Rand(default.HFootstepSounds.Length);

	return default.HFootstepSounds[i].Sound;
}

static function SoundCue getLaughterSounds()
{
	local int i;

	i = Rand(default.HLaughterSounds.Length);

	return default.HAttackSounds[i].Sound;
}

static function SoundCue getInvestigateSounds()
{
	local int i;

	i = Rand(default.HInvestigateSounds.Length);

	return default.HInvestigateSounds[i].Sound;
}

static function SoundCue getAttackSounds()
{
	local int i;

	i = Rand(default.HAttackSounds.Length);

	return default.HAttackSounds[i].Sound;
}

static function SoundCue getBreathingSound()
{
	local int i;

	i = Rand(default.HBreathingSounds.Length);

	return default.HBreathingSounds[i].Sound;
}

DefaultProperties
{
	HFootstepSounds[0]=(Type=0, Sound=SoundCue'HidePackage.ObesusMonster.obesusStep01_Cue');
	HFootstepSounds[1]=(Type=1, Sound=SoundCue'HidePackage.ObesusMonster.obesusStep02_Cue');
	HFootstepSounds[2]=(Type=2, Sound=SoundCue'HidePackage.ObesusMonster.obesusStep03_Cue');

	HAttackSounds[0]=(Type=0, Sound=SoundCue'HidePackage.ObesusMonster.obesusAttack01_Cue');
	HAttackSounds[1]=(Type=1, Sound=SoundCue'HidePackage.ObesusMonster.obesusAttack02_Cue');
	HAttackSounds[2]=(Type=2, Sound=SoundCue'HidePackage.ObesusMonster.obesusAttack03_Cue');

	HLaughterSounds[0]=(Type=0, Sound=SoundCue'HidePackage.ObesusMonster.obesusLaughter01_Cue');
	HLaughterSounds[1]=(Type=1, Sound=SoundCue'HidePackage.ObesusMonster.obesusLaughter02_Cue');
	HLaughterSounds[2]=(Type=2, Sound=SoundCue'HidePackage.ObesusMonster.obesusLaughter03_Cue');
	HLaughterSounds[3]=(Type=3, Sound=SoundCue'HidePackage.ObesusMonster.obesusLaughter04_Cue');

	HBreathingSounds[0]=(Type=0, Sound=SoundCue'HidePackage.ObesusMonster.obesusBreathing01_Cue');
	HBreathingSounds[1]=(Type=1, Sound=SoundCue'HidePackage.ObesusMonster.obesusBreathing02_Cue');
	HBreathingSounds[2]=(Type=2, Sound=SoundCue'HidePackage.ObesusMonster.obesusBreathing03_Cue');
	HBreathingSounds[3]=(Type=3, Sound=SoundCue'HidePackage.ObesusMonster.obesusBreathing04_Cue');

	HInvestigateSounds[0]=(Type=0, Sound=SoundCue'HidePackage.ObesusMonster.obesusInvestigate01_Cue');
	HInvestigateSounds[1]=(Type=1, Sound=SoundCue'HidePackage.ObesusMonster.obesusInvestigate02_Cue');
}
