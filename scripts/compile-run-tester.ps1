# todo (minor) - test errorlevel break
param (
  [string] $op,
  [string] $makeArg,
  [string] $killTime
)

function compileProject($name) {
  pushd ..\projects\$name
  .\mak.bat clean
  if ($LASTEXITCODE -ne 0) { Write-Host "break"; Write-Host $env:error; break }
  .\mak.bat
  if ($LASTEXITCODE -ne 0) { break }
  popd
}

function runProject($name) {
  pushd ..\projects\$name
  .\mak.bat $makeArg
  if ($LASTEXITCODE -ne 0) { break }
  sleep $killTime
  popd
}

function _main {
  write-host $op $makeArg $killTime

  compileProject "bullet"
  runProject "bullet"

  compileProject "collide"
  runProject "collide"

  compileProject "collide_complex"
  runProject "collide_complex"

  compileProject "collide_multiple"
  runProject "collide_multiple"

  compileProject "fixed_value"
  runProject "fixed_value"

  compileProject "hello"
  runProject "hello"

  compileProject 'joypad'
  runProject 'joypad'

  compileProject "shrunk"
  runProject "shrunk"

  compileProject "shrunk_centroid"
  runProject "shrunk_centroid"

  # runProject "shrunk_physic" --todo

  compileProject "sprite"
  runProject "sprite"

  compileProject "test_animated_sprite"
  runProject "test_animated_sprite"

  compileProject "test_animated_sprite_physic"
  runProject "test_animated_sprite_physic"

  compileProject "test_image"
  runProject "test_image"

  compileProject "test_image_physic"
  runProject "test_image_physic"

  compileProject "test_same_palette"
  runProject "test_same_palette"

  compileProject "test_scroller"
  runProject "test_scroller"
}

_main $op $makeArg $killTime