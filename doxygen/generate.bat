set doxygen=..\build\doxygen\doxygen.exe
set doxyfile=Doxyfile

if not exist %doxygen% (
  echo %doxygen% not found
  exit 1
)

if not exist %doxyfile% (
  echo %doxyfile% not found
  exit 1
)

%doxygen% %doxyfile%
