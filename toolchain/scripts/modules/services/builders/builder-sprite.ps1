function BuilderSprite {
  Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\services\writers\sprite.ps1"
  Write-DATXML -InputFile $ConfigFile -OutputFile "$($buildConfig.pathBuild)\chardata.xml"
  Write-Sprite -XMLFile "$($buildConfig.pathBuild)\chardata.xml" -Format "cd" -OutputFile "$($buildConfig.pathBuild)\$($buildConfig.projectName)"
}
