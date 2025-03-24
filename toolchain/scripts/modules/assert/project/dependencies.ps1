function Assert-ProjectDependencies {
  if (-Not($Config.project.dependencies.nsis)) {
    Write-Host "error : project.dependencies.nsis not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.nsis.path)) {
    Write-Host "error : project.dependencies.nsis.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.nsis.url)) {
    Write-Host "error : project.dependencies.nsis.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.neocoreBin)) {
    Write-Host "error : project.dependencies.neocoreBin not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.neocoreBin.path)) {
    Write-Host "error : project.dependencies.neocoreBin.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.neocoreBin.url)) {
    Write-Host "error : project.dependencies.neocoreBin.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.msys2Runtime)) {
    Write-Host "error : project.dependencies.msys2Runtime not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.msys2Runtime.path)) {
    Write-Host "error : project.dependencies.msys2Runtime.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.msys2Runtime.url)) {
    Write-Host "error : project.dependencies.msys2Runtime.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.findCommand)) {
    Write-Host "error : project.dependencies.findCommand not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.trCommand)) {
    Write-Host "error : project.dependencies.trCommand not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.trCommand.path)) {
    Write-Host "error : project.dependencies.trCommand.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.trCommand.url)) {
    Write-Host "error : project.dependencies.trCommand.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.datImage)) {
    Write-Host "error : project.dependencies.datImage not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.datImage.path)) {
    Write-Host "error : project.dependencies.datImage.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.datImage.url)) {
    Write-Host "error : project.dependencies.datImage.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.ngfxSoundBuilder)) {
    Write-Host "error : project.dependencies.ngfxSoundBuilder not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.ngfxSoundBuilder.path)) {
    Write-Host "error : project.dependencies.ngfxSoundBuilder.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.ngfxSoundBuilder.url)) {
    Write-Host "error : project.dependencies.ngfxSoundBuilder.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.animator)) {
    Write-Host "error : project.dependencies.animator not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.animator.path)) {
    Write-Host "error : project.dependencies.animator.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.animator.url)) {
    Write-Host "error : project.dependencies.animator.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.framer)) {
    Write-Host "error : project.dependencies.framer not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.framer.path)) {
    Write-Host "error : project.dependencies.framer.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.framer.url)) {
    Write-Host "error : project.dependencies.framer.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.neoTools)) {
    Write-Host "error : project.dependencies.neoTools not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.neoTools.path)) {
    Write-Host "error : project.dependencies.neoTools.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.neoTools.url)) {
    Write-Host "error : project.dependencies.neoTools.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.buildChar)) {
    Write-Host "error : project.dependencies.buildChar not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.buildChar.path)) {
    Write-Host "error : project.dependencies.buildChar.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.buildChar.url)) {
    Write-Host "error : project.dependencies.buildChar.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.charSplit)) {
    Write-Host "error : project.dependencies.charSplit not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.charSplit.path)) {
    Write-Host "error : project.dependencies.charSplit.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.charSplit.url)) {
    Write-Host "error : project.dependencies.charSplit.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.chdman)) {
    Write-Host "error : project.dependencies.chdman not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.chdman.path)) {
    Write-Host "error : project.dependencies.chdman.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.chdman.url)) {
    Write-Host "error : project.dependencies.chdman.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.neodevSDK)) {
    Write-Host "error : project.dependencies.neodevSDK not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.neodevSDK.path)) {
    Write-Host "error : project.dependencies.neodevSDK.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.neodevSDK.url)) {
    Write-Host "error : project.dependencies.neodevSDK.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.neodevLib)) {
    Write-Host "error : project.dependencies.neodevLib not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.datLib)) {
    Write-Host "error : project.dependencies.datLib not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.datLib.path)) {
    Write-Host "error : project.dependencies.datLib.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.datLib.url)) {
    Write-Host "error : project.dependencies.datLib.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.neodevHeader)) {
    Write-Host "error : project.dependencies.neodevHeader not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.neodevHeader.path)) {
    Write-Host "error : project.dependencies.neodevHeader.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.neodevHeader.url)) {
    Write-Host "error : project.dependencies.neodevHeader.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.datLibHeader)) {
    Write-Host "error : project.dependencies.datLibHeader not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.datLibHeader.path)) {
    Write-Host "error : project.dependencies.datLibHeader.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.datLibHeader.url)) {
    Write-Host "error : project.dependencies.datLibHeader.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.system)) {
    Write-Host "error : project.dependencies.system not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.system.path)) {
    Write-Host "error : project.dependencies.system.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.system.url)) {
    Write-Host "error : project.dependencies.system.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.gcc)) {
    Write-Host "error : project.dependencies.gcc not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.gcc.path)) {
    Write-Host "error : project.dependencies.gcc.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.gcc.url)) {
    Write-Host "error : project.dependencies.gcc.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.raine)) {
    Write-Host "error : project.dependencies.raine not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.raine.path)) {
    Write-Host "error : project.dependencies.raine.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.raine.url)) {
    Write-Host "error : project.dependencies.raine.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.cdTemplate)) {
    Write-Host "error : project.dependencies.cdTemplate not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.cdTemplate.path)) {
    Write-Host "error : project.dependencies.cdTemplate.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.cdTemplate.url)) {
    Write-Host "error : project.dependencies.cdTemplate.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.mpg123)) {
    Write-Host "error : project.dependencies.mpg123 not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.mpg123.path)) {
    Write-Host "error : project.dependencies.mpg123.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.mpg123.url)) {
    Write-Host "error : project.dependencies.mpg123.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.ffmpeg)) {
    Write-Host "error : project.dependencies.ffmpeg not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.ffmpeg.path)) {
    Write-Host "error : project.dependencies.ffmpeg.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.ffmpeg.url)) {
    Write-Host "error : project.dependencies.ffmpeg.url not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.mame)) {
    Write-Host "error : project.dependencies.mame not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.mame.path)) {
    Write-Host "error : project.dependencies.mame.path not found" -ForegroundColor Red
    exit 1
  }
  if (-Not($Config.project.dependencies.mame.url)) {
    Write-Host "error : project.dependencies.mame.url not found" -ForegroundColor Red
    exit 1
  }
}
