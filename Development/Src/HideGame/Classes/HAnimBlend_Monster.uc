class HAnimBlend_Monster extends UTAnimBlendBase;

enum MonsterState
{
	MS_Idle,
	MS_Walk,
	MS_Investigate, 
	MS_Run,
	MS_Kill 
};

simulated function SetAnimState(MonsterState state)    
{
	SetActiveChild(state, BlendTime);
}

DefaultProperties
{
	Children(0)=(Name="Idle")
	Children(1)=(Name="Walk")
	Children(2)=(Name="Investigate")
	Children(3)=(Name="Run")
	Children(4)=(Name="Kill")
	bFixNumChildren=true
}
