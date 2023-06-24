if not exist ..\..\build\bin\DATimage.exe goto error
..\..\build\bin\DATimage.exe assets\gfx\background.png -mic63 -mtc15
del assets\gfx\aDatLibFormat.xml
move /Y assets\gfx\v_background.png assets\gfx\background.png
goto end

:error
echo ..\..\build\bin\DATimage.exe not found

:end
