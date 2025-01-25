Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\program.ps1"

function Build-Program {
  robocopy .\ $buildConfig.pathBuild /e /xf * | Out-Null
  if ($Config.project.compiler.program.version -eq "2.95.2") { $gccPath = $Config.project.compiler.program.path }

  Write-Program `
    -ProjectName $buildConfig.projectName `
    -GCCPath $gccPath -PathNeoDev $buildConfig.pathNeodev `
    -MakeFile $buildConfig.makefile `
    -PRGFile $buildConfig.PRGFile `
    -BinPath "$($Config.project.buildPath)\bin"
}
