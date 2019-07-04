function collide{
  pushd ..\projects\collide
  .\mak.bat clean
  .\mak.bat init
  .\mak.bat sprite
  .\mak.bat
  popd
}

function collide-complex{
  pushd ..\projects\collide-complex
  .\mak.bat clean
  .\mak.bat init
  .\mak.bat sprite
  .\mak.bat
  popd
}

function collide-multiple{
  pushd ..\projects\collide-multiple
  .\mak.bat clean
  .\mak.bat init
  .\mak.bat sprite
  .\mak.bat
  popd
}

function fixed-value{
  pushd ..\projects\collide-multiple
  .\mak.bat clean
  .\mak.bat init
  .\mak.bat
  popd
}

function hello{
  pushd ..\projects\hello
  .\mak.bat clean
  .\mak.bat init
  .\mak.bat
  popd
}

function joypad{
  pushd ..\projects\hello
  .\mak.bat clean
  .\mak.bat init
  .\mak.bat
  popd
}

function shrunk{
  pushd ..\projects\shrunk
  .\mak.bat clean
  .\mak.bat init
  .\mak.bat sprite
  .\mak.bat
  popd
}

function sprite{
  pushd ..\projects\sprite
  .\mak.bat clean
  .\mak.bat init
  .\mak.bat sprite
  .\mak.bat
  popd
}

function _main{
  collide
  collide-complex
  collide-multiple
  fixed-value
  hello
  joypad
  shrunk
  sprite
}

_main