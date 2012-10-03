class HPawn_Monster extends HPawn;

var     HAIController           MyController;
var     AnimNodeSequence        MyAnimPlayControl;
var     class<HInformation_Monster>  HCharacterInfo;

var     bool                    AttAcking;
var     bool                    bplayed;
var     Name                    AnimSetName;

var()       array<NavigationPoint>  MyNavigationPoints;
var(NPC)    SkeletalMeshComponent   NPCMesh;
var(NPC)    class<AIController>     NPCController;

function OnSoundHeard( HSoundSpot spot )
{
	MyController.OnSoundHeard( spot );
}

function SetAttacking(bool atacar)
{
	AttAcking = atacar;
}

function Tick(Float Delta)
{
	local HPawn_Player victim;
	foreach self.OverlappingActors(class'HPawn_Player', victim, 40)
	{
		victim.KillYourself();
	}
}

DefaultProperties
{
    Begin Object Name=CollisionCylinder
        CollisionHeight=+44.000000
    End Object

	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		//SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
		//PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		//AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		//AnimtreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
	End Object

	NPCMesh=NPCMesh0
	Components.Add(NPCMesh0)
 
    bJumpCapable=false
    bCanJump=false
 
    GroundSpeed=200.0
	PeripheralVision = 0.7

}