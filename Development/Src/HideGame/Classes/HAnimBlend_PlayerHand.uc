class HAnimBlend_PlayerHand extends UTAnimBlendBase;

enum HandState
{
	HS_IDLE,
	HS_ACTIVATE,
	HS_DURING,
	HS_DEACTIVATE
};

simulated function SetAnimState(HandState state)
{
	SetActiveChild(state, BlendTime);
}

DefaultProperties
{
	Children(0)=(Name="Idle")
	Children(1)=(Name="Activate")
	Children(2)=(Name="During")
	Children(3)=(Name="Deactivate")
}
