# TODO (minor) - improve errorlevel break
param (
  [string] $op,
  [string] $killTime
)

function compileProject($name) {
  pushd ..\projects\$name
  .\mak.bat clean
  if ($LASTEXITCODE -ne 0) { Write-Host "break"; Write-Host $env:error; break }
  .\mak.bat raine
  if ($LASTEXITCODE -ne 0) { break }
  sleep $killTime
  popd
}

function _main {
  write-host $op $makeArg $killTime
  compileProject "bullet"
  compileProject "collide"
  compileProject "collide_complex"
  compileProject "collide_multiple"
  compileProject "DATdemo"
  compileProject "fixed_value"
  compileProject "hello"
  compileProject 'joypad'
  compileProject "shrunk"
  compileProject "shrunk_centroid"

  # runProject "shrunk_physic" --todo

  compileProject "sprite"
  compileProject "test_animated_sprite"
  compileProject "test_animated_sprite_physic"
  compileProject "test_image"
  compileProject "test_image_physic"
  compileProject "test_palettemanager"
  compileProject "test_same_palette"
  compileProject "test_scroller"
  compileProject "test_spritemanager"
}

_main $op $makeArg $killTime