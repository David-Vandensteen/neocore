# Neocore
![Platform](https://img.shields.io/badge/platform-%20%7C%20windows-lightgrey) ![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)  
  
![](https://media.giphy.com/media/TLfbmyW3523z24WONz/giphy.gif) ![](https://media.giphy.com/media/iFUh5AEPD4XfvpsvJh/giphy.gif) ![](https://media.giphy.com/media/iJObJsdx6ud4zI7cS1/giphy.gif)


Neocore is a library and toolchain for developing on Neo Geo CD.  
It provides high-level functions over Neo Dev Kit and DATlib 0.2, and includes tools and code that can help with projects on this platform.  
The library is mainly tested on Raine and MAME emulators and is compatible with Windows 10 and Windows 11 for building.
  
I share my tools and my code, these could possibly help your projects on this platform.  

## Doc

  - Doxygen : http://azertyvortex.free.fr/neocore-doxy/r4/neocore_8h.html
  - Snippet : https://github.com/David-Vandensteen/neocore/tree/develop/snippet

### Game, demo, code learning

  - Pong : https://github.com/David-Vandensteen/neogeo-cd-pong
    
## Feature

 - High-level functions for Neo Geo CD development
 - Tools and code to assist with projects
 - Tested on Raine and MAME emulators
 - Compatible with Windows 10 and Windows 11

## Note
Please note that the library is under development and unoptimized, and the author is not responsible for any software damage.

## License

Neocore is licensed under the MIT license.  
Copyright 2019 by David Vandensteen.  
Some graphics by **Grass**.    

    
## Build and run (with Mame) a included example
```cmd
cd samples\hello
.\mak.bat run
```
  
## Mak rules
___***Warn : mak script override path environment variable during the compiling, if u have some problems after using it, just close and restart a new command terminal***___

- Clean the builded resources
```cmd
.\mak.bat clean
```
- Build sprites
```cmd
.\mak.bat sprite
```
- Build the program
```cmd
.\mak.bat
```
- Build the ISO file
```cmd
.\mak.bat iso
```
- **Run with Raine**
```cmd
.\mak.bat raine
```
- **Run with Mame**
```cmd
.\mak.bat mame
```
or
```cmd
.\mak.bat run
```
- Delivery ISO and Mame
```cmd
.\mak.bat dist
```
## Create your first experimentation
```cmd
xcopy /E /I bootstrap\sample samples\awesome_project
```

Edit project.xml and set the project name  
```cmd
notepad samples\awesome_project\project.xml
```

```xml
<project>
  <name>awesome_project</name>
...
```

Compile and run it  

```cmd
cd samples\awesome_project
.\mak.bat run
```

See `.\samples\awesome_project\project.xml`  
and `.\samples\awesome_project\sprites.xml`  
for settings.

## "Hot reload"
```cmd
cd samples\hello
.\mak.bat serve
```
  
Wait the running of the emulator and edit projects\hello\main.c  
Now, remove **loggerInfo("DAVID VANDENSTEEN");** (for example)  
Save the file
  
The hot-reload process will rebuild & run your project automaticaly.
  
Some problems currently:  
* The process is not a real watcher (the rebuild is triggered only if the folder size change)  
* When you break this process, path is not restored in the current terminal (close & reopen a new terminal)  
    
## CDDA
``` cmd
cd samples\CDDA
.\download-assets
.\mak.bat run
```
  
In the emulator, use joypad right and left to change audio track.  
See `.\samples\CDDA\project.xml` for understanding how to set the audio file.

## Create a "standalone" project
With powershell (you need to "be" in neocore folder root path)
```cmd
$project = "c:\my-git\myGame"
```
* Replace `c:\my-git\myGame` with your real path. 

```cmd
xcopy /E /I src-lib $project\neocore\src-lib; copy manifest.xml $project\neocore; copy bootstrap\.gitignore $project\.gitignore; xcopy /E /I toolchain $project\neocore\toolchain; xcopy /E /I bootstrap\standalone $project\src; notepad $project\src\project.xml
```

## DATlib assets (in progress)
For making your own graphics, see the DATlib ref available here: (you need to building a sample for init build folder)  
```cmd
.\build\neodev-sdk\doc\DATlib-LibraryReference.pdf
```
  
DATlib Framer tool is available here:  
```cmd
.\build\neodev-sdk\m68k\bin\Framer.exe
```
The Animator tool is available here:  
```cmd
.\build\neodev-sdk\m68k\bin\Animator.exe
```

## Compiling the lib (necessary if you develop Neocore lib)
```cmd
cd src-lib
.\build-neocore.bat -gccPath ..\build\gcc\gcc-2.95.2 -includePath ..\build\include -libraryPath ..\build\lib
```
This script override path environment variable during the compilation.  
its avoid collisions with other bin, sdk, gcc...  
If sdk was not found, build a sample (with mak script) to initialize cache (sdk will install in build folder).  


## Pull or checkout another branches
**BE CAREFUL : You need to remove build folder `.\build` for supress cache files before compiling a project**  


## SoundFX ... (todo)
## Use Neocore toolchain for DATlib project (without Neocore lib) (todo)
## Use Neocore toolchain for Neodev vanilla project (without DATlib & Neocore lib) (todo)
