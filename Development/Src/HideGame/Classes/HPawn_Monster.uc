class HPawn_Monster extends HPawn;

// Default position
var     Vector                  startingPosition;
var     Rotator                 startingRotation;

// Controller
var     HAIController           MyController;
var     AnimNodeSequence        MyAnimPlayControl;

// Animation
var array<HAnimBlend_Monster>   HAnimBlend;

// Sound
var array<SoundCue>             IdleSounds;
var AudioComponent              IdleSound;
var bool                        bAttackSound;

// Variables
var     bool                    AttAcking;
var     bool                    bplayed;
var     Name                    AnimSetName;

// AI
var()       array<NavigationPoint>  MyNavigationPoints;
var(NPC)    class<AIController>     NPCController;

// kismet variable
var ()  float       PawnGroundSpeed;
var ()  float       waitAtNode;

var     bool        killPlayerOnTouch;

simulated function PostBeginPlay()
{
	// Default position
	startingPosition = Location;
	startingRotation = Rotation;

	super.PostBeginPlay();
}

function OnSoundHeard( HSoundSpot spot )
{
	HAIController(Controller).OnSoundHeard( spot );
}

function SetAttacking(bool atacar)
{
	AttAcking = atacar;
}

event Tick(Float DeltaTime)
{
	local HPawn_Player victim;
	local HCamera pCamera;

	if( killPlayerOnTouch )
	{
		foreach self.OverlappingActors(class'HPawn_Player', victim, 50)
		{
			if(!bAttackSound){
				PlayAttackSound();
				bAttackSound=true;
			}
			victim.KillYourself();

			pCamera = HCamera( HPlayerController( GetALocalPlayerController() ).PlayerCamera);
			pCamera.FadeToBlack( 0.5 );
		}
	}
	//`log("Location: " $Location);

	if(MyController.GetStateName() == 'Idle')
	{
		if(!IdleSound.IsPlaying())
		{
			playIdleSound();
			bAttackSound=false;
		}
	}
}


// Resets the position of the monster and its default path
event Reset()
{
	super.Reset();
	MyController = HAIController(Controller);

	SetLocation(startingPosition);
	SetRotation(startingRotation);

	MyController.actual_node = 0;
	MyController.last_node = 0;
	MyController.GotoState('Idle');
}

/**
 * Animation
 */

// Initialize the animtree
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	local HAnimBlend_Monster BlendState;

	super.PostInitAnimTree(SkelComp);

	if(SkelComp == Mesh)
	{
		foreach mesh.AllAnimNodes(class'HAnimBlend_Monster', BlendState)
		{
			HAnimBlend[HAnimBlend.Length] = BlendState;
		}
	}
}

// Sets what animation we want to play
simulated event SetAnimState(MonsterState stateAnimType)
{
	local int i;

	for ( i = 0; i < HAnimBlend.Length; i++)
	{
		HAnimBlend[i].SetAnimState(stateAnimType);
	}
}

/**
 * Sound functions
 **/
function playIdleSound()
{
	if(IdleSound == None)
		newIdleSound(getIdleSound());
	else
		IdleSound.SoundCue = getIdleSound();

	IdleSound.Play();
}

function stopIdleSound()
{
	if(IdleSound != None)
		IdleSound.Stop();
	`log("Stop sound");
}

function newIdleSound(SoundCue Sound)
{
	IdleSound = CreateAudioComponent(Sound, false, false, true,, true);
}

/**
 * Sound list
 */
function SoundCue getIdleSound()
{
	local int i;

	i = rand(IdleSounds.Length);

	return IdleSounds[i];
}

function addIdleSound(SoundCue Sound)
{
	IdleSounds.AddItem(Sound);
	`log("Sound length: " $IdleSounds.Length);
}

/**
 * Spesific sound
 */
function HPlaySoundEffect(SoundCue SoundToPlay)
{
	IdleSound.Stop();

	super.HPlaySoundEffect(SoundToPlay);
}

simulated function PlayAttackSound()
{
	//HPlaySoundEffect(HSoundGroup.static.getAttackSounds());
}

DefaultProperties
{
    bJumpCapable=false
    bCanJump=false
 
    GroundSpeed=200.0
	PeripheralVision = 0.7

	waitAtNode = 0.0f;

	killPlayerOnTouch = true;

}