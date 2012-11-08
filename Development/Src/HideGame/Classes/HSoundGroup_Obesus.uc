class HSoundGroup_Obesus extends HSoundGroup_Monster;


struct HLaughterSoundInfo
{
	var int Type;
	var SoundCue Sound;
};

var Array<HLaughterSoundInfo> HLaughterSounds;

static function SoundCue getLaughterSounds()
{
	local int i;

	i = Rand(default.HLaughterSounds.Length);

	return default.HLaughterSounds[i].Sound;
}

DefaultProperties
{
	HFootstepSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.obesus.obesusStep01_Cue');
	HFootstepSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.obesus.obesusStep02_Cue');
	HFootstepSounds[2]=(Type=2, Sound=SoundCue'SoundPackage.obesus.obesusStep03_Cue');

	HSneakFootstepSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.obesus.obesusStep01_Cue');
	HSneakFootstepSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.obesus.obesusStep01_Cue');
	HSneakFootstepSounds[2]=(Type=2, Sound=SoundCue'SoundPackage.obesus.obesusStep01_Cue');

	HAttackSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.obesus.obesusAttack01_Cue');
	HAttackSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.obesus.obesusAttack02_Cue');
	HAttackSounds[2]=(Type=2, Sound=SoundCue'SoundPackage.obesus.obesusAttack03_Cue');

	HLaughterSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.obesus.obesusLaughter01_Cue');
	HLaughterSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.obesus.obesusLaughter02_Cue');
	HLaughterSounds[2]=(Type=2, Sound=SoundCue'SoundPackage.obesus.obesusLaughter03_Cue');
	HLaughterSounds[3]=(Type=3, Sound=SoundCue'SoundPackage.obesus.obesusLaughter04_Cue');

	HInvestigateSounds[0]=(Type=0, Sound=SoundCue'SoundPackage.obesus.obesusInvestigate01_Cue');
	HInvestigateSounds[1]=(Type=1, Sound=SoundCue'SoundPackage.obesus.obesusInvestigate02_Cue');
}
