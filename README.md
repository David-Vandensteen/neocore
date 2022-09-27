# Neocore
![Platform](https://img.shields.io/badge/platform-%20%7C%20windows-lightgrey)![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)  
  
![](https://media.giphy.com/media/TLfbmyW3523z24WONz/giphy.gif) ![](https://media.giphy.com/media/iFUh5AEPD4XfvpsvJh/giphy.gif)![](https://media.giphy.com/media/iJObJsdx6ud4zI7cS1/giphy.gif)

Neocore is a library &amp; toolchain for developing on Neo Geo CD.  
I write Neocore to make my shoot em up game on Neo Geo CD (**Flamble**) http://azertyvortex.free.fr/flamble  

Neocore provide high level functions over Neo Dev Kit (**Fabrice Martinez, Jeff Kurtz, al**) & DATlib 0.2 (**HPMAN**)  
  
I share my tools and my code, these could possibly help your projects on this platform.  
(**Doxygen doc**) http://azertyvortex.free.fr/neocore-doxy/develop/  
  
***Lot of thing is under development and unoptimized ...***
***I'm not responsible for any software damage***  
  
*Tested on Windows 10 x64 (09/12/2022)*  
*Tested on Windows 11 (09/13/2022)*  
  
License: MIT  
(c) 2019 [David Vandensteen <dvandensteen@gmail.com>]  
Graphics by **Grass**  
  
## Set Up
```cmd
.\install.bat
```
This install script download sdk, emulators (Raine & Mame), CD structure template ... everything you need to make and build a Neo Geo CD project  
After install, all is available from
```cmd
%appdata%\neocore
```
**if you need to re-install, just remove %appdata%\neocore before launch install.bat**
  
## Compiling the lib
```cmd
.\build-neocore
```
This script override path environment variable during the compilation.  
its avoid collisions with other bin, sdk, gcc...  
**Whenever you pull or change branches, consider you need rebuilding the library.**
  
## Build a included example
```cmd
cd projects\hello
.\mak run
```
  
## Mak rules
Clean the builded resources
```cmd
.\mak clean
```
Build sprites
```cmd
.\mak sprite
```
Build the program
```cmd
.\mak
```
Build the ISO file
```cmd
.\mak iso
```
**Run with Raine**
```cmd
.\mak run:raine
```
**Run with Mame**
```cmd
.\mak run:mame
```
or
```cmd
.\mak run
```
## Make your first project
```cmd
.\build-neocore init-project
Project name : myfirst
```
A new folder (projects\\myfirst) has been scaffolded  
Now compile and run it:  
```cmd
cd projects\myfirst
.\mak run
```
The compiled resources output folder is:
```cmd
%temp%\neocore\myfirst
```  
## "Hot reload"
```cmd
cd projects\hello
.\mak serve
```
  
Wait the running of the emulator and edit projects\hello\main.c  
Now, remove **loggerInfo("DAVID VANDENSTEEN");** (for example)  
Save the file
  
The hot-reload process will rebuild & run your project automaticaly.
  
Some problems currently:  
* The process is not a real watcher (the rebuild is triggered only if the folder size change)  
* When you break this process, path is not restored in the current terminal (close & reopen a new terminal)  
    
## CDDA play ... (in progress)
``` cmd
cd projects\CDDA
.\download-assets
.\mak run
```
  
In the emulator, use joypad right and left to change audio track  
See projects\CDDA\project.xml for set the audio file
  
## DATlib assets (in progress)
For making your own graphics, see the DATlib ref available here: (after install)  
%appdata%\neocore\neodev-sdk\DATlib-LibraryReference.pdf
  
DATlib Framer tool is available here:  
%appdata%\neocore\neodev-sdk\m68k\bin\Framer.exe
  
The Animator tool is available here:  
%appdata%\neocore\neodev-sdk\m68k\bin\Animator.exe
  
## SoundFX ... (todo)
  
___***Warn : mak script override path environment variable during the compiling, if u have some problems after using it, just close and restart a new command terminal***___