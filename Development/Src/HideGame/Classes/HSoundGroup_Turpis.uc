class HSoundGroup_Turpis extends HSoundGroup_Character;

static function SoundCue GetFootstepSound(int FootDown, name MaterialType)
{
	`Log("turpis Step");
	return super.GetFootstepSound(FootDown, MaterialType);
}

DefaultProperties
{
}
