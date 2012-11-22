class HFamilyInfo_Player extends HFamilyInfo_Character;

DefaultProperties
{
	// Sound
	SoundGroupClass=class'HSoundGroup_Player'

	// Mesh and physical assets
	//PhysAsset = PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
	CharacterMesh = SkeletalMesh'PlayerPackage.HG_Player_JunkBoneBox01'

	HAnimSet(0) = AnimSet'PlayerPackage.animation.JunkBox'
	HAnimTreeTemplate = AnimTree'PlayerPackage.animation.JunkTree'

	// Animation asstes
	HArmAnimSet(0) = AnimSet'PlayerPackage.animation.PlayerArmAnimSet'
	HArmAnimTreeTemplate = AnimTree'PlayerPackage.animation.PlayerArmTree'
}
