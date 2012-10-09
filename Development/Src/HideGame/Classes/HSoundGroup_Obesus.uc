class HSoundGroup_Obesus extends HSoundGroup_Character;

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

var Array<HAttackSoundInfo> HAttackSounds;

var Array<HLaughterSoundInfo> HLaughterSounds;

var Array<HBreathingSoundInfo> HBreathingSounds;

var Array<HInvestigateSoundInfo> HInvestigateSounds;

static function SoundCue getBreathingSound()
{
	local int i;

	i = Rand(3);

	`log("Breathing sound: " $i);

	return default.HBreathingSounds[i].Sound;
}

static function SoundCue GetFootstepSound(int FootDown, name MaterialType)
{
	return super.GetFootstepSound(FootDown, MaterialType);
}

DefaultProperties
{
	HAttackSounds[0]=(Type=0, Sound=SoundCue'HidePackage.HObesusSounds.obesusAttack01_Cue');
	HAttackSounds[1]=(Type=1, Sound=SoundCue'HidePackage.HObesusSounds.obesusAttack02_Cue');
	HAttackSounds[2]=(Type=2, Sound=SoundCue'HidePackage.HObesusSounds.obesusAttack03_Cue');

	HLaughterSounds[0]=(Type=0, Sound=SoundCue'HidePackage.HObesusSounds.obesusLaughter01_Cue');
	HLaughterSounds[1]=(Type=1, Sound=SoundCue'HidePackage.HObesusSounds.obesusLaughter02_Cue');
	HLaughterSounds[2]=(Type=2, Sound=SoundCue'HidePackage.HObesusSounds.obesusLaughter03_Cue');
	HLaughterSounds[3]=(Type=3, Sound=SoundCue'HidePackage.HObesusSounds.obesusLaughter04_Cue');

	HBreathingSounds[0]=(Type=0, Sound=SoundCue'HidePackage.HObesusSounds.obesusBreathing01_Cue');
	HBreathingSounds[1]=(Type=1, Sound=SoundCue'HidePackage.HObesusSounds.obesusBreathing02_Cue');
	HBreathingSounds[2]=(Type=2, Sound=SoundCue'HidePackage.HObesusSounds.obesusBreathing03_Cue');
	HBreathingSounds[3]=(Type=3, Sound=SoundCue'HidePackage.HObesusSounds.obesusBreathing04_Cue');

	HInvestigateSounds[0]=(Type=0, Sound=SoundCue'HidePackage.HObesusSounds.obesusInvestigate01_Cue');
	HInvestigateSounds[1]=(Type=1, Sound=SoundCue'HidePackage.HObesusSounds.obesusInvestigate02_Cue');
}
