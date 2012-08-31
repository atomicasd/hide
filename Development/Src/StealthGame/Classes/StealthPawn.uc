class StealthPawn extends UTPawn;

var float ElapsedRegenTime;
var float RegenAmount;
var float RegenTime;

event Tick(float DeltaTime)
{
  //calculate elapsed time
  ElapsedRegenTime += DeltaTime;
  
  //has enough time elapsed?
  if(ElapsedRegenTime >= RegenTime)
  {
    //heal the Pawn and reset elapsed time
    HealDamage(RegenAmount, Controller, class'DamageType');
    ElapsedRegenTime = 0.0f;
  }
}

defaultproperties
{
  //set defaults for regeneration properties
  GroundSpeed = 1000;
  RegenAmount=2
  RegenTime=1
}