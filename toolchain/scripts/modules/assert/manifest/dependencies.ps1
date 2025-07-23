function Assert-ManifestDependencies {
  Write-Host "Assert manifest dependencies" -ForegroundColor Yellow
  if (-Not($Manifest.manifest.dependencies)) {
    Write-Host "error : manifest.dependencies not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.nsis)) {
    Write-Host "error : manifest.dependencies.nsis not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.nsis.path)) {
    Write-Host "error : manifest.dependencies.nsis.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.nsis.url)) {
    Write-Host "error : manifest.dependencies.nsis.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.neocoreBin)) {
    Write-Host "error : manifest.dependencies.neocoreBin not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.neocoreBin.path)) {
    Write-Host "error : manifest.dependencies.neocoreBin.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.neocoreBin.url)) {
    Write-Host "error : manifest.dependencies.neocoreBin.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.msys2Runtime)) {
    Write-Host "error : manifest.dependencies.msys2Runtime not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.msys2Runtime.path)) {
    Write-Host "error : manifest.dependencies.msys2Runtime.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.msys2Runtime.url)) {
    Write-Host "error : manifest.dependencies.msys2Runtime.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.findCommand)) {
    Write-Host "error : manifest.dependencies.findCommand not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.trCommand)) {
    Write-Host "error : manifest.dependencies.trCommand not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.trCommand.path)) {
    Write-Host "error : manifest.dependencies.trCommand.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.trCommand.url)) {
    Write-Host "error : manifest.dependencies.trCommand.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.datImage)) {
    Write-Host "error : manifest.dependencies.datImage not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.datImage.path)) {
    Write-Host "error : manifest.dependencies.datImage.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.datImage.url)) {
    Write-Host "error : manifest.dependencies.datImage.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.ngfxSoundBuilder)) {
    Write-Host "error : manifest.dependencies.ngfxSoundBuilder not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.ngfxSoundBuilder.path)) {
    Write-Host "error : manifest.dependencies.ngfxSoundBuilder.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.ngfxSoundBuilder.url)) {
    Write-Host "error : manifest.dependencies.ngfxSoundBuilder.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.datAnimatorFramer)) {
    Write-Host "error : manifest.dependencies.datAnimatorFramer not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.datAnimatorFramer.path)) {
    Write-Host "error : manifest.dependencies.datAnimatorFramer.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.neoTools)) {
    Write-Host "error : manifest.dependencies.neoTools not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.neoTools.path)) {
    Write-Host "error : manifest.dependencies.neoTools.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.neoTools.url)) {
    Write-Host "error : manifest.dependencies.neoTools.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.buildChar)) {
    Write-Host "error : manifest.dependencies.buildChar not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.buildChar.path)) {
    Write-Host "error : manifest.dependencies.buildChar.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.buildChar.url)) {
    Write-Host "error : manifest.dependencies.buildChar.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.charSplit)) {
    Write-Host "error : manifest.dependencies.charSplit not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.charSplit.path)) {
    Write-Host "error : manifest.dependencies.charSplit.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.charSplit.url)) {
    Write-Host "error : manifest.dependencies.charSplit.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.chdman)) {
    Write-Host "error : manifest.dependencies.chdman not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.chdman.path)) {
    Write-Host "error : manifest.dependencies.chdman.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.chdman.url)) {
    Write-Host "error : manifest.dependencies.chdman.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.neodevSDK)) {
    Write-Host "error : manifest.dependencies.neodevSDK not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.neodevSDK.path)) {
    Write-Host "error : manifest.dependencies.neodevSDK.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.neodevSDK.url)) {
    Write-Host "error : manifest.dependencies.neodevSDK.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.neodevLib)) {
    Write-Host "error : manifest.dependencies.neodevLib not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.datLib)) {
    Write-Host "error : manifest.dependencies.datLib not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.datLib.path)) {
    Write-Host "error : manifest.dependencies.datLib.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.datLib.url)) {
    Write-Host "error : manifest.dependencies.datLib.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.gcc)) {
    Write-Host "error : manifest.dependencies.gcc not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.gcc.path)) {
    Write-Host "error : manifest.dependencies.gcc.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.gcc.url)) {
    Write-Host "error : manifest.dependencies.gcc.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.raine)) {
    Write-Host "error : manifest.dependencies.raine not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.raine.path)) {
    Write-Host "error : manifest.dependencies.raine.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.raine.url)) {
    Write-Host "error : manifest.dependencies.raine.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.cdTemplate)) {
    Write-Host "error : manifest.dependencies.cdTemplate not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.cdTemplate.path)) {
    Write-Host "error : manifest.dependencies.cdTemplate.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.cdTemplate.url)) {
    Write-Host "error : manifest.dependencies.cdTemplate.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.mpg123)) {
    Write-Host "error : manifest.dependencies.mpg123 not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.mpg123.path)) {
    Write-Host "error : manifest.dependencies.mpg123.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.mpg123.url)) {
    Write-Host "error : manifest.dependencies.mpg123.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.ffmpeg)) {
    Write-Host "error : manifest.dependencies.ffmpeg not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.ffmpeg.path)) {
    Write-Host "error : manifest.dependencies.ffmpeg.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.ffmpeg.url)) {
    Write-Host "error : manifest.dependencies.ffmpeg.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.mame)) {
    Write-Host "error : manifest.dependencies.mame not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.mame.path)) {
    Write-Host "error : manifest.dependencies.mame.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Manifest.manifest.dependencies.mame.url)) {
    Write-Host "error : manifest.dependencies.mame.url not found" -ForegroundColor Red
    exit 1
  }
}
