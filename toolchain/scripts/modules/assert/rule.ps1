function Assert-Rule {
  param (
    [Parameter(Mandatory=$true)][String] $Rule
  )
    if ($Rule -eq "") { return 0 }
    if ($Rule -eq "animator") { return 0 }
    if ($Rule -eq "clean") { return 0 }
    if ($Rule -eq "clean:build") { return 0 }
    if ($Rule -eq "default") { return 0 }
    if ($Rule -eq "dist:iso") { return 0 }
    if ($Rule -eq "dist:mame") { return 0 }
    if ($Rule -eq "dist:exe") { return 0 }
    if ($Rule -eq "framer") { return 0 }
    if ($Rule -eq "iso") { return 0 }
    if ($Rule -eq "lib") { return 0 }
    if ($Rule -eq "make") { return 0 }
    if ($Rule -eq "only:sprite") { return 0 }
    if ($Rule -eq "only:program") { return 0 }
    if ($Rule -eq "only:mame") { return 0 }
    if ($Rule -eq "only:run") { return 0 }
    if ($Rule -eq "only:run:mame") { return 0 }
    if ($Rule -eq "only:run:raine") { return 0 }
    if ($Rule -eq "sprite") { return 0 }
    if ($Rule -eq "serve:raine") { return 0 }
    if ($Rule -eq "serve:mame") { return 0 }
    if ($Rule -like "run:mame*") { return 0 }
    if ($Rule -eq "run:raine") {return 0 }
    if ($Rule -like "run:raine:*") { return 0 }

    if ($Rule -eq "--version") { return 0 }

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
    Write-Host "iso"
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
    exit 1
}