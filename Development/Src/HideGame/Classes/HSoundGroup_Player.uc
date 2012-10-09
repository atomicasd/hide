class HSoundGroup_Player extends HSoundGroup_Character;

static function SoundCue GetFootstepSound(int FootDown, name MaterialType)
{
	`Log("player Step: "$MaterialType);
	return super.GetFootstepSound(FootDown, MaterialType);
}

DefaultProperties
{
}
