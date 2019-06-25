# Neocore
Library &amp; toolchain for Neo Geo CD develop.

Neocore provide high level functions over Neo Dev Kit (by Fabrice Martinez, Jeff Kurtz, al) & DATLib 0.2 (by HPMAN) 
Makefile have easy rules (make sprite, make zip, make iso, make cue, make run...)   

#

## Set Up
```cmd
install.bat
```
This script download sdk, emulator (Raine), CD structure template ... everything you need to do a Neo Geo CD project      
After install, all is available from   
```cmd
%appdata%\neocore   
```



#

## Compiling the lib
```cmd
setPath.bat
make
```
setPath override the path variable (to resolve make and extra bin)

#

## Make Hello
```cmd
pushd projects\hello && make run && popd
```
#

## Make your first project
```cmd
make init-project
Project name : myfirst
```
A new folder (projects\\myfirst) has been scaffolded   
Now compile and run it:
```cmd
cd projects\myfirst
make run
```
The compiled resources output folder is:   
```cmd
%temp%\neocore\myfirst   
```

## Project clean rebuild
```cmd
pushd projects\hello && make clean && make init && make && popd
```

I'm writing Neocore for make my shoot em up game   
(Flamble) http://azertyvorte.free.fr/flamble

Maybe my code can help you !!!
#
