function Install-NSIS {
  $installPath = $(Resolve-TemplatePath -Path $Config.project.buildPath)
  $downloadPath = $(Resolve-TemplatePath -Path "$($Config.project.buildPath)\spool")

  if ($Manifest.manifest.dependencies.nsis.url) {
    Install-Component `
      -URL $Manifest.manifest.dependencies.nsis.url `
      -PathDownload $downloadPath `
      -PathInstall (Get-TemplatePath -Path $Manifest.manifest.dependencies.nsis.path)
  } else {
    Write-Host "Error: NSIS not found in manifest dependencies" -ForegroundColor Red
    Write-Host "Please add nsis to manifest.xml dependencies section" -ForegroundColor Yellow
    return $false
  }
}
