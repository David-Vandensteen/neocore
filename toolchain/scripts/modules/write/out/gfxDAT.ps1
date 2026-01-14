function Write-OutGfxDAT {
  # Generate GFX_DAT_Pict, GFX_DAT_Scrl, and GFX_DAT_Sprt structures
  $picts = $Config.SelectNodes("//chardata/pict")
  $scrls = $Config.SelectNodes("//chardata/scrl")
  $sprts = $Config.SelectNodes("//chardata/sprt")
  $gfxDatHContent = "#ifndef GFX_DAT_H`n#define GFX_DAT_H`n`n#include <neocore.h>`n`n// Auto-generated GFX_DAT_Pict, GFX_DAT_Scrl, and GFX_DAT_Sprt definitions`n"
  $gfxDatCContent = "#include <neocore.h>`n#include ""externs.h""`n`n// Auto-generated GFX_DAT_Pict, GFX_DAT_Scrl, and GFX_DAT_Sprt definitions`n"
  foreach ($pict in $picts) {
    $id = $pict.id
    $gfxDatHContent += "extern const GFX_DAT_Pict_ROM ${id}_pict_rom;`n"
    $gfxDatCContent += "const GFX_DAT_Pict_ROM ${id}_pict_rom = { &${id}, &${id}_Palettes };`n"
  }
  foreach ($scrl in $scrls) {
    $id = $scrl.id
    $gfxDatHContent += "extern const GFX_DAT_Scrl_ROM ${id}_scrl_rom;`n"
    $gfxDatCContent += "const GFX_DAT_Scrl_ROM ${id}_scrl_rom = { &${id}, &${id}_Palettes };`n"
  }
  foreach ($sprt in $sprts) {
    $id = $sprt.id
    $gfxDatHContent += "extern const GFX_DAT_Sprt_ROM ${id}_sprt_rom;`n"
    $gfxDatCContent += "const GFX_DAT_Sprt_ROM ${id}_sprt_rom = { &${id}, &${id}_Palettes };`n"
  }
  $gfxDatHContent += "`n#endif`n"
  $projectName = $Config.project.name
  $buildOutDir = "..\..\build\$projectName\out"
  if (!(Test-Path $buildOutDir)) { New-Item -ItemType Directory -Force $buildOutDir }
  $gfxDatHContent | Out-File -FilePath "$buildOutDir\gfx_dat.h" -Encoding ASCII
  $gfxDatHContent | Out-File -FilePath "out/gfx_dat.h" -Encoding ASCII
  $gfxDatCContent | Out-File -FilePath "$buildOutDir\gfx_dat.c" -Encoding ASCII
  $gfxDatCContent | Out-File -FilePath "out/gfx_dat.c" -Encoding ASCII
  Write-Host "Generated GFX_DAT_Pict, GFX_DAT_Scrl, and GFX_DAT_Sprt structures in out/gfx_dat.h and out/gfx_dat.c" -ForegroundColor Green
}
