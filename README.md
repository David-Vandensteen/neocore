
# Neocore Samples

collide, shrunking, sprite ...

  

![](https://media.giphy.com/media/TLfbmyW3523z24WONz/giphy.gif)

![](https://media.giphy.com/media/iFUh5AEPD4XfvpsvJh/giphy.gif)

![](https://media.giphy.com/media/iJObJsdx6ud4zI7cS1/giphy.gif)

  

***See more samples in projects folder***

  
  

# Neocore

Library &amp; toolchain for Neo Geo CD develop.

  

I write Neocore to make my shoot em up game on Neo Geo CD

(**Flamble**) http://azertyvortex.free.fr/flamble

  

Neocore provide high level functions over Neo Dev Kit (**Fabrice Martinez, Jeff Kurtz, al**) & DATLib 0.2 (**HPMAN**)

The mak script contain many rules (mak sprite, mak zip, mak iso, mak cue, mak run, mak serve...)

  

I share my tools and my code, these could possibly help your projects on this platform !!!

  

(**Doxygen doc**) http://azertyvortex.free.fr/neocore-doxy/develop/

  

***Lot of thing is under development and unoptimized ...***

***I'm not responsible for any software damage ***

  

*Tested on Windows 10 x64 (09/12/2022)*

*Tested on Windows 11 (09/13/2022)*

  

License: MIT

(c) 2019 [David Vandensteen <dvandensteen@gmail.com>]

Graphics by **Grass**

  



  

## Set Up

```cmd

.\install.bat

```

The install script download sdk, emulators (Raine & Mame), CD structure template ... everything you need to do a Neo Geo CD project

After install, all is available from

```cmd

%appdata%\neocore

```

  

**if you need to re-install, just remove %appdata%\neocore before launch install.bat**

#

  

## Compiling the lib

```cmd

.\mak

```

mak overwrite path environment variable during the compilation.

its avoid collisions with other bin, sdk, gcc...

  

**Whenever you pull or change branches, consider you need rebuilding the library.**

  

#

  

## Make Hello

```cmd

cd projects\hello

.\mak run

```

#

  

## Make your first project

```cmd

.\mak init-project

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

## Run

With Raine

```cmd

.\mak run:raine

```

  

With Mame

```cmd

.\mak run:mame

```

  

## Project clean

```cmd

cd projects\hello

.\mak clean

```

  

## "Hot reload"

```cmd

cd projects\hello

.\mak serve

```

Wait the running of the emulator and edit projects\hello\main.c

Remove **loggerInfo("DAVID VANDENSTEEN");** (for example)

Save the file

  

The hot-reload process will rebuild & run your project automaticaly.

  

Some problems currently:

* The process is not a real watcher (the rebuild is triggered only if the folder size change)

* When you break this process, path is not restored in the current terminal (close & reopen a new terminal)

  

## Make ISO

```cmd

cd projects\hello

.\mak iso

```

  

## CDDA play ... (in progress)

``` cmd
cd projects\CDDA
.\download-assets
.\mak run
```
In the emulator, use joypad right and left to change audio track  
See projects\CDDA\project.xml for set the audio file

## DATlib GFX asset build doc... (todo)

how to build your own gfx...

## SoundFX ... (todo)

  

___***Warn : mak script override path environment variable during the compiling, if u have some problems after using it, just close and restart a new command terminal***___