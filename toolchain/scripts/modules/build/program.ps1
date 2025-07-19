function Build-Program {
  Write-Host "Build Program" -ForegroundColor Cyan
  Assert-BuildProgram
  $projectBuildPath = Resolve-TemplatePath -Path $Config.project.buildPath
  $prgFile = "$projectBuildPath\$($Config.project.name)\$($Config.project.name).prg"
  $prgFile = Get-TemplatePath -Path $prgFile
  $buildPath = Get-TemplatePath -Path $Config.project.buildPath
  $buildPathName = Get-TemplatePath -Path "$projectBuildPath\$($Config.project.name)"

  robocopy .\ "$buildPathName" /e /xf * | Out-Null
  if ($Config.project.compiler.program.version -eq "2.95.2") { $gccPath = Get-TemplatePath -Path $Config.project.compiler.program.path }

  Write-Program `
    -ProjectName $Config.project.name `
    -GCCPath $gccPath -PathNeoDev "$($buildPath)\neodev-sdk" `
    -MakeFile $Config.project.makefile `
    -PRGFile $prgFile `
    -BinPath "$($buildPath)\bin"
}
