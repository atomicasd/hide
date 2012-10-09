class HSoundGroup_Obesus extends HSoundGroup_Character;

static function SoundCue GetFootstepSound(int FootDown, name MaterialType)
{
	`Log("Obesus Step");
	return super.GetFootstepSound(FootDown, MaterialType);
}

static function PlayJumpSound(Pawn P)
{
	`Log("Obesus jump");
	P.PlaySound(Default.DefaultJumpingSound, false, true);
}

DefaultProperties
{
}
