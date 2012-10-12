class HFamilyInfo_Turpis extends HFamilyInfo_Character;

DefaultProperties
{
	// Sound
	SoundGroupClass=class'HSoundGroup_Turpis'

	// Mesh and physical assets
	PhysAsset = PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
	CharacterMesh = SkeletalMesh'MonsterPackage.TurpisRiggedQuick'

	// Animation asstes
	HAnimSet(0) = AnimSet'MonsterPackage.Anims.TurpisAnims'
	HAnimTreeTemplate = AnimTree'MonsterPackage.Anims.TurpisAnimTree'
}
