param (
  [Parameter(Mandatory=$true)][String] $Rule
)

function BuildProject {
  param (
    [Parameter(Mandatory=$true)][String] $Path,
    [Parameter(Mandatory=$true)][String] $Rule
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
  popd
}

function Main {
  param (
    [Parameter(Mandatory=$true)][String] $Rule
  )
  Write-Host "rule : $Rule" -ForegroundColor Yellow

  BuildProject -Path "..\samples\bullet" -Rule $Rule
  BuildProject -Path "..\samples\CDDA" -Rule $Rule
  BuildProject -Path "..\samples\collide" -Rule $Rule
  BuildProject -Path "..\samples\collide_complex" -Rule $Rule
  BuildProject -Path "..\samples\collide_multiple" -Rule $Rule
  BuildProject -Path "..\samples\custom_fix" -Rule $Rule
  BuildProject -Path "..\samples\DATdemo" -Rule $Rule
  BuildProject -Path "..\samples\hello" -Rule $Rule
  BuildProject -Path "..\samples\job_meter" -Rule $Rule
  BuildProject -Path "..\samples\joypad" -Rule $Rule
  BuildProject -Path "..\samples\math" -Rule $Rule
  BuildProject -Path "..\samples\pal_backdrop" -Rule $Rule
  BuildProject -Path "..\samples\pal_rgb" -Rule $Rule
  BuildProject -Path "..\samples\pal_rgb_mixer" -Rule $Rule
  BuildProject -Path "..\samples\palette_swap" -Rule $Rule
  BuildProject -Path "..\samples\recurse" -Rule $Rule
  BuildProject -Path "..\samples\shrunk" -Rule $Rule
  BuildProject -Path "..\samples\shrunk_centroid" -Rule $Rule
  BuildProject -Path "..\samples\soundFX" -Rule $Rule
  BuildProject -Path "..\samples\soundFX_poly" -Rule $Rule
  BuildProject -Path "..\samples\sprite" -Rule $Rule
  BuildProject -Path "..\samples\sprite_id" -Rule $Rule
  BuildProject -Path "..\samples\test_copy_palettes" -Rule $Rule
  BuildProject -Path "..\samples\test_gas" -Rule $Rule
  BuildProject -Path "..\samples\test_gasp" -Rule $Rule
  BuildProject -Path "..\samples\test_gp" -Rule $Rule
  BuildProject -Path "..\samples\test_gpp" -Rule $Rule
  BuildProject -Path "..\samples\test_gs" -Rule $Rule
  BuildProject -Path "..\samples\test_limit" -Rule $Rule
  BuildProject -Path "..\samples\test_palettemanager" -Rule $Rule
  BuildProject -Path "..\samples\test_same_palette" -Rule $Rule
  BuildProject -Path "..\samples\test_spritemanager" -Rule $Rule
}

Main -Rule $Rule