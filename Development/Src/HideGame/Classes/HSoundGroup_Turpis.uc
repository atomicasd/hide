class HSoundGroup_Turpis extends HSoundGroup_Monster;


struct HHissingSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

struct HScreamSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

/*
 * Arrays that cointains the different sounds.
 */

var Array<HHissingSoundInfo> HHissingSounds;

var Array<HScreamSoundInfo> HScreamSounds;


/*
 * Functions that return or play soundCues
 */

static function SoundCue GetHHissingSound()
{
	local int i;

	i = Rand(default.HHissingSounds.Length);

	return default.HHissingSounds[i].Sound;
}

static function SoundCue GetScreamSound()
{
	local int i;

	i = Rand(default.HScreamSounds.Length);

	return default.HScreamSounds[i].Sound;
}

DefaultProperties
{
	//HFootstepSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.turpis.turpisStep01_Cue');
	//HFootstepSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.turpis.turpisStep02_Cue');
	//HFootstepSounds[0]=(Type=2, Sound=SoundCue'SoundPackage.turpis.turpisStep03_Cue');
	
	HFootstepSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.obesus.obesusStep01_Cue');
	HFootstepSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.obesus.obesusStep02_Cue');
	HFootstepSounds[2]=(Type=2, Sound=SoundCue'SoundPackage.obesus.obesusStep03_Cue');

	HSneakFootstepSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.obesus.obesusStep01_Cue');
	HSneakFootstepSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.obesus.obesusStep01_Cue');
	HSneakFootstepSounds[2]=(Type=2, Sound=SoundCue'SoundPackage.obesus.obesusStep01_Cue');

	HHissingSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.turpis.turpisHissing01_Cue');
	//HHissingSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.turpis.turpisHissing02_Cue');

	HInvestigateSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.turpis.turpisInvestigate01_Cue');
	HInvestigateSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.turpis.turpisInvestigate02_Cue');

	HScreamSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.turpis.turpisScream01_Cue');
	HScreamSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.turpis.turpisScream02_Cue');
	HScreamSounds[2]=(Type=2, Sound=SoundCue'SoundPackage.turpis.turpisScream03_Cue');
}
