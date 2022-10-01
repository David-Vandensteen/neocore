# TODO (minor) - improve errorlevel break
param (
  [string] $op,
  [string] $killTime
)

function compileProject($name) {
  pushd ..\projects\$name
  .\mak.bat clean
  if ($name -eq "CDDA") { .\download-assets.bat }
  if ($LASTEXITCODE -ne 0) { Write-Host "break"; Write-Host $env:error; break }
  .\mak.bat run
  if ($LASTEXITCODE -ne 0) { break }
  sleep $killTime
  popd
}

function _main {
  write-host $op $makeArg $killTime
  compileProject "bullet"
  compileProject "CDDA"
  compileProject "collide"
  compileProject "collide_complex"
  compileProject "collide_multiple"
  compileProject "DATdemo"
  compileProject "fixed_value"
  compileProject "hello"
  compileProject "joypad"
  compileProject "palette_swap"
  compileProject "shrunk"
  compileProject "shrunk_centroid"
  compileProject "sprite"
  compileProject "test_animated_sprite"
  compileProject "test_animated_sprite_physic"
  compileProject "test_image"
  compileProject "test_image_physic"
  compileProject "test_limit"
  compileProject "test_palettemanager"
  compileProject "test_same_palette"
  compileProject "test_scroller"
  compileProject "test_spritemanager"
}

_main $op $makeArg $killTime