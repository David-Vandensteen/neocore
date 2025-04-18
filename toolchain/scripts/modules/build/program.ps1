Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\build\program.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\program.ps1"

function Build-Program {
  Assert-BuildProgram
  $prgFile = "$($Config.project.buildPath)\$($Config.project.name)\$($Config.project.name).prg"
  robocopy .\ "$($Config.project.buildPath)\$($Config.project.name)" /e /xf * | Out-Null
  if ($Config.project.compiler.program.version -eq "2.95.2") { $gccPath = $Config.project.compiler.program.path }

  Write-Program `
    -ProjectName $Config.project.name `
    -GCCPath $gccPath -PathNeoDev "$($Config.project.buildPath)\neodev-sdk" `
    -MakeFile $Config.project.makefile `
    -PRGFile $prgFile `
    -BinPath "$($Config.project.buildPath)\bin"
}
