class HideGame extends UTGame
config(Game);

/*
 * Config variables
 */
var     bool                    isMapTransparent;
var     float                   mapOpacity;
var     HPlayerController       HPlayer;
var     bool                    bChangeStateToGameInProgress;


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
				HPlayer=HPC;
			}
		}

		if( isMapTransparent )
		{
			if( mapOpacity >= 0.9 )
			{
				HPlayer.PulseFadeIn();
			}
			if( mapOpacity >= 1.0 )
			{
				mapOpacity = 1.0;
				MakeMapSolid();
				isMapTransparent = false;
			} else {
				mapOpacity += (DeltaTime / 2) / 5;
				FadeMapTransparancy(mapOpacity);
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
	}

	function EndState(name NextStateName)
	{
	}
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
	local MaterialInstanceConstant matInstanceConstant;
	Foreach WorldInfo.AllActors( class'Actor', A )
	{
		smActor = StaticMeshActor(A);
		if(smActor == none) 
			continue; 
		
        matInstanceConstant = CreateTransparentMaterial(smActor);
        if(matInstanceConstant == none) 
            continue;
		smActor.StaticMeshComponent.SetMaterial(0, matInstanceConstant);
	}
	mapOpacity = 0.5;
}

function MakeMapSolid()
{
	local Actor A;
	local StaticMeshActor smActor;
	local MaterialInstanceConstant matInstanceConstant;
	`log("Making map solid");
	Foreach WorldInfo.AllActors( class'Actor', A )
	{
		smActor = StaticMeshActor(A);
		if(smActor == none) 
			continue; 
	
        matInstanceConstant = CreateSolidMaterial(smActor);
        if(matInstanceConstant == none) 
            continue;
		smActor.StaticMeshComponent.SetMaterial(0, matInstanceConstant);
	}
}

function MaterialInstanceConstant CreateTransparentMaterial(StaticMeshActor smActor) 
{ 
    local MaterialInstanceConstant matInstanceConstant; 
    local MaterialInstanceConstant oldMat; 
    local Material matApp; 
    local float opacity; 
    local name matName; 
    local name packageName; 
    local string materialClassName; 
    local Texture textureValue; 

    matApp = smActor.StaticMeshComponent.GetMaterial(0).GetMaterial();
    oldMat = MaterialInstanceConstant( smActor.StaticMeshComponent.GetMaterial(0) ); 

    matName = matApp.Name;  
    //ITA: il mio pacchetto contenente i materiali base (shader_base/shader_base_translucent) 
    //ENG: my package containing the base materials (shader_base/shader_base_translucent) 
    packageName = name("HideGameContent"); 
    materialClassName = string(packageName) $ "." $ string(matName); 
	
	if(InStr(matName, "pulsewall") == -1)
		return none;

    if(InStr(matName, "_translucent") == -1) 
    { 
        materialClassName $= "_translucent";

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

function MaterialInstanceConstant CreateSolidMaterial(StaticMeshActor smActor) 
{ 
    local MaterialInstanceConstant matInstanceConstant; 
    local MaterialInstanceConstant oldMat; 
    local Material matApp; 
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

	if( InStr(matName, "_translucent") != -1 )
	{
		packageName = Name("HideGameContent"); 
		materialClassName = string(packageName) $ "." $ string(matName); 
		materialClassName = Repl(materialClassName, "_translucent", ""); 
        
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
	}

    return matInstanceConstant; 
}  

exec function makePulseCircle()
{
	if( !isMapTransparent )
	{
		`log("Making pulse circle");
		HPlayer.EnablePulse();
		MakeMapTransparent();
		isMapTransparent = true;
	}

}



DefaultProperties
{
	PlayerControllerClass=class'HideGame.HPlayerController'
	DefaultPawnClass = class'HideGame.HPawn_Player'
	HUDType = class'HideGame.HPlayerHUD'

	bDelayedStart=false 
	bUseClassicHUD=true
	
	isMapTransparent = false;

	mapOpacity = 0.5;

}