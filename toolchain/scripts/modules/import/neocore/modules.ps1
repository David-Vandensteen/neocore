# ============================================================================
# NEOCORE MODULE IMPORTS
# Organized by functional categories
# ============================================================================

# ============================================================================
# CORE UTILITIES
# ============================================================================
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\get\template-path.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\resolve\template-path.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\compare\filehash.ps1"

# ============================================================================
# ASSERTION MODULES
# ============================================================================
# Project assertions
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\project.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\project\gfx\dat.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\project\name.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\project\compiler\systemFile.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\path.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\program.ps1"

# Manifest and dependency assertions
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\manifest.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\manifest\dependencies.ps1"

# Build assertions
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\build\exe.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\build\iso.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\build\mame.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\build\neocore-lib.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\build\program.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\build\sprite.ps1"

# Other assertions
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\rule.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\assert\raine\config.ps1"

# ============================================================================
# BUILD MODULES
# ============================================================================
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\build\exe.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\build\iso.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\build\mame.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\build\neocore-lib.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\build\program.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\build\sprite.ps1"

# ============================================================================
# WRITE MODULES
# ============================================================================
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\chardata.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\dist.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\fixdata.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\iso.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\mame.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\mp3.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\nsi.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\program.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\sprite.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\write\wav.ps1"

# ============================================================================
# INSTALL MODULES
# ============================================================================
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\install\component.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\install\nsis.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\install\raine\config.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\install\sdk.ps1"

# ============================================================================
# MAK (MAKE) MODULES
# ============================================================================
# Core mak operations
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\mak\clean.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\mak\clean\build.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\mak\default.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\mak\iso.ps1"

# Mak distribution
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\mak\dist\exe.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\mak\dist\iso.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\mak\dist\mame.ps1"

# Mak run operations
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\mak\run\mame.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\mak\run\raine.ps1"

# Mak serve operations
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\mak\serve\mame.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\mak\serve\raine.ps1"

# ============================================================================
# START MODULES
# ============================================================================
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\start\animator.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\start\download.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\start\framer.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\start\mame.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\start\raine.ps1"

# ============================================================================
# SYSTEM MODULES
# ============================================================================
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\set\env-path.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\show\version.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\stop\emulators.ps1"
Import-Module "$($Config.project.neocorePath)\toolchain\scripts\modules\watch\folder.ps1"
