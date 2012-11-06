class HSoundGroup_Monster extends HSoundGroup_Character;

/*
 * Structs for SoundArrays
 */

struct HAttackSoundInfo
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

var Array<HInvestigateSoundInfo> HInvestigateSounds;

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

DefaultProperties
{
}
