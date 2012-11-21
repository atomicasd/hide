class HFamilyInfo_Turpis extends HFamilyInfo_Character;

DefaultProperties
{
	// Sound
	SoundGroupClass=class'HSoundGroup_Turpis'

	// Mesh and physical assets
	PhysAsset = PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
	CharacterMesh = SkeletalMesh'MonsterPackage.HG_Monsters_Turpis_SkeletalMesh01'

	// Animation asstes
	HAnimSet(0) = AnimSet'MonsterPackage.Anims.TurpisAnimSet'
	HAnimTreeTemplate = AnimTree'MonsterPackage.Anims.TurpisAnimTree'
}
