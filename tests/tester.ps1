param (
  [Parameter(Mandatory=$true)][String] $Rule,
  [string] $KillTime
)

function BuildProject {
  param (
    [Parameter(Mandatory=$true)][String] $Path,
    [Parameter(Mandatory=$true)][String] $Rule,
    [string] $KillTime = 0
  )
  Write-Host "build $path" -ForegroundColor Yellow
  if ((Test-Path -Path $Path) -eq $false) {
    Write-Host "error: $path no found" -ForegroundColor Red
    exit 1
  }
  pushd $Path
  if ($Path -eq "..\samples\CDDA") { .\download-assets.bat }
  .\mak.ps1 $Rule
  if ($LASTEXITCODE -ne 0) { break }
  sleep $KillTime
  popd
}

function Main {
  param (
    [Parameter(Mandatory=$true)][String] $Rule,
    [string] $KillTime = 0
  )
  Write-Host "rule : $Rule" -ForegroundColor Yellow
  Write-Host "killtime :  $KillTime" -ForegroundColor Yellow

  BuildProject -Path "..\samples\bullet" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\CDDA" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\collide" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\collide_complex" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\collide_multiple" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\DATdemo" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\math" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\hello" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\joypad" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\palette_swap" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\recurse" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\shrunk" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\shrunk_centroid" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\soundFX" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\soundFX_poly" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\sprite" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\test_gas" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\test_gasp" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\test_gp" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\test_gpp" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\test_gs" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\test_limit" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\test_palettemanager" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\test_same_palette" -Rule $Rule -KillTime $KillTime
  BuildProject -Path "..\samples\test_spritemanager" -Rule $Rule -KillTime $KillTime
}

Main -Rule $Rule -KillTime $KillTime