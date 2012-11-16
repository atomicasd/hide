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
				`log("Player reached end of level!");
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
	local Actor A;
	local StaticMeshActor smActor;
	local InterpActor inActor;
	local MaterialInstanceConstant matInstanceConstant;
	Foreach WorldInfo.AllActors( class'Actor', A )
	{
		smActor = StaticMeshActor(A);
		if(smActor != none) 
		{
			matInstanceConstant = CreateTransparentMaterial(smActor);
			if(matInstanceConstant == none) 
				continue;
			smActor.StaticMeshComponent.SetMaterial(0, matInstanceConstant);
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
			matInstanceConstant = CreateSolidMaterial(smActor);
			if(matInstanceConstant == none) 
				continue;
			smActor.StaticMeshComponent.SetMaterial(0, matInstanceConstant);
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

function MaterialInstanceConstant CreateTransparentMaterial(StaticMeshActor smActor) 
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
	if( string(matName) == "Lvl02_Material")
	{
		matGroupName = name("Lvl02");
	} else if ( string(matName) == "Lvl01_Material") 
	{
		matGroupName = name("lvl01");
	}
	else if ( string(matName) == "DoorFrame") 
	{
		matGroupName = name("testingfacility");
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
//    matInstanceConstant = oldMat; 
function MaterialInstanceConstant CreateSolidMaterial(StaticMeshActor smActor) 
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
	if( string(matName) == "Lvl02_Material_Translucent")
	{
		matGroupName = name("Lvl02");
	} else if ( string(matName) == "Lvl01_Material_Translucent") 
	{
		matGroupName = name("lvl01");
	}
	else if ( string(matName) == "DoorFrame_Translucent") 
	{
		matGroupName = name("testingfacility");
		`log("----------------------------------------------------------------------");
	}
	else
	{
		return none;
	}

	materialClassName = string(packageName) $ "." $ string(matGroupName) $ "." $ matName;
	`log(materialClassName);
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
		//`log("----------------------------------------------------------------------");
	}
	else
	{
		return none;
	}

	materialClassName = string(packageName) $ "." $ string(matGroupName) $ "." $ matName;
	`log(materialClassName);
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

	PulseMat[0] = Material'HIDE_Lvl01.lvl01.Lvl01_Material_Translucent'
	PulseMat[1] = Material'Hide_Lvl02.lvl02.lvl02_Material_Translucent'
}