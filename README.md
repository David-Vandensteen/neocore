# Neocore
Library &amp; toolchain for Neo Geo CD develop.

I'm **David Vandensteen** and i write Neocore for my shoot em up game on Neo Geo CD   
(**Flamble**) http://azertyvortex.free.fr/flamble

Neocore provide high level functions over Neo Dev Kit (**Fabrice Martinez, Jeff Kurtz, al**) & DATLib 0.2 (**HPMAN**)    
My Makefile have easy rules (make sprite, make zip, make iso, make cue, make run...)   

I share my tools and my code, these could possibly help your projects on this platform !!!   

***Lot of thing is under development and unoptimized ...***   
***I'm not responsible for any software damage on your computer***   

Licence: MIT   
(c) 2019 [David Vandensteen <dvandensteen@gmail.com>]


#

## Set Up
```cmd
install.bat
```
The install script download sdk, emulator (Raine), CD structure template ... everything you need to do a Neo Geo CD project      
After install, all is available from   
```cmd
%appdata%\neocore   
```

#

## Compiling the lib
```cmd
mak
```
mak overwrite path environement variable during the execution...   
its avoid collisions with other bin, sdk, gcc...   

#

## Make Hello
```cmd
pushd projects\hello && mak run && popd
```
#

## Make your first project
```cmd
mak init-project
Project name : myfirst
```
A new folder (projects\\myfirst) has been scaffolded   
Now compile and run it:
```cmd
cd projects\myfirst
mak run
```
The compiled resources output folder is:   
```cmd
%temp%\neocore\myfirst   
```

## Project clean rebuild
```cmd
pushd projects\hello && mak clean && mak init && mak && popd
```
#
**soon sample dev:**  
Sprites, scroller, collision, mini shoot em up ...


#
