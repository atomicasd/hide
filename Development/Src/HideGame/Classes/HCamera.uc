class HCamera extends GamePlayerCamera;

/***********************************
*DeltaTime 
*FadeFrom 0-1 1=black
*FadeTo 0-1 1=black
************************************/
function FadeTo(float DeltaTime,float FadeFrom,float FadeTo)
{
   bEnableFading=true;
   FadeTimeRemaining=DeltaTime;
   FadeTime=DeltaTime;
   FadeAlpha.X=FadeFrom;
   FadeAlpha.Y=FadeTo;
}

/***********************************
*FadingToBlack
************************************/
function FadeToBlack(float DeltaTime)
{
   FadeTo(DeltaTime,0,1);
}

/***********************************
*Clear Fade Effect
*************************************/
function FadeToNormal(float DeltaTime)
{
   FadeTo(DeltaTime,1,0);
}