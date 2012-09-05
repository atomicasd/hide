class StealthDeadBodyClone extends Pawn;

var SkeletalMeshComponent DeadBodyClone;

function PostBeginPlay()
{
	super.PostBeginPlay();

	SetDyingPhysics();
}

DefaultProperties
{
	Begin Object Class=SkeletalMeshComponent Name=DeadBodyClone0
		SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		AnimtreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
	End Object
	
	
	Mesh=DeadBodyClone0
	bBlockActors=false
	bBlocksNavigation=false
	bBlocksTeleport=false
	bPlayedDeath=true

	Components.Add(DeadBodyClone0)
}
