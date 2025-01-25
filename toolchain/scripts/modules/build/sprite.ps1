Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\sprite.ps1"

function Build-Sprite {
  Write-DATXML -InputFile $ConfigFile -OutputFile "$($buildConfig.pathBuild)\chardata.xml"
  Write-Sprite -XMLFile "$($buildConfig.pathBuild)\chardata.xml" -Format "cd" -OutputFile "$($buildConfig.pathBuild)\$($buildConfig.projectName)"
}
