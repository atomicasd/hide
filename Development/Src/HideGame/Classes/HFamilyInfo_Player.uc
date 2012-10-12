class HFamilyInfo_Player extends HFamilyInfo_Character;

DefaultProperties
{
	// Sound
	SoundGroupClass=class'HSoundGroup_Player'

	// Mesh and physical assets
	PhysAsset = PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
	CharacterMesh = SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'

	// Animation asstes
	HAnimSet(0) = AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
	HAnimTreeTemplate = AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
}
