function Assert-ProjectCompilerSystemFile {
  Write-Host "Assert project system file" -ForegroundColor Yellow

  if (-Not($Config.project.compiler.systemFile.cd)) {
    Write-Host "error : project.compiler.systemFile.cd not found" -ForegroundColor Red
    return $false
  }
  if (-Not($Config.project.compiler.systemFile.cartridge)) {
    Write-Host "error : project.compiler.systemFile.cartridge not found" -ForegroundColor Red
    return $false
  }

  Write-Host "Project compiler system file configuration is valid" -ForegroundColor Green
  return $true
}