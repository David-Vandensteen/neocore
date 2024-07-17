Unicode True
SetCompress force
SetCompressor /SOLID lzma
SetDatablockOptimize ON
SetCompressorDictSize 64

!Define packageName "/*packageName*/"

RequestExecutionLevel user

Name "${packageName}.exe"
Caption "/*packageName*/"
ShowInstDetails nevershow
SilentInstall normal
OutFile "/*outFile*/"
InstallDir "$TEMP\${packageName}"
Icon "/*icon*/"
BrandingText "/*brandingText*/"
AutocloseWindow True

Section "install"
  SetOutPath $InstDir
  File /a /r "/*mamePath*/"
  Exec "/*exec*/"
SectionEnd
