# TODO factorize, trap errorlevel
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

function _main{
  compileProject "collide" 1
  compileProject "collide-complex" 1
  compileProject "collide-multiple" 1
  compileProject "fixed-value"
  compileProject "hello"
  compileProject 'joypad'
  compileProject "shrunk" 1
  compileProject "shrunk-centroid" 1
  compileProject "sprite" 1
}

_main