class HAudioComponent_IdleSounds extends AudioComponent;

var array<SoundCue> HIdleSounds;

function addIdleSound(SoundCue idlesound)
{
	HIdleSounds.AddItem(idleSound);
}

function SoundCue GetIdleSound()
{
	return HIdleSounds[rand(HIdleSounds.Length)];
}

function HPlay()
{
	SoundCue = GetIdleSound();
	Play();
}

DefaultProperties
{
}
