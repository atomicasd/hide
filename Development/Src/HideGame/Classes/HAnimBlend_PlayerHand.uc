class HAnimBlend_PlayerHand extends UTAnimBlendBase;

enum HandState
{
	HS_IDLE,
	HS_ACTIVATE,
	HS_DURING,
	HS_DEACTIVATE,
	HS_PRESSBUTTON,
	HS_SPAWNED
};

var HandState HHandState;

simulated function SetAnimState(HandState state)
{
	HHandState = state;
	SetActiveChild(state, BlendTime);
}

function HandState HGetStateName()
{
	return HHandState;
}

DefaultProperties
{
	Children(0)=(Name="Idle")
	Children(1)=(Name="Activate")
	Children(2)=(Name="During")
	Children(3)=(Name="Deactivate")
	Children(4)=(Name="PressButton")
	Children(5)=(Name="Spawned")

	ChildBlendTimes[0]=22.9
	ChildBlendTimes[1]=2.8
	ChildBlendTimes[3]=1.3667
	ChildBlendTimes[4]=2
	ChildBlendTimes[5]=9.0667
}
