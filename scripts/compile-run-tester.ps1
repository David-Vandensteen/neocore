# todo - test errorlevel break
param (
  [string] $op
)

function compileProject($name, $withSprite) {
  pushd ..\projects\$name
  .\mak.bat clean
  if ($LASTEXITCODE -ne 0) { Write-Host "break"; Write-Host $env:error; break }
  .\mak.bat init
  if ($LASTEXITCODE -ne 0) { break }
  if ($withSprite) { .\mak.bat sprite }
  if ($LASTEXITCODE -ne 0) { break }
  .\mak.bat
  if ($LASTEXITCODE -ne 0) { break }
  popd
}

function runProject($name) {
  pushd ..\projects\$name
  .\mak.bat run
  if ($LASTEXITCODE -ne 0) { break }
  sleep 10
  popd
}

function compileProjects {
  compileProject "collide" 1
  compileProject "collide-complex" 1
  compileProject "collide-multiple" 1
  compileProject "fixed-value"
  compileProject "hello"
  compileProject 'joypad'
  compileProject "shrunk-centroid" 1
  # compileProject "shrunk-physic" 1 --todo
  compileProject "shrunk" 1
  compileProject "sprite" 1
  compileProject "test_animated_sprite" 1
  compileProject "test_animated_sprite_physic" 1
  compileProject "test_image" 1
  compileProject "test_image_physic" 1
}

function runProjects {
  runProject "collide"
  runProject "collide-complex"
  runProject "collide-multiple"
  runProject "fixed-value"
  runProject "hello"
  runProject 'joypad'
  runProject "shrunk-centroid"
  # runProject "shrunk-physic" --todo
  runProject "shrunk"
  runProject "sprite"
  runProject "test_animated_sprite"
  runProject "test_animated_sprite_physic"
  runProject "test_image"
  runProject "test_image_physic"
}

function _main {
  write-host $op
  if ($op -eq "compile") { compileProjects }
  if ($op -eq "run") { runProjects }
}

_main $op