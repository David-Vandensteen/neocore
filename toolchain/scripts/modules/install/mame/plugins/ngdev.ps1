function Install-MamePluginsNgdev {
  param (
    [Parameter(Mandatory=$true)][String] $PathMame
  )
  
  $pathDownload = Get-TemplatePath -Path "$($Config.project.buildPath)\spool\mame-ngdev-plugin"
  $pathMamePlugins = Get-TemplatePath -Path "$PathMame\plugins"

  if (-not($(Test-Path -Path $pathDownload))) {
    Write-Host "  create $pathDownload" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $pathDownload -Force | Out-Null
  }

  Write-Host "GET $($Manifest.manifest.dependencies.mameNeodevPlugin.url)" -ForegroundColor Cyan
  Start-Download -URL $Manifest.manifest.dependencies.mameNeodevPlugin.url -Path $pathDownload

  # Extract filename from URL
  $zipFileName = Split-Path -Path $Manifest.manifest.dependencies.mameNeodevPlugin.url -Leaf
  if (-not($(Test-Path -Path "$pathDownload\$zipFileName"))) {
    Write-Host "  error : download failed - $pathDownload\$zipFileName not found" -ForegroundColor Red
    return $false
  }

  try {
    Expand-Archive -Path "$pathDownload\$zipFileName" -DestinationPath $pathDownload -Force -ErrorAction Stop
    Write-Host "  expanded $zipFileName to $pathDownload" -ForegroundColor Yellow
    
    
    # Copy ngdev plugin to MAME plugins directory
    if (-not(Test-Path -Path $pathMamePlugins)) {
      New-Item -ItemType Directory -Path $pathMamePlugins -Force | Out-Null
    }
    
    # List what was extracted to debug
    Write-Host "  checking extracted content in $pathDownload" -ForegroundColor Cyan
    Get-ChildItem -Path $pathDownload -Directory | ForEach-Object { Write-Host "    found directory: $($_.Name)" -ForegroundColor Gray }
    
    # Find the extracted directory (should be the only directory in pathDownload)
    $extractedDir = Get-ChildItem -Path $pathDownload -Directory | Select-Object -First 1
    if (-not $extractedDir) {
      Write-Host "  error : no extracted directory found in $pathDownload" -ForegroundColor Red
      Write-Host "  stopping build process" -ForegroundColor Red
      return $false
    }
    
    # The plugin source is in the src directory
    $pluginSourcePath = "$($extractedDir.FullName)\src"
    
    if (Test-Path -Path $pluginSourcePath) {
      Copy-Item -Path $pluginSourcePath -Destination "$pathMamePlugins\ngdev" -Recurse -Force
      Write-Host "  installed ngdev plugin to $pathMamePlugins\ngdev" -ForegroundColor Green
    } else {
      Write-Host "  error : ngdev plugin source not found at $pluginSourcePath" -ForegroundColor Red
      Write-Host "  stopping build process" -ForegroundColor Red
      return $false
    }
    
  } catch {
    Write-Host "  error : failed to expand archive $zipFileName" -ForegroundColor Red
    Write-Host "  error details: $($_.Exception.Message)" -ForegroundColor Red
    return $false
  }
  
  # Clean up download directory completely
  Remove-Item -Path $pathDownload -Recurse -Force -ErrorAction SilentlyContinue
  
  return $true
}