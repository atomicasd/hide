class HideGame extends UTGame;
var bool isMapTransparent;
var      HPlayerController       HPlayer;

auto state SettingGame
{
	function BeginState(name PreviousStateName)
	{
		GotoState('GameInProgress');
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
				HPlayer=HPC;
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
		`log("Done");
	}
	isMapTransparent = true;
}

function MakeMapSolid()
{
	local Actor A;
	local StaticMeshActor smActor;
	local MaterialInstanceConstant matInstanceConstant;
	Foreach WorldInfo.AllActors( class'Actor', A )
	{
		smActor = StaticMeshActor(A);
		if(smActor == none) 
			continue; 

        matInstanceConstant = CreateSolidMaterial(smActor);
        if(matInstanceConstant == none) 
            continue;
		smActor.StaticMeshComponent.SetMaterial(0, matInstanceConstant);
		`log("Done");
	}
	isMapTransparent = false;
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
    oldMat = MaterialInstanceConstant(smActor.StaticMeshComponent.GetMaterial(0)); 

    //ITA: Creo la trasparenza solo per quelli che hanno "Shader_Base" nel nome del materiale padre ! 
    //ENG: I Create the transparence just for those which have the parent material name containing the string "Shader_Base"! 
    if(instr(matApp, "base_shader") == -1) 
        return oldMat; 

    matName = matApp.Name;  
    //ITA: il mio pacchetto contenente i materiali base (shader_base/shader_base_translucent) 
    //ENG: my package containing the base materials (shader_base/shader_base_translucent) 
    packageName = name("HideGameContent"); 
    materialClassName = string(packageName) $ "." $ string(matName); 

    if(InStr(matName, "_translucent") == -1) 
    { 
        materialClassName $= "_translucent"; 

        //ITA: Copio dal material tutti i parametri delle texture che ho bisogno... può darsi ci sia un modo migliore per far questo, funziona comunque! 
        //ENG: I copy from the material all texture parameters I need... maybe there's a better way than this, it works anyway! 
        matInstanceConstant = new(none) class'MaterialInstanceConstant'; 
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
        matInstanceConstant.SetParent(matApp); 
    } 
    else 
    { 
        matInstanceConstant = MaterialInstanceConstant(smActor.StaticMeshComponent.GetMaterial(0)); 
    } 
    matInstanceConstant.GetScalarParameterValue('Opacity', opacity); 

    //ITA: con interpolazione ottengo la trasparenza con un ritardo 
    //ENG: With interpolation we're getting the material to be translucent with a delay 
    opacity = Lerp(opacity, 0.5f, 0.05f); 
    matInstanceConstant.SetScalarParameterValue('Opacity', opacity); 

    return matInstanceConstant; 
} 

function MaterialInstanceConstant CreateSolidMaterial(StaticMeshActor smActor) 
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
    oldMat = MaterialInstanceConstant(smActor.StaticMeshComponent.GetMaterial(0)); 

    matInstanceConstant = MaterialInstanceConstant(smActor.StaticMeshComponent.GetMaterial(0)); 
    matInstanceConstant.GetScalarParameterValue('Opacity', opacity); 
    //ITA: controllo il valore dell'interpolazione, se ho superato 0.9 allora creerò una nuova istanza con un materiale solido! 
    //ENG: Checking the interpolation value, if I'm past 0.9f I'm gonna create a new instance with a solid material! 
    if(opacity < 0.9f) 
        opacity = Lerp(opacity, 1.0f, 0.05f); 
    else 
    {
        matName = matApp.Name;  
        packageName = Name("HideGameContent"); 
        materialClassName = string(packageName) $ "." $ string(matName); 
        materialClassName = Repl(materialClassName, "_translucent", ""); 
         
        matInstanceConstant = new(none) class'MaterialInstanceConstant'; 
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

    matInstanceConstant.SetScalarParameterValue('Opacity', opacity); 

    return matInstanceConstant; 
}  

exec function makePulseCircle()
{
	`log("Making map transparent");
	if( !isMapTransparent )
		MakeMapTransparent();
	else
		MakeMapSolid();
}



DefaultProperties
{
	PlayerControllerClass=class'HideGame.HPlayerController'
	DefaultPawnClass = class'HideGame.HPawn_Player'
	HUDType = class'HideGame.HPlayerHUD'

	bDelayedStart=false 
	bUseClassicHUD=true
	
	isMapTransparent = false;

}