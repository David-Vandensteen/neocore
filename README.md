# Neocore
![Platform](https://img.shields.io/badge/platform-%20%7C%20windows-lightgrey) ![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)  
  
![](https://media.giphy.com/media/TLfbmyW3523z24WONz/giphy.gif) ![](https://media.giphy.com/media/iFUh5AEPD4XfvpsvJh/giphy.gif) ![](https://media.giphy.com/media/iJObJsdx6ud4zI7cS1/giphy.gif)


Neocore is a library and toolchain for developing on Neo Geo CD.  
It provides functions over Neo Dev Kit and DATlib 0.2, and includes tools and code that can help with projects on this platform.  

 - High abstraction level for Neo Geo CD development
 - Compatible with ~~Windows 10 and~~ Windows 11

### Game, demo, code learning using Neocore

  - Pong : https://github.com/David-Vandensteen/neogeo-cd-pong
  - Flamble :
    -  [https://twitter.com/i/status/1296434554526478336](https://twitter.com/i/status/1296434554526478336)
    -  [https://www.youtube.com/embed/YjRmvMAfgbc](https://www.youtube.com/embed/YjRmvMAfgbc)
    -  [http://azertyvortex.free.fr/flamble](http://azertyvortex.free.fr/flamble)

## Requirements
* Up to date Windows 11
* Git [https://git-scm.com/download/win](https://git-scm.com/download/win)
* Windows Terminal with cmd instance (shortcut win + r and type `wt cmd`)

## Init
```cmd
git clone https://github.com/David-Vandensteen/neocore.git
```
    
## Build and run the hello sample
```cmd
cd .\neocore\samples\hello
```
```cmd
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
- Display version information
```cmd
.\mak.bat --version
```
## Create a project
* Go to the folder where you've cloned this Neocore repository (*replace `<neocore>` with your path in the following command*)
```cmd
cd <neocore>\bootstrap\scripts\project
```

* Replace `myGame` and `c:\temp\myGame` with your data in the following command

```cmd
.\create.bat -name myGame -projectPath c:\temp\myGame
```

* Go to the `src` folder project (*replace `c:\temp\myGame\src` with your path in the following command*)
```cmd
cd c:\temp\myGame\src
```

* Compile and run it
```cmd
.\mak.bat run:mame
```

## Upgrade an existing project
*It's recommended to back up your project folder before starting.*   
*This process does not upgrade your code, XML project definition, or assets and you must handle any breaking changes yourself.*   
*The files mak.bat and mak.ps1 will be overwritten.*   
*Neocore Toolchain will be replaced.*   
*Neocore Lib C will be replaced.*   

* Remove the `build` folder in your project (*replace `c:\temp\myGame\build` with your path in the following command*)

```cmd
rd /S /Q c:\temp\myGame\build
```

* Go to the folder where you've cloned this Neocore repository (*replace `<neocore>` with your path in the following command*)
```cmd
cd <neocore>\bootstrap\scripts\project
```

* For upgrading your project, replace `c:\temp\myGame\src` and `c:\temp\myGame\neocore` with your data in the following command
```cmd
.\upgrade.bat -projectSrcPath c:\temp\myGame\src -projectNeocorePath c:\temp\myGame\neocore
```

## Release a project
* Go to your src folder project (*replace `c:\temp\myGame\src` with your path in the following command*)
```cmd
cd c:\temp\myGame\src
```

- ISO
```cmd
.\mak.bat dist:iso
```
- MAME
```cmd
.\mak.bat dist:mame
```
- EXE *(create a Windows standalone executable with the game project and Mame emulator embedded)*
```cmd
.\mak.bat dist:exe
```

## Documentation of Neocore C lib

  - Doxygen: [http://azertyvortex.free.fr/neocore-doxy/r7/neocore_8h.html](http://azertyvortex.free.fr/neocore-doxy/r7/neocore_8h.html)
    
## Note

Please note that the project is under development and the author is not responsible for any software damage.  
This library is mainly tested on Raine and MAME emulators.  
  
**There is no guarantee or obligation from the author that anything will work on the real Neo-Geo hardware.**  

To test and improve compatibility with the hardware, I am searching for a Neo-Geo CD with an SD loader and HDMI capabilities.  
You can contribute to this effort with a donation if you want.

[Make a Paypal donation to help Neocore project](https://www.paypal.com/donate/?hosted_button_id=YAHAJGP58TYM4)

Here are other ways to contribute:

- If you own a Neo-Geo CD, you can test the examples and open or confirm issues on real hardware.  
- If you are a developer, you can create tutorials or example code.

Any help is welcome.  
    
## DATlib assets
For making graphics, see the DATlib ref available here: 
[http://azertyvortex.free.fr/download/DATlib-LibraryReference.pdf](http://azertyvortex.free.fr/download/DATlib-LibraryReference.pdf)   

Neocore embed the content of `chardata.xml` in `project.xml`   

```xml
<project>
  <gfx>
    <DAT>
      <chardata>
      </chardata>
    </DAT>
  </gfx>
</project>
```

For launching the DATlib Framer application:    
```cmd
.\mak.bat framer
```
For launching the DATlib Animator application:  
```cmd
.\mak.bat animator
```

## Pull or checkout another branches
**BE CAREFUL : You need to remove build folder `.\neocore\build` for supress cache files before compiling a project**  

## Hot reload
* Go to the folder where you've cloned this Neocore repository (*replace `<neocore>` with your path in the following command*)
```cmd
cd <neocore>\samples\hello
```
```cmd
.\mak.bat serve
```
  
Wait for the emulator to run and edit `main.c`.  
Now, remove `nc_log_info("DAVID VANDENSTEEN");` line.  
Save the file.
  
The hot-reload process will rebuild & run your project automaticaly.
  
Some problems currently:  
* The process is not a real watcher (the rebuild is triggered only if the folder size change)  
* When you break this process, path is not restored in the current terminal (close & reopen a new terminal)  

## Compiling the lib (necessary if you develop Neocore lib)

* Go to the folder where you've cloned this Neocore repository (*replace `<neocore>` with your path in the following command*)
```cmd
cd <neocore>\src-lib
```
```cmd
.\build-neocore.bat -gccPath ..\build\gcc\gcc-2.95.2 -includePath ..\build\include -libraryPath ..\build\lib
```
This script override path environment variable during the compilation.  
its avoid collisions with other bin, sdk, gcc...  
If sdk was not found, build a sample (with mak script) to initialize cache (sdk will install in build folder).  

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
  - NSIS

## [Changelog](CHANGELOG.md)
  - [link](CHANGELOG.md)

## License

Neocore is licensed under the MIT license.  
Copyright 2019 by David Vandensteen.  
Some graphics by **Grass**.    

