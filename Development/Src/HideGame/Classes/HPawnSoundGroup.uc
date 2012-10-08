class HPawnSoundGroup extends UTPawnSoundGroup
	abstract
	dependson(UTPhysicalMaterialProperty);

DefaultProperties
{
	DefaultJumpingSound=SoundCue'HidePackage.Sound.Silence1'

	JumpingSounds[0]=(MaterialType=Stone,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_StoneJumpCue')
	JumpingSounds[1]=(MaterialType=Dirt,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_DirtJumpCue')
	JumpingSounds[2]=(MaterialType=Energy,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_EnergyJumpCue')
	JumpingSounds[3]=(MaterialType=Flesh_Human,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_FleshJumpCue')
	JumpingSounds[4]=(MaterialType=Foliage,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_FoliageJumpCue')
	JumpingSounds[5]=(MaterialType=Glass,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_GlassPlateJumpCue')
	JumpingSounds[6]=(MaterialType=GlassBroken,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_GlassBrokenJumpCue')
	JumpingSounds[7]=(MaterialType=Grass,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_GrassJumpCue')
	JumpingSounds[8]=(MaterialType=Metal,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_MetalJumpCue')
	JumpingSounds[9]=(MaterialType=Mud,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_MudJumpCue')
	JumpingSounds[10]=(MaterialType=Metal,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_MetalJumpCue')
	JumpingSounds[11]=(MaterialType=Snow,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_SnowJumpCue')
	JumpingSounds[12]=(MaterialType=Tile,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_TileJumpCue')
	JumpingSounds[13]=(MaterialType=Water,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WaterDeepJumpCue')
	JumpingSounds[14]=(MaterialType=ShallowWater,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WaterShallowJumpCue')
	JumpingSounds[15]=(MaterialType=Wood,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WoodJumpCue')

	DefaultLandingSound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_DirtLandCue'
	LandingSounds[0]=(MaterialType=Stone,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_StoneLandCue')
	LandingSounds[1]=(MaterialType=Dirt,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_DirtLandCue')
	LandingSounds[2]=(MaterialType=Energy,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_EnergyLandCue')
	LandingSounds[3]=(MaterialType=Flesh_Human,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_FleshLandCue')
	LandingSounds[4]=(MaterialType=Foliage,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_FoliageLandCue')
	LandingSounds[5]=(MaterialType=Glass,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_GlassPlateLandCue')
	LandingSounds[6]=(MaterialType=GlassBroken,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_GlassBrokenLandCue')
	LandingSounds[7]=(MaterialType=Grass,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_GrassLandCue')
	LandingSounds[8]=(MaterialType=Metal,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_MetalLandCue')
	LandingSounds[9]=(MaterialType=Mud,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_MudLandCue')
	LandingSounds[10]=(MaterialType=Metal,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_MetalLandCue')
	LandingSounds[11]=(MaterialType=Snow,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_SnowLandCue')
	LandingSounds[12]=(MaterialType=Tile,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_TileLandCue')
	LandingSounds[13]=(MaterialType=Water,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WaterDeepLandCue')
	LandingSounds[14]=(MaterialType=ShallowWater,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WaterShallowLandCue')
	LandingSounds[15]=(MaterialType=Wood,Sound=SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WoodLandCue')
}
