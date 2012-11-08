class HFamilyInfo_Tactus extends HFamilyInfo_Character;

DefaultProperties
{
	// Sound
	SoundGroupClass=class'HSoundGroup_Obesus'
	
	// Mesh and physical assets
	PhysAsset = PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
	CharacterMesh = SkeletalMesh'MonsterPackage.HG_Monsters_Tactus_SkeletalMesh01'

	// Animation asstes
	HAnimSet(0) = AnimSet'MonsterPackage.Anims.TactusAnimFinal'
	HAnimTreeTemplate = AnimTree'MonsterPackage.Anims.TactusAnimTree'
}
