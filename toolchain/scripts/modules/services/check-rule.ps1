function Check-Rule {
  if ($Rule -eq "") { return 0 }
  if ($Rule -eq "clean") { return 0 }
  if ($Rule -eq "default") { return 0 }
  if ($Rule -eq "dist:iso") { return 0 }
  if ($Rule -eq "dist:mame") { return 0 }
  if ($Rule -eq "iso") { return 0 }
  if ($Rule -eq "make") { return 0 }
  if ($Rule -eq "sprite") { return 0 }
  if ($Rule -eq "serve:raine") { return 0 }
  if ($Rule -eq "serve:mame") { return 0 }
  if ($Rule -eq "only:sprite") { return 0 }
  if ($Rule -eq "only:program") { return 0 }
  if ($Rule -eq "only:mame") { return 0 }
  if ($Rule -eq "only:run") { return 0 }
  if ($Rule -eq "only:run:mame") { return 0 }
  if ($Rule -eq "only:run:raine") { return 0 }
  if ($Rule -eq "run") { return 0 }
  if ($Rule -eq "run:mame") { return 0 }
  if ($Rule -eq "run:raine") { return 0 }
  if ($Rule -eq "mame") { return 0 }
  if ($Rule -eq "raine") { return 0 }

  Write-Host "error : unknow parameter $Rule" -ForegroundColor Red
  Write-Host "parameter list :"

  Write-Host "clean"
  Write-Host "default"
  Write-Host "dist:iso"
  Write-Host "dist:mame"
  Write-Host "iso"
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
  Write-Host "mame"
  Write-Host "raine"

  exit 1
}
