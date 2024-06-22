# Neocore
![Platform](https://img.shields.io/badge/platform-%20%7C%20windows-lightgrey) ![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)  
  
![](https://media.giphy.com/media/TLfbmyW3523z24WONz/giphy.gif) ![](https://media.giphy.com/media/iFUh5AEPD4XfvpsvJh/giphy.gif) ![](https://media.giphy.com/media/iJObJsdx6ud4zI7cS1/giphy.gif)


Neocore is a library and toolchain for developing on Neo Geo CD.  
It provides high-level functions over Neo Dev Kit and DATlib 0.2, and includes tools and code that can help with projects on this platform.  
The library is compatible with ~~Windows 10 and~~ Windows 11 for building.
  
I share my tools and my code, these could possibly help your projects on this platform.  

## Note

Please note that the library is under development and unoptimized, and the author is not responsible for any software damage.  
This project is mainly tested on Raine and MAME emulators.  
  
**There is no guarantee or obligation from the author that anything will work on the real Neo-Geo hardware.**  

To test and improve compatibility with the hardware, I am searching for a Neo-Geo CD with an SD loader and HDMI capabilities.  
You can contribute to this effort with a donation if you want.

[Make a Paypal donation to help developer](https://www.paypal.com/donate/?hosted_button_id=YAHAJGP58TYM4)

## Features

 - High abstraction level for Neo Geo CD development
 - Tools and code to assist with projects
 - Compatible with ~~Windows 10 and~~ Windows 11

### Game, demo, code learning using Neocore

  - Pong : https://github.com/David-Vandensteen/neogeo-cd-pong
  - Flamble :
      -  [https://twitter.com/i/status/1296434554526478336](https://twitter.com/i/status/1296434554526478336)
      -  [https://www.youtube.com/embed/YjRmvMAfgbc](https://www.youtube.com/embed/YjRmvMAfgbc)
      -  [http://azertyvortex.free.fr/flamble](http://azertyvortex.free.fr/flamble)

## Documentation of Neocore C lib

  - Doxygen: [http://azertyvortex.free.fr/neocore-doxy/r6/neocore_8h.html](http://azertyvortex.free.fr/neocore-doxy/r6/neocore_8h.html)
    
## Init
```cmd
git clone git@github.com:David-Vandensteen/neocore.git
```
    
## Build and run hello example
```cmd
cd .\neocore\samples\hello
.\mak.bat run:mame
```
  
## Mak rules
___***Warning: The mak script overrides the path environment variable during compilation.  
If you encounter any problems after using it, simply close and restart a new command terminal.***___

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
.\mak.bat run:raine
```
- **Run with Mame**
```cmd
.\mak.bat run:mame
```
- Delivery ISO
```cmd
.\mak.bat dist:iso
```
- Delivery MAME
```cmd
.\mak.bat dist:mame
```

## Hot reload
From `neocore\samples\hello` folder
```cmd
.\mak.bat serve
```
  
Wait for the emulator to run and edit `main.c`.  
Now, remove `loggerInfo("DAVID VANDENSTEEN");` (for example).  
Save the file.
  
The hot-reload process will rebuild & run your project automaticaly.
  
Some problems currently:  
* The process is not a real watcher (the rebuild is triggered only if the folder size change)  
* When you break this process, path is not restored in the current terminal (close & reopen a new terminal)  
    
## CDDA
From `neocore\samples\CDDA`
``` cmd
.\download-assets
.\mak.bat run:mame
```
  
In the emulator, use joypad right and left to change audio track.  
See `neocore\s\CDDA\project.xml` for understanding how to set the audio file.

## Create a project
With powershell (you need to "be" in neocore folder root path)
```cmd
$project = "c:\my-git\myGame"
```
* Replace `c:\my-git\myGame` with your real path. 

```cmd
xcopy /E /I src-lib $project\neocore\src-lib; copy manifest.xml $project\neocore; copy bootstrap\.gitignore $project\.gitignore; xcopy /E /I toolchain $project\neocore\toolchain; xcopy /E /I bootstrap\standalone $project\src; notepad $project\src\project.xml
```

Compile and run it  

```cmd
cd $project
.\mak.bat run:mame
```

See `.\$project\project.xml`  
for settings.


## DATlib assets (in progress)
For making your own graphics, see the DATlib ref available here: (you need to building a  for init build folder)  
```cmd
.\neocore\build\neodev-sdk\doc\DATlib-LibraryReference.pdf
```
  
The DATlib Framer tool is available here:    
```cmd
.\neocore\build\neodev-sdk\m68k\bin\Framer.exe
```
The DATlib Animator tool is available here:  
```cmd
.\neocore\build\neodev-sdk\m68k\bin\Animator.exe
```

## Compiling the lib (necessary if you develop Neocore lib)
```cmd
cd neocore\src-lib
.\build-neocore.bat -gccPath ..\build\gcc\gcc-2.95.2 -includePath ..\build\include -libraryPath ..\build\lib
```
This script override path environment variable during the compilation.  
its avoid collisions with other bin, sdk, gcc...  
If sdk was not found, build a sample (with mak script) to initialize cache (sdk will install in build folder).  


## Pull or checkout another branches
**BE CAREFUL : You need to remove build folder `.\neocore\build` for supress cache files before compiling a project**  

## Dependencies

  - NeoDev
  - DATlib
  - DATimage
  - NGFX SoundBuilder
  - Raine
  - Mame
  - CHDMAN
  - Doxygen
  - MSYS2
  - Mkisofs
  - GCC
  - mpg123
  - ffmpeg

## [Changelog](CHANGELOG.md)

## License

Neocore is licensed under the MIT license.  
Copyright 2019 by David Vandensteen.  
Some graphics by **Grass**.    

