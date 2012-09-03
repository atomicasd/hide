class StealthHUD extends UTHUD;

enum EActorBracketStyle
{
	EABS_2DActorBrackets,
	EABS_3DActorBrackets,
	EABS_2DBox,
	EABS_3DBox,
	EABS_3DCircle
};

var EActorBracketStyle ActorBracketStyle;
var float circleSize;
var bool drawPlayerCircle;
var Pawn PC;
var array<Pawn> pawns;

exec function makePulseCircle()
{
	PC = GetALocalPlayerController().Pawn;
	drawPlayerCircle=true;
}


event PostRender()
{
	local Pawn ArrayItem;
	super.PostRender();

	if(drawPlayerCircle)
	{
		RenderThreeDeeCircle(PC);
	}

	foreach pawns(ArrayItem)
	{
		RenderThreeDeeCircle(ArrayItem);
	}
}


function RenderThreeDeeCircle(Pawn target)
{
	local Rotator Angle;
	local Vector Radius, Offsets[16];
	local Box ComponentsBoundingBox;
	local float Width, Height;
	local Pawn victim;
	local Pawn ArrayItem;
	local int i;
	local bool playerFound;
	
	circleSize += 0.2f;

	if (PlayerOwner == None)
	{
		return;
	}

	target.GetComponentsBoundingBox(ComponentsBoundingBox);
	
	Width = (ComponentsBoundingBox.Max.X - ComponentsBoundingBox.Min.X) * circleSize;
	Height = ComponentsBoundingBox.Max.Y - ComponentsBoundingBox.Min.Y;
	Radius.X = (Width > Height) ? Width : Height;

	`log("Radius: "$Radius.X);
	
	i = 0;

	for (Angle.Yaw = 0; Angle.Yaw < 65536; Angle.Yaw += 4096)
	{
		// Calculate the offset
		Offsets[i] = target.Location + (Radius >> Angle) + Vect(0.f, 0.f, 16.f);
		i++;
	}
		
	// Draw all of the lines
	for (i = 0; i < ArrayCount(Offsets); ++i)
	{
		if (i == ArrayCount(Offsets) - 1)
		{
			Draw3DLine(Offsets[i], Offsets[0], class'HUD'.default.RedColor);
		}
		else
		{
			Draw3DLine(Offsets[i], Offsets[i + 1], class'HUD'.default.RedColor);
		}
	}
	
	foreach PC.OverlappingActors(class'Pawn', victim, Radius.X)
	{
		if(victim != PC)
		{
			if(pawns.Length != 0)
			{
				foreach pawns(ArrayItem)
				{
					if(ArrayItem != victim)
					{
						playerFound=true;
					}
				}
			}else{
				playerFound=true;
			}

		}
		if(playerFound)
		{
			pawns.AddItem(victim);
			
		}
	}
	
	if(circleSize >= 20)
	{
		circleSize = 0;
		if(PC == target)
		{
			drawPlayerCircle=false;
		}else{
			pawns.RemoveItem(target);
			`log("Removed");
		}
	}

}

defaultproperties
{
	circleSize=0.0
	drawPlayerCircle=false
}