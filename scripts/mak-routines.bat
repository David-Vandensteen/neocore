@echo off
rem TODO : fix mame hello project (disc error)
rem TODO : clean *.cue files
rem TODO : CUE with soundtrack // if exist *.wav $(CP) -f *.wav $(NEOBUILDTEMP)
rem TODO : rethink tree script folder
rem TODO : move char.bin
rem TODO : chd rule
rem TODO : patch bin.zip (remove useless exe)
rem TODO : improve test file
set FILE=Makefile
set NEOBUILDDATA=%appdata%\neocore
set NEOBUILDTEMP=%temp%\neocore\%PROJECT%
set HASHPATH=%NEOBUILDTEMP%\hash

set MAMEFOLDER=%NEOBUILDDATA%\mame
set MAMEHASH=%MAMEFOLDER%\hash\neocd.xml
set RAINE=%NEOBUILDDATA%\raine\raine32.exe

set ISONAME=%PROJECT%.iso
set CUENAME=%PROJECT%.cue
set ZIPNAME=%PROJECT%.zip

set FILEPRG=%NEOBUILDTEMP%\%PROJECT%.prg

set FILESPRITE=%NEOBUILDTEMP%\SPR
set FILESPRITECD=%NEOBUILDTEMP%\SPR.cd

set FILECUE=%NEOBUILDTEMP%\%CUENAME%
set FILEISO=%NEOBUILDTEMP%\%ISONAME%
set FILEZIP=%NEOBUILDTEMP%\%ZIPNAME%
set FILECHD=%MAMEFOLDER%\roms\neocdz\%PROJECT%.chd

set CDTEMPLATE=%NEOBUILDDATA%\cd_template

set CHDMAN=%NEOBUILDDATA%\bin\chdman.exe
set MKISOFS=%NEOBUILDDATA%\bin\mkisofs.exe
set UNIX2DOS=%NEOBUILDDATA%\bin\unix2dos.exe

if not defined backupPath set backupPath=%path%
if not exist %NEOBUILDTEMP% md %NEOBUILDTEMP%

set NEODEV=%appdata%\neocore\neodev-sdk
set path=%NEODEV%\m68k\bin;%appdata%\neocore\bin;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0\

if "%MAME_ARGS%" == "" set MAME_ARGS=-window

:main
if "%1" == "clean" goto :clean
if "%1" == "cue" goto :cue
if "%1" == "iso" goto :iso
if "%1" == "raine" goto :raine
if "%1" == "mame" goto :mame
if "%1" == "sprite" goto :sprite
if "%1" == "serve" goto :serve
if "%1" == "zip" goto :zip
if "%1" == "" goto :make
goto :end

:clean
echo -----
echo clean
echo -----
echo try to kill emulators...
powershell "try { taskkill /IM mame64.exe /f } catch { }; exit 0"
powershell "try { taskkill /IM raine32.exe /f } catch { }; exit 0"
echo clean : %NEOBUILDTEMP%
echo clean : %FILECHD%
if exist %NEOBUILDTEMP% rd /S /Q %NEOBUILDTEMP%
if exist %NEOBUILDTEMP% echo error: %NEOBUILDTEMP% still exist
goto :end

:zip
powershell "try { taskkill /IM raine32.exe /f } catch { }; exit 0"
call mak sprite
call mak
call mak iso
echo -----
echo zip
echo -----
if not exist %NEOBUILDTEMP%\iso echo error: %NEOBUILDTEMP%\iso not found
if not exist %NEOBUILDTEMP%\iso goto :end

set needBuildZip=0

powershell -ExecutionPolicy Bypass -File ..\..\scripts\hash.ps1 %FILESPRITECD% %HASHPATH%
if %errorlevel% GEQ 1 set needBuildZip=1

powershell -ExecutionPolicy Bypass -File ..\..\scripts\hash.ps1 %FILEPRG% %HASHPATH%
if %errorlevel% GEQ 1 set needBuildZip=1

if not exist %FILEZIP% set needBuildZip=1

if %needBuildZip% == 0 (
  echo %FILEPRG% is up to date
  echo %FILESPRITECD% is up to date
  goto :end
)

powershell "Compress-Archive -Path %NEOBUILDTEMP%\iso\* -DestinationPath %FILEZIP% -Force"
echo output %FILEZIP%
goto :end

:cue
call mak sprite
call mak
call mak iso
echo -----
echo cue
echo -----

powershell -ExecutionPolicy Bypass -File ..\..\scripts\hash.ps1 %FILECUE% %HASHPATH%
if %errorlevel% == 0 (
  echo %FILECUE% is up to date
  goto :end
)

echo generate %FILECUE%
echo CATALOG 0000000000000 > %FILECUE%
echo   FILE "%ISONAME%" BINARY >> %FILECUE%
echo   TRACK 01 MODE1/2048 >> %FILECUE%
echo   INDEX 01 00:00:00 >> %FILECUE%
%UNIX2DOS% %FILECUE%
type %FILECUE%
echo output %FILECUE%
goto :end

