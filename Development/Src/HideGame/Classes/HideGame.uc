class HideGame extends UTGame;

/*
 * Variables
 */

var         bool                    isMapTransparent;
var         float                   mapOpacity;
var         HPlayerController       HPlayer;
var         bool                    bChangeStateToGameInProgress;

var HGameHud hHud;

var array<Material> PulseMat;

auto state SettingGame
{
	function BeginState(name PreviousStateName)
	{
		bChangeStateToGameInProgress = true;
	}

	function EndState(name NextStateName)
	{
	}
}


state GameInProgress
{
	function BeginState(name PreviousStateName)
	{
	}
	
	function Tick(float DeltaTime)
	{
		local HPlayerController HPC;

		if(HPlayer!=None)
		{
			if(HPlayer.bInEndOfLevel)
			{
				GoToState('LevelCompleted');
			}
		}
		else
		{
			ForEach WorldInfo.AllControllers(class'HPlayerController', HPC)
			{
				`log("Creating HPC");

				if(WorldInfo.GetMapName() == "HideMenuMap")
				{
					HPC.IgnoreInput(true);
				}else{
					HPC.IgnoreInput(false);
				}
				HPC.InitConfig();
				HPlayer=HPC;
				HPlayer.hGame = self;

			}
			
		}
	}

	function EndState(name NextStateName)
	{
	}
}

state LevelCompleted
{
	function BeginState(name PreviousStateName)
	{
		local string NextLevel;

		`Log("Next Level");

		if(HPlayer.LevelsCleared < HPlayer.getLevelNumber())
		{
			HPlayer.increasLevelCleared();
		}
		
		NextLevel = "Open HG-Lvl-";

		NextLevel $= HPlayer.GetLevelNumber() + 1;

		// Changing level to the next level
		ConsoleCommand(NextLevel);
		
	}

	function EndState(name NextStateName)
	{
	}
}

function PlayerStart ChoosePlayerStart( Controller Player, optional byte InTeam )
{
	//Reset pawns before a player spawn is chosen to avoid spawning inside a monster
	local HPawn_Monster p;

	//Reset all monster on map to default settings.
	foreach WorldInfo.AllPawns(class'HPawn_Monster', p)
	{
		p.Reset();
	}

	return super.ChoosePlayerStart(Player, InTeam);
}

event Tick(float DeltaTime)
{

	if(bChangeStateToGameInProgress){
		GotoState('GameInProgress');
		bChangeStateToGameInProgress=false;
	}
}

function FadeMapTransparancy(float opacity)
{
	local Actor A;
	local StaticMeshActor smActor;
	local Material matApp;
	local MaterialInstanceConstant MIC;
	Foreach WorldInfo.AllActors( class'Actor', A )
	{
		smActor = StaticMeshActor(A);
		if(smActor == none) 
			continue;

		matApp = smActor.StaticMeshComponent.GetMaterial(0).GetMaterial();

		MIC = new class'MaterialInstanceConstant';
		MIC.SetScalarParameterValue('Opacity', opacity);
		MIC.SetParent(matApp);
		smActor.StaticMeshComponent.SetMaterial(0, MIC);
	}
}

function MakeMapTransparent()
{
	local int numMaterials;
	local int i;
	local Actor A;
	local StaticMeshActor smActor;
	local InterpActor inActor;
	local MaterialInstanceConstant matInstanceConstant;
	Foreach WorldInfo.AllActors( class'Actor', A )
	{
		smActor = StaticMeshActor(A);
		if(smActor != none) 
		{
			numMaterials = smActor.StaticMeshComponent.GetNumElements();
			for(i = 0; i < numMaterials; ++i )
			{
				matInstanceConstant = CreateTransparentMaterial(smActor, i);
				if(matInstanceConstant == none) 
					continue;
				smActor.StaticMeshComponent.SetMaterial(i, matInstanceConstant);				
			}
		} else 
		{
			inActor = InterpActor(A);
			if( inActor != none )
			{
				matInstanceConstant = CreateTransparentMaterialInterp(inActor);
				if(matInstanceConstant == none) 
					continue;
				inActor.StaticMeshComponent.SetMaterial(0, matInstanceConstant);
			} else {
				continue;
			}
		}
	}
	//mapOpacity = 0.1;
	//FadeMapTransparancy(mapOpacity);
	//isMapTransparent = true;
}

function MakeMapSolid()
{
	local int numMaterials;
	local int i;
	local Actor A;
	local StaticMeshActor smActor;
	local InterpActor inActor;
	local MaterialInstanceConstant matInstanceConstant;
	`log("Making map solid");
	Foreach WorldInfo.AllActors( class'Actor', A )
	{
		smActor = StaticMeshActor(A);
		if(smActor != none) 
		{
			numMaterials = smActor.StaticMeshComponent.GetNumElements();
			for(i = 0; i < numMaterials; ++i )
			{
				matInstanceConstant = CreateSolidMaterial(smActor, i);
				if(matInstanceConstant == none) 
					continue;
				smActor.StaticMeshComponent.SetMaterial(i, matInstanceConstant);				
			}
		} else 
		{
			inActor = InterpActor(A);
			if( inActor != none )
			{
				matInstanceConstant = CreateSolidMaterialInterp(inActor);
				if(matInstanceConstant == none) 
					continue;
				inActor.StaticMeshComponent.SetMaterial(0, matInstanceConstant);
			} else {
				continue;
			}
		}
	}
}

function MaterialInstanceConstant CreateTransparentMaterial(StaticMeshActor smActor, int i) 
{ 
    local MaterialInstanceConstant matInstanceConstant; 
    local MaterialInstanceConstant oldMat; 
    local Material matApp; 
    local float opacity; 
	local name matGroupName;
    local name matName; 
    local name packageName; 
    local string materialClassName; 
    local Texture textureValue; 
	//local Material checkMaterial;

    matApp = smActor.StaticMeshComponent.GetMaterial(i).GetMaterial();
    oldMat = MaterialInstanceConstant( smActor.StaticMeshComponent.GetMaterial(i) ); 
    matName = matApp.Name;
	packageName = matApp.GetPackageName();
    //ITA: il mio pacchetto contenente i materiali base (shader_base/shader_base_translucent) 
    //ENG: my package containing the base materials (shader_base/shader_base_translucent) 
    //packageName = name("HIDE_Lvl02");
 
	if( string(matName) == "Concrete" ||
		string(matName) == "Concrete_Blood2" ||
		string(matName) == "07-Default" ||
		string(matName) == "Concrete_with_Blood" ||
		string(matName) == "08-Default" ||
		string(matName) == "Concrete_5" ||
		string(matName) == "Concrete_6" ||
		string(matName) == "Material_211")
	{
		matGroupName = name("level1_v5");
	}
	else if( string(matName) == "01-Default" )
	{
		matGroupName = name("room1");
	}
	else if( string(matName) == "02-Default" )
	{
		matGroupName = name("room2");
	}
	else if( string(matName) == "room3" )
	{
		matGroupName = name("room3");
	}
	else if( string(matName) == "room4" )
	{
		matGroupName = name("room4");
	}
	else if( string(matName) == "room5" )
	{
		matGroupName = name("room5");
	}
	else if( string(matName) == "room6" )
	{
		matGroupName = name("room6");
	}
	else if( string(matName) == "room7" )
	{
		matGroupName = name("room7");
	}
	else if( string(matName) == "room8" )
	{
		matGroupName = name("room8");
	}
	else if ( string(matName) == "Rust") 
	{
		matGroupName = name("barrel_rust");
	}
	else if ( string(matName) == "doorframe") 
	{
		matGroupName = name("doorframe");
	}
	else if ( string(matName) == "crate_green") 
	{
		matGroupName = name("crate_green");
	}
	else if ( string(matName) == "crate_red") 
	{
		matGroupName = name("crate_red");
	}
	else
	{
		return none;
	}

    materialClassName = string(packageName) $ "." $ string(matGroupName) $ "." $ matName; 

	//Check if there is a transparent version of the material

    if(InStr(matName, "_Translucent") == -1) 
    { 
        materialClassName $= "_Translucent";
		
        //ITA: Copio dal material tutti i parametri delle texture che ho bisogno... può darsi ci sia un modo migliore per far questo, funziona comunque! 
        //ENG: I copy from the material all texture parameters I need... maybe there's a better way than this, it works anyway! 
        matInstanceConstant = new(None) class'MaterialInstanceConstant';
        oldMat.GetTextureParameterValue('Diffuse', textureValue); 
        matInstanceConstant.SetTextureParameterValue('Diffuse', textureValue); 
        oldMat.GetTextureParameterValue('Normal', textureValue); 
        matInstanceConstant.SetTextureParameterValue('Normal', textureValue); 
        oldMat.GetTextureParameterValue('NormalDetail', textureValue); 
        matInstanceConstant.SetTextureParameterValue('NormalDetail', textureValue); 
        oldMat.GetTextureParameterValue('Spec', textureValue); 
        matInstanceConstant.SetTextureParameterValue('Spec', textureValue); 
        matApp = Material(DynamicLoadObject(materialClassName, class'Material')); 
        //ITA: lo swap effettivo! Baso il material instant constant su uno shader trasparente 
        //ENG: The actual swap! I set the parent of the material instant constant on the transparent shader (shader_base_translucent) 

		matInstanceConstant.GetScalarParameterValue('Opacity', opacity); 
		opacity = mapOpacity;
		matInstanceConstant.SetScalarParameterValue('Opacity', opacity); 
		matInstanceConstant.SetParent(matApp); 
    }
    return matInstanceConstant; 
}

function MaterialInstanceConstant CreateTransparentMaterialInterp(InterpActor smActor)
{
    local MaterialInstanceConstant matInstanceConstant; 
    local MaterialInstanceConstant oldMat; 
    local Material matApp; 
    local float opacity; 
	local name matGroupName;
    local name matName; 
    local name packageName; 
    local string materialClassName; 
    local Texture textureValue; 
	//local Material checkMaterial;

    matApp = smActor.StaticMeshComponent.GetMaterial(0).GetMaterial();
    oldMat = MaterialInstanceConstant( smActor.StaticMeshComponent.GetMaterial(0) ); 
    matName = matApp.Name;
	packageName = matApp.GetPackageName();
    //ITA: il mio pacchetto contenente i materiali base (shader_base/shader_base_translucent) 
    //ENG: my package containing the base materials (shader_base/shader_base_translucent) 
    //packageName = name("HIDE_Lvl02"); 
	if( string(matName) == "door")
	{
		matGroupName = name("testingfacility");
	}
	else if( string(matName) == "Floor")
	{
		matGroupName = name("elevator");
	}
	else
	{
		return none;
	}

    materialClassName = string(packageName) $ "." $ string(matGroupName) $ "." $ matName; 

	//Check if there is a transparent version of the material

    if(InStr(matName, "_Translucent") == -1) 
    { 
        materialClassName $= "_Translucent";
		
        //ITA: Copio dal material tutti i parametri delle texture che ho bisogno... può darsi ci sia un modo migliore per far questo, funziona comunque! 
        //ENG: I copy from the material all texture parameters I need... maybe there's a better way than this, it works anyway! 
        matInstanceConstant = new(None) class'MaterialInstanceConstant';
        oldMat.GetTextureParameterValue('Diffuse', textureValue); 
        matInstanceConstant.SetTextureParameterValue('Diffuse', textureValue); 
        oldMat.GetTextureParameterValue('Normal', textureValue); 
        matInstanceConstant.SetTextureParameterValue('Normal', textureValue); 
        oldMat.GetTextureParameterValue('NormalDetail', textureValue); 
        matInstanceConstant.SetTextureParameterValue('NormalDetail', textureValue); 
        oldMat.GetTextureParameterValue('Spec', textureValue); 
        matInstanceConstant.SetTextureParameterValue('Spec', textureValue); 
        matApp = Material(DynamicLoadObject(materialClassName, class'Material')); 
        //ITA: lo swap effettivo! Baso il material instant constant su uno shader trasparente 
        //ENG: The actual swap! I set the parent of the material instant constant on the transparent shader (shader_base_translucent) 

		matInstanceConstant.GetScalarParameterValue('Opacity', opacity); 
		opacity = mapOpacity;
		matInstanceConstant.SetScalarParameterValue('Opacity', opacity); 
		matInstanceConstant.SetParent(matApp); 
    }
    return matInstanceConstant; 
}
function MaterialInstanceConstant CreateSolidMaterial(StaticMeshActor smActor, int i) 
{ 
    local MaterialInstanceConstant matInstanceConstant; 
    local MaterialInstanceConstant oldMat; 
    local Material matApp; 
	local name matGroupName;
    local name matName; 
    local name packageName;
    local string materialClassName; 
    local Texture textureValue; 
	
    matApp = smActor.StaticMeshComponent.GetMaterial(i).GetMaterial(); 
    oldMat = MaterialInstanceConstant( smActor.StaticMeshComponent.GetMaterial(i) ); 
    matInstanceConstant = MaterialInstanceConstant( smActor.StaticMeshComponent.GetMaterial(i)); 

    //ITA: controllo il valore dell'interpolazione, se ho superato 0.9 allora creerò una nuova istanza con un materiale solido! 
    //ENG: Checking the interpolation value, if I'm past 0.9f I'm gonna create a new instance with a solid material! 
	matName = matApp.Name;
	packageName = matApp.GetPackageName();
	if( string(matName) == "07-Default_Translucent" ||
		string(matName) == "08-Default_Translucent" ||
		string(matName) == "Concrete_Translucent" ||
		string(matName) == "Concrete_5_Translucent" ||
		string(matName) == "Concrete_6_Translucent" ||
		string(matName) == "Concrete_Blood2_Translucent" ||
		string(matName) == "Concrete_with_Blood_Translucent" ||
		string(matName) == "Material_211_Translucent")
	{
		matGroupName = name("level1_v5");
	}
	else if( string(matName) == "01-Default_Translucent" )
	{
		matGroupName = name("room1");
	}
	else if( string(matName) == "02-Default_Translucent" )
	{
		matGroupName = name("room2");
	}
	else if( string(matName) == "Room3_Translucent" )
	{
		matGroupName = name("room3");
	}
	else if( string(matName) == "Room4_Translucent" )
	{
		matGroupName = name("room4");
	}
	else if( string(matName) == "Room5_Translucent" )
	{
		matGroupName = name("room5");
	}
	else if( string(matName) == "Room6_Translucent" )
	{
		matGroupName = name("room6");
	}
	else if( string(matName) == "Room7_Translucent" )
	{
		matGroupName = name("room7");
	}
	else if( string(matName) == "Room8_Translucent" )
	{
		matGroupName = name("room8");
	}
	else if ( string(matName) == "DoorFrame_Translucent") 
	{
		matGroupName = name("doorframe");
	}
	else if ( string(matName) == "Rust_Translucent") 
	{
		matGroupName = name("barrel_rust");
	}
	else if ( string(matName) == "Crate_Green_Translucent") 
	{
		matGroupName = name("crate_green");
	}
	else if ( string(matName) == "Crate_Red_Translucent") 
	{
		matGroupName = name("crate_red");
	}
	else
	{
		return none;
	}

	materialClassName = string(packageName) $ "." $ string(matGroupName) $ "." $ matName;
	if( InStr(matName, "_Translucent") != -1 )
	{
		materialClassName = Repl(materialClassName, "_Translucent", ""); 
	} else
	{
		return none;
	}

	matInstanceConstant = new class'MaterialInstanceConstant'; 
	oldMat.GetTextureParameterValue('Diffuse', textureValue); 
	matInstanceConstant.SetTextureParameterValue('Diffuse', textureValue); 
	oldMat.GetTextureParameterValue('Normal', textureValue); 
	matInstanceConstant.SetTextureParameterValue('Normal', textureValue); 
	oldMat.GetTextureParameterValue('NormalDetail', textureValue); 
	matInstanceConstant.SetTextureParameterValue('NormalDetail', textureValue); 
	oldMat.GetTextureParameterValue('Spec', textureValue); 
	matInstanceConstant.SetTextureParameterValue('Spec', textureValue); 
		
	matApp = Material(DynamicLoadObject(materialClassName, class'Material')); 
	matInstanceConstant.SetParent(matApp);
	

    return matInstanceConstant; 
}

function MaterialInstanceConstant CreateSolidMaterialInterp(InterpActor smActor) 
{ 
    local MaterialInstanceConstant matInstanceConstant; 
    local MaterialInstanceConstant oldMat; 
    local Material matApp; 
	local name matGroupName;
    local name matName; 
    local name packageName;
    local string materialClassName; 
    local Texture textureValue; 
	
    matApp = smActor.StaticMeshComponent.GetMaterial(0).GetMaterial(); 
    oldMat = MaterialInstanceConstant( smActor.StaticMeshComponent.GetMaterial(0) ); 
    matInstanceConstant = MaterialInstanceConstant( smActor.StaticMeshComponent.GetMaterial(0)); 

    //ITA: controllo il valore dell'interpolazione, se ho superato 0.9 allora creerò una nuova istanza con un materiale solido! 
    //ENG: Checking the interpolation value, if I'm past 0.9f I'm gonna create a new instance with a solid material! 
	matName = matApp.Name;
	packageName = matApp.GetPackageName();
	if ( string(matName) == "door_Translucent") 
	{
		matGroupName = name("testingfacility");

	}
	else if( string(matName) == "Floor_Translucent")
	{
		matGroupName = name("elevator");
	}
	else
	{
		return none;
	}

	materialClassName = string(packageName) $ "." $ string(matGroupName) $ "." $ matName;
	if( InStr(matName, "_Translucent") != -1 )
	{
		materialClassName = Repl(materialClassName, "_Translucent", ""); 
	} else
	{
		return none;
	}

	matInstanceConstant = new class'MaterialInstanceConstant'; 
	oldMat.GetTextureParameterValue('Diffuse', textureValue); 
	matInstanceConstant.SetTextureParameterValue('Diffuse', textureValue); 
	oldMat.GetTextureParameterValue('Normal', textureValue); 
	matInstanceConstant.SetTextureParameterValue('Normal', textureValue); 
	oldMat.GetTextureParameterValue('NormalDetail', textureValue); 
	matInstanceConstant.SetTextureParameterValue('NormalDetail', textureValue); 
	oldMat.GetTextureParameterValue('Spec', textureValue); 
	matInstanceConstant.SetTextureParameterValue('Spec', textureValue); 
		
	matApp = Material(DynamicLoadObject(materialClassName, class'Material')); 
	matInstanceConstant.SetParent(matApp);
	

    return matInstanceConstant; 
}

function ShowFinishGamePicture()
{
	
	hHud.ShowFinishGamePicture();
	
}



DefaultProperties
{
	PlayerControllerClass=class'HideGame.HPlayerController'
	DefaultPawnClass = class'HideGame.HPawn_Player'
	HUDType = class'HideGame.HGameHUD'
	
	bDelayedStart=false 
	bUseClassicHUD=true
	
	isMapTransparent = false;

	mapOpacity = 0.0;

	PulseMat[0] = Material'HIDE_Lvl01.Level1_V5.07-Default_Translucent'
	PulseMat[1] = Material'HIDE_Lvl01.Level1_V5.08-Default_Translucent'
	PulseMat[2] = Material'HIDE_Lvl01.Level1_V5.Concrete_5_Translucent'
	PulseMat[3] = Material'HIDE_Lvl01.Level1_V5.Concrete_6_Translucent'
	PulseMat[4] = Material'HIDE_Lvl01.Level1_V5.Concrete_Blood2_Translucent'
	PulseMat[5] = Material'HIDE_Lvl01.Level1_V5.Concrete_Translucent'
	PulseMat[6] = Material'HIDE_Lvl01.Level1_V5.Material_211_Translucent'
	PulseMat[7] = Material'HIDE_Lvl01.Level1_V5.Concrete_with_Blood_Translucent'
	PulseMat[8] = Material'HIDE_Lvl02.room1.01-Default_Translucent'
	PulseMat[9] = Material'HIDE_Lvl02.room2.02-Default_Translucent'
	PulseMat[10] = Material'HIDE_Lvl02.room3.Room3_Translucent'
	PulseMat[11] = Material'HIDE_Lvl02.room4.Room4_Translucent'
}