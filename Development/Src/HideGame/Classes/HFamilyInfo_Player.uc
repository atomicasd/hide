class HFamilyInfo_Player extends HFamilyInfo_Character;

DefaultProperties
{
	// Sound
	SoundGroupClass=class'HSoundGroup_Player'

	// Mesh and physical assets
	//PhysAsset = PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
	//CharacterMesh = SkeletalMesh'PlayerPackage.HG_PLayer_ArmRight01'

	// Animation asstes
	HAnimSet(0) = AnimSet'PlayerPackage.animation.PlayerArmAnimSet'
	HAnimTreeTemplate = AnimTree'PlayerPackage.animation.PlayerArmTree'
}
