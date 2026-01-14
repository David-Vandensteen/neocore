function Write-Externs {
  $externsPath = "externs.h"
  $externsContent = "// Auto-generated, do not edit`n#ifndef EXTERNS_H`n#define EXTERNS_H`n`n#include ""out/platform.h""`n#include ""out/charInclude.h""`n#include ""out/fixData.h""`n#include ""out/gfx_dat.h""`n`n#endif`n"
  $externsContent | Out-File -FilePath $externsPath -Encoding ASCII -NoNewline
  Write-Host "Updated externs.h with required includes" -ForegroundColor Green
}