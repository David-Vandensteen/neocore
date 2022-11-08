# Neocore
![Platform](https://img.shields.io/badge/platform-%20%7C%20windows-lightgrey) ![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)  
  
![](https://media.giphy.com/media/TLfbmyW3523z24WONz/giphy.gif) ![](https://media.giphy.com/media/iFUh5AEPD4XfvpsvJh/giphy.gif) ![](https://media.giphy.com/media/iJObJsdx6ud4zI7cS1/giphy.gif)

Neocore is a library &amp; toolchain for developing on Neo Geo CD.  

Neocore provide high level functions over Neo Dev Kit (**Fabrice Martinez, Jeff Kurtz, al**) & DATlib 0.2 (**HPMAN**)  
  
I share my tools and my code, these could possibly help your projects on this platform.  
(**Doxygen doc**) http://azertyvortex.free.fr/neocore-doxy/r2/neocore_8h.html  
  
***Lot of thing is under development and unoptimized ...***
***I'm not responsible for any software damage***  
  
*Tested on Windows 10 x64 (2022-10-08)* (commit: 4558f94e6eea4cbb4fe28dcab5190995e3fe3a02)  
*Tested on Windows 11 (2022-09-13)* (commit: bf49e7935ab66b7abefc4fda89d9865b533c6469)
  
Compatibility : the lib is mainly tested on Raine & Mame emulators.    

License: MIT  
(c) 2019 [David Vandensteen <dvandensteen@gmail.com>]  
Some graphics by **Grass**  
    
## Build and run (with Mame) a included example
```cmd
cd samples\hello
.\mak run
```
  
## Mak rules
___***Warn : mak script override path environment variable during the compiling, if u have some problems after using it, just close and restart a new command terminal***___

- Clean the builded resources
```cmd
.\mak clean
```
- Build sprites
```cmd
.\mak sprite
```
- Build the program
```cmd
.\mak
```
- Build the ISO file
```cmd
.\mak iso
```
- **Run with Raine**
```cmd
.\mak run:raine
```
- **Run with Mame**
```cmd
.\mak run:mame
```
or
```cmd
.\mak run
```
- Delivery ISO and Mame
```cmd
.\mak dist
```
## Create your first experimentation
```cmd
xcopy /E /I templates\sample samples\awesome-project
```

Edit project.xml and set the project name  
```cmd
notepad samples\awesome-project\config\project.xml
```

```xml
<project>
  <name>awesome-project</name>
```

Compile and run it  

```cmd
cd samples\awesome-project
.\mak run
```

See `.\samples\awesome-project\config\project.xml`  
and `.\samples\awesome-project\config\sprites.xml`  
for settings.

## "Hot reload"
```cmd
cd samples\hello
.\mak serve
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
.\mak run
```
  
In the emulator, use joypad right and left to change audio track.  
See `.\samples\CDDA\config\project.xml` for understanding how to set the audio file.

## Create a "standalone" project
With powershell
```cmd
$project = "c:\my-git\my-game"
```
* Replace `c:\my-git\my-game` with your real path. 

```cmd
xcopy /E /I src-lib $project\neocore\src-lib
copy manifest.xml $project\neocore
copy templates\.gitignore $project\.gitignore
xcopy /E /I toolchain $project\neocore\toolchain
xcopy /E /I templates\project $project\src
echo Edit project.xml and set the project name
notepad $project\src\config\project.xml
```
With cmd
```cmd
set project="c:\my-git\my-game"
```
* Replace `c:\my-git\my-game` with your real path. 

```cmd
xcopy /E /I src-lib %project%\neocore\src-lib
copy manifest.xml %project%\neocore
copy templates\.gitignore %project%\.gitignore
xcopy /E /I toolchain %project%\neocore\toolchain
xcopy /E /I templates\project %project%\src
echo Edit project.xml and set the project name
notepad %project%\src\config\project.xml
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
.\build-neocore.bat
```
This script override path environment variable during the compilation.  
its avoid collisions with other bin, sdk, gcc...  
If sdk was not found, build a sample (with mak script) to initialize cache (sdk will install in build folder).  


## Pull or checkout another branches
**BE CAREFUL : You need to remove build folder `.\build` for supress cache files before compiling a project**  


## SoundFX ... (todo)
## Use Neocore toolchain for DATlib project (without Neocore lib) (todo)
## Use Neocore toolchain for Neodev vanilla project (without DATlib & Neocore lib) (todo)
