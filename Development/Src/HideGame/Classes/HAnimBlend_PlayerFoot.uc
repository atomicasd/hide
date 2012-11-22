class HAnimBlend_PlayerFoot extends UTAnimBlendBase;

enum FootState
{
	FS_Walk,
	FS_Sneak,
	FS_Run
};

var FootState HFootState;

simulated function SetAnimState(FootState state)
{
	SetActiveChild(state, BlendTime);
}

DefaultProperties
{
	Children(0)=(Name="Walk")
	Children(1)=(Name="Sneak")
	Children(2)=(Name="Run")

	BlendTime=1
}

