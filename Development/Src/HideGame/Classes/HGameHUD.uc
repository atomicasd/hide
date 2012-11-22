class HGameHUD extends UTHUD;

var HPauseMenu PauseMenu;

var bool bFadeInHitEffect;

var bool bShowFinishGamePicture;

var CanvasIcon thankYouPicture;
var CanvasIcon tut1;
var CanvasIcon tut2;
var CanvasIcon tut3;
var CanvasIcon tut4;
var CanvasIcon tut5;
var CanvasIcon tut6;
var CanvasIcon tut7;
var CanvasIcon tut8;
var CanvasIcon tut9;

var HideGame hGame;

var float helpMessageTime;
var float helpMessageTimeMax;
var int activeMessageId;
var bool bDdrawHelpMessage;
exec function ShowMenu()
{
	// if using GFx HUD, use GFx pause menu
	TogglePauseMenu();
}

function TogglePauseMenu()
{
    if ( PauseMenu != none && PauseMenu.bMovieIsOpen )
	{
          //PauseMenu.ClosePauseMenu();
	}
    else
    {
		CloseOtherMenus();

        if (PauseMenuMovie == None)
        {
            PauseMenu = new class'HPauseMenu';
            PauseMenu.MovieInfo = SwfMovie'MenuPackage.HPauseMenu';
            PauseMenu.bEnableGammaCorrection = FALSE;
            PauseMenu.LocalPlayerOwnerIndex = class'Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));
            PauseMenu.SetTimingMode(TM_Real);
            PlayerOwner.SetPause(True);
			`log("eee");
        }

        SetVisible(false);
        PauseMenu.Start();
    }
}
 
/**
 * Called in PostBeginPlay or postprocessing chain has changed (happens because of the worldproperties can define it's own chain and this one is set late).
 */
function NotifyBindPostProcessEffects()
{
	// create hit effect material instance
	HitEffect = MaterialEffect(LocalPlayer(PlayerOwner.Player).PlayerPostProcess.FindPostProcessEffect('HitEffect'));
	if (HitEffect != None)
	{
		if (MaterialInstanceConstant(HitEffect.Material) != None && HitEffect.Material.GetPackageName() == 'Transient')
		{
			// the runtime material already exists; grab it
			HitEffectMaterialInstance = MaterialInstanceConstant(HitEffect.Material);
		}
		else
		{
			HitEffectMaterialInstance = new(HitEffect) class'MaterialInstanceConstant';
			HitEffectMaterialInstance.SetParent(HitEffect.Material);
			HitEffectMaterialInstance.SetScalarParameterValue('HitAmount', 0.0f);
			HitEffect.Material = HitEffectMaterialInstance;
		}
		HitEffect.bShowInGame = false;
	}
	
}

function Tick(float DeltaTime)
{
	hGame = HPlayerController( GetALocalPlayerController() ).hGame;
	hGame.hHud = self;

	if( helpMessageTime > 0.0f )
	{
		helpMessageTime -= DeltaTime;
	} else 
	{
		bDdrawHelpMessage = false;
	}

	super.Tick( DeltaTime );
}

/**
 * Update Damage always needs to be called
 */
function UpdateDamage()
{
	local int i;
	local float HitAmount;
	local LinearColor HitColor;

	for (i=0; i<MaxNoOfIndicators; i++)
	{
		if (DamageData[i].FadeTime > 0)
		{
			DamageData[i].FadeValue += ( 0 - DamageData[i].FadeValue) * (RenderDelta / DamageData[i].FadeTime);
			DamageData[i].FadeTime -= RenderDelta;
			DamageData[i].MatConstant.SetScalarParameterValue(FadeParamName,DamageData[i].FadeValue);
		}
	}

	// Update the color/fading on the full screen distortion
	if (bFadeOutHitEffect)
	{
		HitEffectMaterialInstance.GetScalarParameterValue('HitAmount', HitAmount);
		HitAmount -= RenderDelta/20;

		if (HitAmount <= 0.0)
		{
			HitEffect.bShowInGame = false;
			bFadeOutHitEffect = false;
			bFadeInHitEffect = false;
		}
		else
		{
			HitEffectMaterialInstance.SetScalarParameterValue('HitAmount', HitAmount);
			// now scale the color
			HitEffectMaterialInstance.GetVectorParameterValue('HitColor', HitColor);
			HitColor = MaxHitEffectColor * HitAmount;
			HitEffectMaterialInstance.SetVectorParameterValue('HitColor', HitColor);
		}
	}

	if (bFadeInHitEffect)
	{
		HitEffectMaterialInstance.GetScalarParameterValue('HitAmount', HitAmount);
		HitAmount +=  RenderDelta/15;
		if (HitAmount >= 0.4)
		{
			FadeOutHitEffect();
		}
		else
		{
			HitEffectMaterialInstance.SetScalarParameterValue('HitAmount', HitAmount);
			// now scale the color
			HitEffectMaterialInstance.GetVectorParameterValue('HitColor', HitColor);
			HitColor = MaxHitEffectColor * HitAmount;
			HitEffectMaterialInstance.SetVectorParameterValue('HitColor', HitColor);
		}
	}
}

exec function FadeInHitEffect()
{
	local float HitAmount;
	HitEffectMaterialInstance.GetScalarParameterValue('HitAmount', HitAmount);

	if( HitAmount <= 0.01 )
	{
		HitEffectMaterialInstance.SetScalarParameterValue('HitAmount', 0.05);
		bFadeInHitEffect = true;
		bFadeOutHitEffect = false;
		HitEffect.bShowInGame = true;
		HPlayerController( GetALocalPlayerController() ).ActivatePulse();
	}
}

exec function FadeOutHitEffect()
{
	`log("Fade out");
	bFadeInHitEffect = false;
	bFadeOutHitEffect = true;
	HPlayerController( GetALocalPlayerController() ).DisablePulse();
}

final function DrawIconStretched(CanvasIcon Icon, float X, float Y, optional float ScaleX, optional float ScaleY)
{
   if (Icon.Texture != None)
   {
		
      // verify properties are valid
      if (ScaleX <= 0.f)
      {
         ScaleX = ViewX/1920.0f;
		 
      }

      if (ScaleY <= 0.f)
      {
         ScaleY = ViewY/1080.0f;
      }

      if (Icon.UL == 0.f)
      {
         Icon.UL = Icon.Texture.GetSurfaceWidth();
      }

      if (Icon.VL == 0.f)
      {
         Icon.VL = Icon.Texture.GetSurfaceHeight();
      }

      // set the canvas position
      Canvas.SetPos(X, Y);

      // and draw the texture
      Canvas.DrawTileStretched(Icon.Texture, Abs(Icon.UL) * ScaleX, Abs(Icon.VL) * ScaleY,
                           Icon.U, Icon.V, Icon.UL, Icon.VL,, true, true);
   }
}

function SetHelpMessage( int id )
{
	activeMessageId = id;
	helpMessageTime = helpMessageTimeMax;
	bDdrawHelpMessage = true;
}

function DrawHelpMessage()
{
	if( !bDdrawHelpMessage )
		return;

	if( activeMessageId == 1 )
	{
		DrawMessage1( tut1,0,0 );
	}
	else if (activeMessageId == 2)
	{
		DrawMessage2( thankYouPicture,0,0 );
	}
}

function DrawMessage1( CanvasIcon Icon, float X, float Y, optional float ScaleX, optional float ScaleY)
{
   if (Icon.Texture != None)
   {
		
      // verify properties are valid
      if (ScaleX <= 0.f)
      {
         ScaleX = ViewX/1920.0f;
		 
      }

      if (ScaleY <= 0.f)
      {
         ScaleY = ViewY/1080.0f;
      }

      if (Icon.UL == 0.f)
      {
         Icon.UL = Icon.Texture.GetSurfaceWidth();
      }

      if (Icon.VL == 0.f)
      {
         Icon.VL = Icon.Texture.GetSurfaceHeight();
      }

      // set the canvas position
      Canvas.SetPos(X, Y);

      // and draw the texture
      Canvas.DrawTileStretched(Icon.Texture, Abs(Icon.UL) * ScaleX, Abs(Icon.VL) * ScaleY,
                           Icon.U, Icon.V, Icon.UL, Icon.VL,, true, true);
   }
}

function DrawMessage2( CanvasIcon Icon, float X, float Y, optional float ScaleX, optional float ScaleY)
{
	`log("help message 2");
}

function DrawGameHud()
{
	if(bShowFinishGamePicture)
	{
		DrawIconStretched( thankYouPicture, 0, 0, );
	}
	UpdateDamage();
	//DisplayLocalMessages();
	//DisplayConsoleMessages();

	DrawHelpMessage();
}

function ShowFinishGamePicture()
{
	bShowFinishGamePicture = true;
}

function DrawMessageText(HudLocalizedMessage LocalMessage, float ScreenX, float ScreenY)
{
	local color CanvasColor;
	local string StringMessage;

	if ( Canvas.Font == none )
	{
		Canvas.Font = GetFontSizeIndex(0);
	}

	StringMessage = LocalMessage.StringMessage;
	if ( LocalMessage.Count > 0 )
	{
		if ( Right(StringMessage, 1) ~= "." )
		{
			StringMessage = Left(StringMessage, Len(StringMessage) -1);
		}
		StringMessage = StringMessage$" X "$LocalMessage.Count;
	}

	CanvasColor = Canvas.DrawColor;

	// now draw string with normal color
	Canvas.DrawColor = CanvasColor;
	Canvas.SetPos( ScreenX, ScreenY );
	Canvas.DrawText( StringMessage, false, , , TextRenderInfo );
}

DefaultProperties
{
	helpMessageTime = 0;
	helpMessageTimeMax = 5;
	activeMessageId = 0;
	bDdrawHelpMessage = false;
	bFadeInHitEffect = false;
	bShowFinishGamePicture = false;
	thankYouPicture = (Texture=Texture2D'MenuPackage.thankyou')
	tut1 = (Texture=Texture2D'HIDE_Assets.helptut.Tutorial1');
	tut2 = (Texture=Texture2D'HIDE_Assets.helptut.Tutorial2');
	tut3 = (Texture=Texture2D'HIDE_Assets.helptut.Tutorial3');
	tut4 = (Texture=Texture2D'HIDE_Assets.helptut.Tutorial4');
}
