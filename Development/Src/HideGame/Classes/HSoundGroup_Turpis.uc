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

DefaultProperties
{
	//HFootstepSounds[0]=(Type=0, Sound=SoundCue'HidePackage.TurpisMonster.turpisStep01_Cue');
	//HFootstepSounds[1]=(Type=1, Sound=SoundCue'HidePackage.TurpisMonster.turpisStep02_Cue');
	//HFootstepSounds[0]=(Type=2, Sound=SoundCue'HidePackage.TurpisMonster.turpisStep03_Cue');
	
	HFootstepSounds[0]=(Type=0, Sound=SoundCue'HidePackage.ObesusMonster.obesusStep01_Cue');
	HFootstepSounds[1]=(Type=1, Sound=SoundCue'HidePackage.ObesusMonster.obesusStep02_Cue');
	HFootstepSounds[2]=(Type=2, Sound=SoundCue'HidePackage.ObesusMonster.obesusStep03_Cue');

	HBreathingSounds[0]=(Type=0, Sound=SoundCue'HidePackage.TurpisMonster.turpisChaseBreathing01_Cue');
	HBreathingSounds[1]=(Type=1, Sound=SoundCue'HidePackage.TurpisMonster.turpisHeavyBreathing01_Cue');
	HBreathingSounds[2]=(Type=2, Sound=SoundCue'HidePackage.TurpisMonster.turpisHeavyBreathing02_Cue');

	HHissingSounds[0]=(Type=0, Sound=SoundCue'HidePackage.TurpisMonster.turpisHissing01_Cue');
	HHissingSounds[1]=(Type=1, Sound=SoundCue'HidePackage.TurpisMonster.turpisHissing02_Cue');

	HInvestigateSounds[0]=(Type=0, Sound=SoundCue'HidePackage.TurpisMonster.turpisInvestigate01_Cue');
	HInvestigateSounds[1]=(Type=1, Sound=SoundCue'HidePackage.TurpisMonster.turpisInvestigate02_Cue');

	HScreamSounds[0]=(Type=0, Sound=SoundCue'HidePackage.TurpisMonster.turpisScream01_Cue');
	HScreamSounds[1]=(Type=1, Sound=SoundCue'HidePackage.TurpisMonster.turpisScream02_Cue');
	HScreamSounds[2]=(Type=2, Sound=SoundCue'HidePackage.TurpisMonster.turpisScream03_Cue');
}
