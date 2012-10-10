class HFamilyInfo_Obesus extends HFamilyInfo_Character;

DefaultProperties
{
	SoundGroupClass=class'HSoundGroup_Obesus'
	
	HAnimSet(0) = AnimSet'MonsterPackage.Anims.ObesusAnims'
	HPhysicsAsset = PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
	HSkeletalMesh = SkeletalMesh'MonsterPackage.ObesusRiggedQuick'
	HAnimTreeTemplate = AnimTree'MonsterPackage.Anims.ObesusAnimTree'
}
