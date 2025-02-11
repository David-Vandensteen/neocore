if not exist ..\..\build\tools\DATimage.exe goto error
..\..\build\tools\DATimage.exe assets\gfx\background.png -mic63 -mtc15
del assets\gfx\aDatLibFormat.xml
move /Y assets\gfx\v_background.png assets\gfx\background.png
goto end

:error
echo ..\..\build\tools\DATimage.exe not found

:end
