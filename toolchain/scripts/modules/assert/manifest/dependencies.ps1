# Helper function to validate a dependency with both path and url
function Test-Dependency {
  param(
    [string]$DependencyName,
    [object]$DependencyObject,
    [bool]$RequirePath = $true,
    [bool]$RequireUrl = $true
  )

  if (-Not($DependencyObject)) {
    Write-Host "error : manifest.dependencies.$DependencyName not found" -ForegroundColor Red
    return $false
  }

  if ($RequirePath -and -Not($DependencyObject.path)) {
    Write-Host "error : manifest.dependencies.$DependencyName.path not found" -ForegroundColor Red
    return $false
  }

  if ($RequireUrl -and -Not($DependencyObject.url)) {
    Write-Host "error : manifest.dependencies.$DependencyName.url not found" -ForegroundColor Red
    return $false
  }

  return $true
}

function Assert-ManifestDependencies {
  Write-Host "Assert manifest dependencies" -ForegroundColor Yellow

  if (-Not($Manifest.manifest.dependencies)) {
    Write-Host "error : manifest.dependencies not found" -ForegroundColor Red
    return $false
  }

  # Validate all dependencies from manifest.xml
  $deps = $Manifest.manifest.dependencies

  # Dependencies that require both path and url
  $fullDependencies = @(
    'datAnimatorFramer', 'datBuildCharCharSplit', 'cdTemplate', 'chdman',
    'datLib', 'systemFont', 'datImage', 'findCommand', 'gcc', 'mpg123',
    'ffmpeg', 'mame', 'mameNeodevPlugin', 'msys2Runtime', 'neodevLib',
    'neocoreBin', 'ngfxSoundBuilder', 'nsis', 'raine', 'trCommand'
  )

  foreach ($depName in $fullDependencies) {
    $depObject = $deps.$depName
    if (-Not(Test-Dependency -DependencyName $depName -DependencyObject $depObject)) {
      return $false
    }
  }

  # All dependency checks passed
  Write-Host "All manifest dependencies validated successfully" -ForegroundColor Green
  return $true
}
