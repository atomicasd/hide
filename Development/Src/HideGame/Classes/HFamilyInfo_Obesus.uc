class HFamilyInfo_Obesus extends HFamilyInfo_Character;

DefaultProperties
{
	// Sound
	SoundGroupClass=class'HSoundGroup_Obesus'
	
	// Mesh and physical assets
	PhysAsset = PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
	CharacterMesh = SkeletalMesh'MonsterPackage.HG_Monsters_Obesus_SkeletalMesh01'
	// Animation asstes
	HAnimSet(0) = AnimSet'MonsterPackage.Anims.ObesusAnimSet'
	HAnimTreeTemplate = AnimTree'MonsterPackage.Anims.ObesusAnimTree'
	
}
