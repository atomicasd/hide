class StealthMrNerveHand extends Actor;

function PostBeginPlay()
{
	super.PostBeginPlay();

	`Log("--------> Created mrNerveHand <--------");
}

DefaultProperties
{
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_NavP'
		HiddenGame=true
	End Object

	Components.Add(Sprite);
}
