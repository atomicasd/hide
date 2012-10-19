class HSoundGroup_Turpis extends HSoundGroup_Character;

/*
 * Structs for SoundArrays
 */
struct HBreathingSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

struct HHissingSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

struct HInvestigateSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

struct HScreamSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

struct HFootstepSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

/*
 * Arrays that cointains the different sounds.
 */
var Array<HBreathingSoundInfo> HBreathingSounds;

var Array<HHissingSoundInfo> HHissingSounds;

var Array<HInvestigateSoundInfo> HInvestigateSounds;

var Array<HScreamSoundInfo> HScreamSounds;

var Array<HFootstepSoundInfo> HFootstepSounds;

/*
 * Functions that return or play soundCues
 */
static function SoundCue GetFootstepSound(int FootDown, name MaterialType)
{
	local int i;

	i = Rand(default.HFootstepSounds.Length);

	return default.HFootstepSounds[i].Sound;
}

static function SoundCue GetHHissingSound()
{
	local int i;

	i = Rand(default.HHissingSounds.Length);

	return default.HHissingSounds[i].Sound;
}

DefaultProperties
{
	//HFootstepSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.turpis.turpisStep01_Cue');
	//HFootstepSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.turpis.turpisStep02_Cue');
	//HFootstepSounds[0]=(Type=2, Sound=SoundCue'SoundPackage.turpis.turpisStep03_Cue');
	
	HFootstepSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.obesus.obesusStep01_Cue');
	HFootstepSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.obesus.obesusStep02_Cue');
	HFootstepSounds[2]=(Type=2, Sound=SoundCue'SoundPackage.obesus.obesusStep03_Cue');

	HBreathingSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.turpis.turpisChaseBreathing01_Cue');
	HBreathingSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.turpis.turpisHeavyBreathing01_Cue');
	HBreathingSounds[2]=(Type=2, Sound=SoundCue'SoundPackage.turpis.turpisHeavyBreathing02_Cue');

	HHissingSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.turpis.turpisHissing01_Cue');
	//HHissingSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.turpis.turpisHissing02_Cue');

	HInvestigateSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.turpis.turpisInvestigate01_Cue');
	HInvestigateSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.turpis.turpisInvestigate02_Cue');

	HScreamSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.turpis.turpisScream01_Cue');
	HScreamSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.turpis.turpisScream02_Cue');
	HScreamSounds[2]=(Type=2, Sound=SoundCue'SoundPackage.turpis.turpisScream03_Cue');
}
