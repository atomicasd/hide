class HPawn_Nervorum extends HPawn_Monster
	placeable;

// Nerves
var array<HNervorum_GroundNerve>    ChildNerves;
var bool                            bTraceNerves;   
var HVolume_Nervorum                vol;           

// Character info
var HFamilyInfo_Nervorum            CharacterInfo;

// Sound
var HSoundGroup_Nervorum            HSoundGroup;

simulated function PostBeginPlay()
{
	local HNervorum_GroundNerve nerve;

	super.PostBeginPlay();

	SetPhysics(PHYS_Walking); 
	if(ControllerClass == none)
	{
		//set the existing ControllerClass to our new NPCController class
		ControllerClass = class'HideGame.HAIController_Nervorum';
	}
	
	// Setting PlayerInfo
	HSetCharacterClassFromInfo(class'HFamilyInfo_Nervorum');

	// Sets soundgroup
	HSoundGroup = HSoundGroup_Nervorum(new SoundGroupClass);

	// Find the nerves on the ground
	foreach OverlappingActors(class'HNervorum_GroundNerve', nerve, 60)
	{
		`log("---->Adding nerve<----");
		ChildNerves.AddItem(nerve);
		nerve.bAlreadyOwned = true;
		nerve.findChildNerves();
	}

	// Spawns a collision cylinder to check when player is close.
	// We do not want to trace when player is not close
	vol = Spawn(class'HVolume_Nervorum', self,, Location,,, true);
	vol.SetOwner(self);
}

/*
 * Updates the nerve on the ground and checks collision
 */
event Tick(float DeltaTime)
{
	local int i;

	if(bTraceNerves)
	{
		`Log("Trace");
		for(i = 0; i < ChildNerves.Length; i++)
		{
			if(ChildNerves[i].CheckCollision())
				`log("Collide");
			if(ChildNerves[i].ChildCollision())
				`log("Child collide");
		}
	}
}

DefaultProperties
{
	ControllerClass = class'HideGame.HAIController_Nervorum'
	HCharacterInfo = class'HideGame.HFamilyInfo_Nervorum'
	
	Begin Object Class=SkeletalMeshComponent Name=NPCMesh0
		SkeletalMesh=SkeletalMesh'MonsterPackage.ObesusRiggedQuick'
		HiddenGame=true
	End Object

	bTraceNerves=false
	
	NPCMesh=NPCMesh0
	Components.Add(NPCMesh0)
}