:iso
call mak sprite
call mak
echo -----
echo iso
echo -----

if not exist %NEOBUILDTEMP%\iso (
  md %NEOBUILDTEMP%\iso
  robocopy /MIR %CDTEMPLATE%\ %NEOBUILDTEMP%\iso
)

set needBuildIso=0

powershell -ExecutionPolicy Bypass -File ..\..\scripts\hash.ps1 %FILESPRITECD% %HASHPATH%
if %errorlevel% GEQ 1 set needBuildIso=1

powershell -ExecutionPolicy Bypass -File ..\..\scripts\hash.ps1 %FILEPRG% %HASHPATH%
if %errorlevel% GEQ 1 set needBuildIso=1

if not exist %FILEISO% set needBuildIso=1
if not exist %NEOBUILDTEMP%\iso\DEMO.PRG set needBuildIso=1
if not exist %NEOBUILDTEMP%\iso\DEMO.SPR set needBuildIso=1

if %needBuildIso% == 0 (
  echo %FILEPRG% is up to date
  echo %FILESPRITECD% is up to date
  goto :end
)

if not exist %CDTEMPLATE% echo error: %CDTEMPLATE% not found
if not exist %CDTEMPLATE% goto :end

if not exist %FILEPRG% echo error: %FILEPRG% not found
if not exist %FILEPRG% goto :end

if exist %FILESPRITECD% copy /y %FILESPRITECD% %NEOBUILDTEMP%\iso\DEMO.SPR

copy /y %FILEPRG% %NEOBUILDTEMP%\iso\DEMO.PRG
%MKISOFS% -o %FILEISO% -pad %NEOBUILDTEMP%\iso
echo output %FILEISO%
goto :end

:mame
call mak sprite
call mak
call mak iso
call mak cue
echo -----
echo mame
echo -----
echo Try to kill mame process...
powershell "try { taskkill /IM mame64.exe /f } catch { }; exit 0"
if not exist %FILEISO% echo error: %FILEISO% not found
if not exist %FILEISO% goto :end
if not exist %FILECUE% echo error: %FILECUE% not found
if not exist %FILECUE% goto :end

set needBuildChd=0
powershell -ExecutionPolicy Bypass -File ..\..\scripts\hash.ps1 %FILEISO% %HASHPATH%
if %errorlevel% GEQ 1 set needBuildChd=1

powershell -ExecutionPolicy Bypass -File ..\..\scripts\hash.ps1 %FILECUE% %HASHPATH%
if %errorlevel% GEQ 1 set needBuildChd=1

if %needBuildChd% == 0 (
  echo %FILECHD% is up to date
 goto :mame-start-process
)

%CHDMAN% createcd -i %FILECUE% -o %FILECHD% --force
echo CUE FILE : %FILECUE%
echo CHD FILE : %FILECHD%
echo output %FILECHD%
powershell -ExecutionPolicy Bypass -File ..\..\scripts\mame-hash-writer.ps1 %PROJECT% %FILECHD% %MAMEHASH%

:mame-start-process
start cmd /c "%MAMEFOLDER%\mame64.exe %MAME_ARGS% -rompath %MAMEFOLDER%\roms -hashpath %MAMEFOLDER%\hash -cfg_directory %temp% -nvram_directory %temp% -skip_gameinfo neocdz %PROJECT%"
goto :end

:make
call mak sprite
set NEODEV=%appdata%\neocore\neodev-sdk
set path=%NEODEV%\m68k\bin;%appdata%\neocore\bin;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0\

echo -----
echo make
echo -----
@echo on
if not exist Makefile set FILE=..\Makefile

make -f %FILE% %*
if %errorlevel% neq 0 (
  pause
)
@echo off
goto :end

:raine
call mak sprite
call mak
call mak iso
call mak zip
echo -----
echo raine
echo -----
if not exist %FILEZIP% echo error: %FILEZIP% not found
if not exist %FILEZIP% goto :end
powershell -ExecutionPolicy Bypass -File ..\..\scripts\raine-start.ps1 %RAINE% %FILEZIP%
goto :end

:sprite
echo -----
echo sprite
echo -----
powershell -ExecutionPolicy Bypass -File ..\..\scripts\hash-sprite.ps1 chardata.xml %HASHPATH%
set needBuildSprite=%errorlevel%
if not exist chardata.xml set needBuildSprite=0
echo need build sprites: %needBuildSprite%
if exist chardata.xml (
  if not exist palettes.s echo. > palettes.s
  if not exist maps.s echo. > maps.s
  if %needBuildSprite%==1 BuildChar.exe "chardata.xml"
  if exist char.bin CharSplit.exe char.bin -cd %FILESPRITE%
)
goto :end

:serve
echo serve
powershell -ExecutionPolicy Bypass -File ..\..\scripts\neocore-hot-reload.ps1 .
goto :end

:end
if defined backupPath set path=%backupPath%
exit /b 0