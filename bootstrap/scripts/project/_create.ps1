param (
  [Parameter(Mandatory=$true)]
  [string]$Name,

  [Parameter(Mandatory=$true)]
  [string]$Path,

  [switch]$Force = $false
)

Import-Module "..\..\..\toolchain\scripts\modules\assert\project\name.ps1"
Import-Module "..\..\..\toolchain\scripts\modules\assert\path.ps1"

Write-Host "Creating new NeoCore project: $Name" -ForegroundColor Cyan
Write-Host "Target path: $Path" -ForegroundColor Gray

if ((-not $Force) -and (Test-Path $Path)) {
  Write-Host "Error: $Path already exists. Use -Force to overwrite." -ForegroundColor Red
  exit 1
}

# Validate project name
Write-Host "Validating project name..." -ForegroundColor Yellow
Assert-ProjectName -Name $Name

# Validate critical path lengths
Write-Host "Validating path lengths..." -ForegroundColor Yellow
$neocoreIncludePath = "$Path\neocore\src-lib\include"
$buildPath = "$Path\build\$Name"

if (-Not(Assert-PathLength -Path $neocoreIncludePath)) {
  Write-Host "Error: NeoCore include path would be too long for GCC compatibility" -ForegroundColor Red
  Write-Host "  Path: $neocoreIncludePath" -ForegroundColor Gray
  Write-Host "  Length: $($neocoreIncludePath.Length) characters" -ForegroundColor Gray
  Write-Host "  Solution: Use a shorter project path or move closer to drive root" -ForegroundColor Yellow
  exit 1
}

if (-Not(Assert-PathLength -Path $buildPath)) {
  Write-Host "Error: Build path would be too long for GCC compatibility" -ForegroundColor Red
  Write-Host "  Path: $buildPath" -ForegroundColor Gray
  Write-Host "  Length: $($buildPath.Length) characters" -ForegroundColor Gray
  Write-Host "  Solution: Use a shorter project path or project name" -ForegroundColor Yellow
  exit 1
}

Write-Host "  Path lengths are compatible with GCC 2.95.2" -ForegroundColor Green

try {
  # Create project directory
  Write-Host "Creating project directory structure..." -ForegroundColor Cyan
  New-Item -ItemType Directory -Path $Path -Force | Out-Null
  Write-Host "  Created: $Path" -ForegroundColor Green

  # Copy src-lib with proper error handling
  Write-Host "Copying NeoCore source library..." -ForegroundColor Cyan
  $srcLibSource = "..\..\..\src-lib"
  $srcLibDest = "$Path\neocore\src-lib"
  Write-Host "  Source: $srcLibSource" -ForegroundColor Gray
  Write-Host "  Destination: $srcLibDest" -ForegroundColor Gray

  $xcopyOutput = cmd /c "xcopy /E /I /Y /Q `"$srcLibSource`" `"$srcLibDest`" 2>&1"
  if ($LASTEXITCODE -ne 0) {
    throw "Failed to copy src-lib. Exit code: $LASTEXITCODE. Output: $xcopyOutput"
  }
  Write-Host "  Source library copied successfully" -ForegroundColor Green

  # Copy manifest.xml
  Write-Host "Copying project manifest..." -ForegroundColor Cyan
  $manifestSource = "..\..\..\manifest.xml"
  $manifestDest = "$Path\neocore\manifest.xml"
  Copy-Item $manifestSource $manifestDest -Force
  if (-not (Test-Path $manifestDest)) {
    throw "Failed to copy manifest.xml"
  }
  Write-Host "  Manifest copied successfully" -ForegroundColor Green

  # Copy .gitignore
  Write-Host "Copying Git ignore file..." -ForegroundColor Cyan
  $gitignoreSource = "..\..\..\bootstrap\.gitignore"
  $gitignoreDest = "$Path\.gitignore"
  Copy-Item $gitignoreSource $gitignoreDest -Force
  if (-not (Test-Path $gitignoreDest)) {
    throw "Failed to copy .gitignore"
  }
  Write-Host "  Git ignore file copied successfully" -ForegroundColor Green

  # Copy toolchain
  Write-Host "Copying NeoCore toolchain..." -ForegroundColor Cyan
  $toolchainSource = "..\..\..\toolchain"
  $toolchainDest = "$Path\neocore\toolchain"
  Write-Host "  Source: $toolchainSource" -ForegroundColor Gray
  Write-Host "  Destination: $toolchainDest" -ForegroundColor Gray

  $xcopyOutput = cmd /c "xcopy /E /I /Y /Q `"$toolchainSource`" `"$toolchainDest`" 2>&1"
  if ($LASTEXITCODE -ne 0) {
    throw "Failed to copy toolchain. Exit code: $LASTEXITCODE. Output: $xcopyOutput"
  }
  Write-Host "  Toolchain copied successfully" -ForegroundColor Green

  # Copy standalone template to src
  Write-Host "Copying project template..." -ForegroundColor Cyan
  $templateSource = "..\..\..\bootstrap\standalone"
  $templateDest = "$Path\src"
  Write-Host "  Source: $templateSource" -ForegroundColor Gray
  Write-Host "  Destination: $templateDest" -ForegroundColor Gray

  $xcopyOutput = cmd /c "xcopy /E /I /Y /Q `"$templateSource`" `"$templateDest`" 2>&1"
  if ($LASTEXITCODE -ne 0) {
    throw "Failed to copy project template. Exit code: $LASTEXITCODE. Output: $xcopyOutput"
  }
  Write-Host "  Project template copied successfully" -ForegroundColor Green

  # Customize project.xml with project name
  Write-Host "Customizing project configuration..." -ForegroundColor Cyan
  $xmlPath = "$Path\src\project.xml"

  if (-not (Test-Path $xmlPath)) {
    throw "Project configuration file not found: $xmlPath"
  }

  [xml]$xml = Get-Content -Path $xmlPath
  $xml.project.name = $Name
  $xml.Save($xmlPath)
  Write-Host "  Set project name to '$Name' in project.xml" -ForegroundColor Green

  Write-Host ""
  Write-Host "Project '$Name' created successfully!" -ForegroundColor Green
  Write-Host "Project location: $Path" -ForegroundColor Cyan
  Write-Host ""
  Write-Host "Next steps:" -ForegroundColor Yellow
  Write-Host "  1. cd `"$Path\src`"" -ForegroundColor Gray
  Write-Host "  2. .\mak.ps1 sprite    # Generate sprites" -ForegroundColor Gray
  Write-Host "  3. .\mak.ps1          # Build program" -ForegroundColor Gray
  Write-Host "  4. .\mak.ps1 run:raine # Run in emulator" -ForegroundColor Gray

} catch {
  Write-Host ""
  Write-Host "Project creation failed: $($_.Exception.Message)" -ForegroundColor Red
  Write-Host "Please check the error details above and try again." -ForegroundColor Yellow
  exit 1
}
