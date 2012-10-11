class HFamilyInfo_Obesus extends HFamilyInfo_Character;

DefaultProperties
{
	// Sound
	SoundGroupClass=class'HSoundGroup_Obesus'
	
	// Mesh and physical assets
	PhysAsset = PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
	CharacterMesh = SkeletalMesh'MonsterPackage.ObesusRiggedQuick'

	// Animation asstes
	HAnimSet(0) = AnimSet'MonsterPackage.Anims.ObesusAnims'
	HAnimTreeTemplate = AnimTree'MonsterPackage.Anims.ObesusAnimTree'
}
