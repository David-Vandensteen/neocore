function Assert-Rule {
  param (
    [Parameter(Mandatory=$true)][String] $Rule
  )
    if ($Rule -eq "") { return $true }
    if ($Rule -eq "animator") { return $true }
    if ($Rule -eq "clean") { return $true }
    if ($Rule -eq "clean:build") { return $true }
    if ($Rule -eq "default") { return $true }
    if ($Rule -eq "dist:iso") { return $true }
    if ($Rule -eq "dist:mame") { return $true }
    if ($Rule -eq "dist:exe") { return $true }
    if ($Rule -eq "framer") { return $true }
    if ($Rule -eq "lib") { return $true }
    if ($Rule -eq "make") { return $true }
    if ($Rule -eq "only:sprite") { return $true }
    if ($Rule -eq "only:program") { return $true }
    if ($Rule -eq "only:mame") { return $true }
    if ($Rule -eq "only:run") { return $true }
    if ($Rule -eq "only:run:mame") { return $true }
    if ($Rule -eq "only:run:raine") { return $true }
    if ($Rule -eq "sprite") { return $true }
    if ($Rule -eq "serve:raine") { return $true }
    if ($Rule -eq "serve:mame") { return $true }
    if ($Rule -like "run:mame*") { return $true }
    if ($Rule -eq "run:raine") {return $true }
    if ($Rule -like "run:raine:*") { return $true }

    if ($Rule -eq "--version") { return $true }

    if (-Not($Rule -eq "--help")) {
      Write-Host "error : unknow parameter $Rule" -ForegroundColor Red
    }

    Write-Host "parameter list :"
    Write-Host ""
    Write-Host "clean"
    Write-Host "clean:build"
    Write-Host "default"
    Write-Host "dist:iso"
    Write-Host "dist:mame"
    Write-Host "dist:exe"
    Write-Host "animator"
    Write-Host "framer"
    Write-Host "lib"
    Write-Host "make"
    Write-Host "sprite"
    Write-Host "serve:raine"
    Write-Host "serve:mame"
    Write-Host "only:sprite"
    Write-Host "only:program"
    Write-Host "only:mame"
    Write-Host "only:run"
    Write-Host "only:run:mame"
    Write-Host "only:run:raine"
    Write-Host "run"
    Write-Host "run:mame"
    Write-Host "run:raine"
    Write-Host ""

    if ($Config.project.emulator.mame.profile) {
      Write-Host "mame profiles for the project $($Config.project.name) :"

      $Config.project.emulator.mame.profile.ChildNodes | ForEach-Object {
        Write-Host "run:mame:$($_.Name)"
      }
    }
    Write-Host ""
    if ($Config.project.emulator.raine.config) {
      Write-Host "raine configs for the project $($Config.project.name) :"

      $Config.project.emulator.raine.config.ChildNodes | ForEach-Object {
        Write-Host "run:raine:$($_.Name)"
      }
    }
    Write-Host ""
    Write-Host "--version"
    Write-Host "--help"
    return $false
}