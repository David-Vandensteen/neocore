function Assert-Externs {
  $externsPath = "externs.h"
  if (Test-Path $externsPath) {
    $externsContent = Get-Content $externsPath -Raw
    $includeLine = '#include "out/gfx_dat.h"'
    if ($externsContent -notmatch [regex]::Escape($includeLine)) {
      $externsContent = $externsContent -replace [regex]::Escape('#include "out/fixData.h"'), "#include ""out/fixData.h""`n#include ""out/gfx_dat.h"""
      $externsContent = $externsContent -replace "`r`n", "`n"
      $externsContent | Out-File -FilePath $externsPath -Encoding ASCII -NoNewline
      Write-Host "Added #include ""out/gfx_dat.h"" to externs.h" -ForegroundColor Green
    }
  } else {
    throw "Error: externs.h does not exist."
  }
}