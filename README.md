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
- Delivery EXE *(create a Windows standalone executable with the game project and Mame emulator embedded)*
```cmd
.\mak.bat dist:exe
```
## Create a project
In Windows run prompt (shortcut windows + r) type :
```cmd
wt cmd
```

* Clone the lastest Neocore version repository by copying and paste the following commands in the terminal
```cmd
if not exist %temp%\neocore (
  git clone git@github.com:David-Vandensteen/neocore.git %temp%\neocore
  cd %temp%\neocore
) else (
  echo %temp%\neocore already exist
)

```

* Now copy the next command and replace `%USERPROFILE%\myGame` with your real path. 

```cmd
set project="%USERPROFILE%\myGame"

```
* Copy and paste the following for create the project
```cmd
if not exist %project% (
  xcopy /E /I src-lib %project%\neocore\src-lib
  copy manifest.xml %project%\neocore
  copy bootstrap\.gitignore %project%\.gitignore
  xcopy /E /I toolchain %project%\neocore\toolchain
  xcopy /E /I bootstrap\standalone %project%\src
  pushd %project%
  notepad src\project.xml
  popd
) else (
  echo %project% already exist
)

```

* Compile and run it  

```cmd
cd %project%\src
.\mak.bat run:mame

```

## Upgrade the toolchain in an existing project
* It is recommended to back up your project before starting
* This process does not upgrade your code, XML project definition or assets. You must handle any breaking changes yourself
* The files mak.bat and mak.ps1 will be overwritten

With cmd (*not Powershell*) you need to "be" in neocore folder root path

* Replace `%USERPROFILE%\myGame` with your real path.

```cmd
set project="%USERPROFILE%\myGame"

```
```cmd
set project_build="%project%\build"
set project_src="%project%\src"
set project_neocore="%project%\neocore"

```

* Check Neocore version
```cmd
type manifest.xml | find "<version>"
```

* Check Neocore version in your project
```cmd
type %project_neocore%\manifest.xml | find "<version>"
```

* Remove `build` folder

```cmd
if exist %project_build% (
  rd /S /Q %project%\build
)

```

* Upgrade toolchain
```cmd
if exist %project_neocore% (
  robocopy /MIR src-lib %project_neocore%\src-lib
  copy /Y manifest.xml %project_neocore%
  robocopy /MIR toolchain %project_neocore%\toolchain
) else (
  echo %project_neocore% not found
)

if exist %project_src% (
  copy /Y bootstrap\standalone\mak.bat %project_src%
  copy /Y bootstrap\standalone\mak.ps1 %project_src%
) else (
  echo %project_src% not found
)

```

## Documentation of Neocore C lib

  - Doxygen: [http://azertyvortex.free.fr/neocore-doxy/r7/neocore_8h.html](http://azertyvortex.free.fr/neocore-doxy/r7/neocore_8h.html)
    
## Note

Please note that the library is under development and the author is not responsible for any software damage.  
This project is mainly tested on Raine and MAME emulators.  
  
**There is no guarantee or obligation from the author that anything will work on the real Neo-Geo hardware.**  

To test and improve compatibility with the hardware, I am searching for a Neo-Geo CD with an SD loader and HDMI capabilities.  
You can contribute to this effort with a donation if you want.

[Make a Paypal donation to help Neocore project](https://www.paypal.com/donate/?hosted_button_id=YAHAJGP58TYM4)

Here are other ways to contribute:

- If you own a Neo-Geo CD, you can test the examples and open or confirm issues on real hardware.  
- If you are a developer, you can create tutorials or example code.

Any help is welcome.  

## Hot reload
From `neocore\samples\hello` folder
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
    
## DATlib assets
For making graphics, see the DATlib ref available here: 
[http://azertyvortex.free.fr/download/DATlib-LibraryReference.pdf](http://azertyvortex.free.fr/download/DATlib-LibraryReference.pdf)   

Neocore embed the `chardata.xml` in `project.xml`   

```xml
<project>
  <gfx>
    <DAT>
      <chardata>
      </chardata>
    </DAT>
  </gfx>
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

## Compiling the lib (necessary if you develop Neocore lib)
```cmd
cd neocore\src-lib
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

