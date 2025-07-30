function Watch-Error {
  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $buildPathProject = "$projectBuildPath\$($Config.project.name)"

  if (-not (Test-Path "$buildPathProject\sprite.log")) {
    return $true  # No log file yet, continue
  }

  $logContent = Get-Content -Path "$buildPathProject\sprite.log" -Force

  if (Select-String -Path "$buildPathProject\sprite.log" -Pattern "Invalid dimension") {
    Write-Host "ERROR: Invalid dimension detected in sprite" -ForegroundColor Red
    Write-Host "Build log contents:" -ForegroundColor Yellow
    $logContent | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    return $false
  }
  if (Select-String -Path "$buildPathProject\sprite.log" -Pattern "est pas valide") {
    Write-Host "ERROR: Invalid parameter detected" -ForegroundColor Red
    Write-Host "Build log contents:" -ForegroundColor Yellow
    $logContent | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    return $false
  }

  if ((Get-ChildItem -Path "." -Filter "*.*_reject.*" -Recurse -ErrorAction SilentlyContinue -Force).Length -ne 0) {
    Write-Host "ERROR: Sprite files rejected" -ForegroundColor Red
    Write-Host "Fix asset and remove *_reject file(s) in your project before launch a new build ..." -ForegroundColor Red
    Write-Host "Sprite reject..." -ForegroundColor Red
    return $false
  }

  return $true
}

function Write-DATXML {
  param(
    [Parameter(Mandatory=$true)][String] $InputFile,
    [Parameter(Mandatory=$true)][String] $OutputFile
  )

  $xmlDoc = New-Object System.Xml.XmlDocument
  $xmlDoc.Load($InputFile)

  $charDataNode = $xmlDoc.SelectSingleNode("//chardata")

  $newXmlDoc = New-Object System.Xml.XmlDocument

  $newNode = $newXmlDoc.ImportNode($charDataNode, $true)
  $newXmlDoc.AppendChild($newNode)

  $newXmlDoc.Save($OutputFile)
}

function Write-Sprite {
  param (
    [Parameter(Mandatory=$true)][String] $Format,
    [Parameter(Mandatory=$true)][String] $OutputFile,
    [Parameter(Mandatory=$true)][String] $XMLFile
  )
  $projectBuildPath = Get-TemplatePath -Path $Config.project.buildPath
  $buildPathProject = "$projectBuildPath\$($Config.project.name)"

  Write-Host "Compiling sprites" -ForegroundColor Yellow

  if ((Test-Path -Path $XMLFile) -eq $false) {
    Write-Host "$XMLFile not found" -ForegroundColor Red
    return $false
  }

  # Check if BuildChar.exe exists
  $buildCharPath = (Get-Command "BuildChar.exe" -ErrorAction SilentlyContinue).Source
  if (-not $buildCharPath) {
    Write-Host "BuildChar.exe not found in PATH" -ForegroundColor Red
    return $false
  }

  # TODO : timeout managment

  Write-Host "Running BuildChar.exe $XMLFile" -ForegroundColor Cyan

  Write-Host "Starting BuildChar.exe..." -ForegroundColor Green

  # Ensure log directory exists
  if (-not (Test-Path $buildPathProject)) {
    New-Item -Path $buildPathProject -ItemType Directory -Force | Out-Null
  }

  # Simple approach: execute and display output line by line
  Write-Host "BuildChar.exe output:" -ForegroundColor Yellow

  # Clear existing log
  if (Test-Path "$buildPathProject\sprite.log") {
    Remove-Item "$buildPathProject\sprite.log" -Force
  }

  # Execute BuildChar and monitor output in real-time
  $process = Start-Process -FilePath $buildCharPath -ArgumentList $XMLFile -PassThru -RedirectStandardOutput "$buildPathProject\sprite_temp.log" -RedirectStandardError "$buildPathProject\sprite_error.log" -WindowStyle Hidden

  # Monitor output in real-time
  $lastOutputSize = 0
  $lastErrorSize = 0

  while (-not $process.HasExited) {
    Start-Sleep -Milliseconds 300

    # Check for new output
    if (Test-Path "$buildPathProject\sprite_temp.log") {
      $content = Get-Content "$buildPathProject\sprite_temp.log" -Raw -ErrorAction SilentlyContinue
      if ($content -and $content.Length -gt $lastOutputSize) {
        $newContent = $content.Substring($lastOutputSize)
        $newLines = $newContent -split "`r?`n"
        foreach ($line in $newLines) {
          if ($line.Trim() -ne "") {
            Write-Host "  $line" -ForegroundColor Gray
          }
        }
        $lastOutputSize = $content.Length
      }
    }

    # Check for new errors
    if (Test-Path "$buildPathProject\sprite_error.log") {
      $errorContent = Get-Content "$buildPathProject\sprite_error.log" -Raw -ErrorAction SilentlyContinue
      if ($errorContent -and $errorContent.Length -gt $lastErrorSize) {
        $newErrorContent = $errorContent.Substring($lastErrorSize)
        $newErrorLines = $newErrorContent -split "`r?`n"
        foreach ($line in $newErrorLines) {
          if ($line.Trim() -ne "") {
            Write-Host "  $line" -ForegroundColor Red
          }
        }
        $lastErrorSize = $errorContent.Length
      }
    }
  }

  # Wait for process to fully complete
  $process.WaitForExit()
  $exitCode = $process.ExitCode

  # Display any final output that might have been missed
  if (Test-Path "$buildPathProject\sprite_temp.log") {
    $content = Get-Content "$buildPathProject\sprite_temp.log" -Raw -ErrorAction SilentlyContinue
    if ($content -and $content.Length -gt $lastOutputSize) {
      $newContent = $content.Substring($lastOutputSize)
      $newLines = $newContent -split "`r?`n"
      foreach ($line in $newLines) {
        if ($line.Trim() -ne "") {
          Write-Host "  $line" -ForegroundColor Gray
        }
      }
    }
  }

  if (Test-Path "$buildPathProject\sprite_error.log") {
    $errorContent = Get-Content "$buildPathProject\sprite_error.log" -Raw -ErrorAction SilentlyContinue
    if ($errorContent -and $errorContent.Length -gt $lastErrorSize) {
      $newErrorContent = $errorContent.Substring($lastErrorSize)
      $newErrorLines = $newErrorContent -split "`r?`n"
      foreach ($line in $newErrorLines) {
        if ($line.Trim() -ne "") {
          Write-Host "  $line" -ForegroundColor Red
        }
      }
    }
  }

  # Combine into main log file
  $allOutput = @()
  if (Test-Path "$buildPathProject\sprite_temp.log") {
    $allOutput += Get-Content "$buildPathProject\sprite_temp.log"
  }
  if (Test-Path "$buildPathProject\sprite_error.log") {
    $allOutput += Get-Content "$buildPathProject\sprite_error.log"
  }
  if ($allOutput.Count -gt 0) {
    $allOutput | Out-File -FilePath "$buildPathProject\sprite.log" -Encoding UTF8
  }

  # Clean up temp files
  Remove-Item "$buildPathProject\sprite_temp.log" -Force -ErrorAction SilentlyContinue
  Remove-Item "$buildPathProject\sprite_error.log" -Force -ErrorAction SilentlyContinue  Write-Host "BuildChar.exe completed with exit code: $exitCode" -ForegroundColor Cyan

  # Check for errors in the log file
  if (-not (Watch-Error)) {
    return $false
  }

  if ($exitCode -ne 0) {
    Write-Host "ERROR: BuildChar.exe failed with exit code: $exitCode" -ForegroundColor Red
    return $false
  }

  # Extract the charfile path from the XML to check the correct location
  $xmlContent = [xml](Get-Content -Path $XMLFile)
  $charfilePath = $xmlContent.chardata.setup.charfile
  Write-Host "Expected char file path from XML: $charfilePath" -ForegroundColor Cyan

  # Check if char.bin was created at the specified location
  Write-Host "Checking for char file at: $charfilePath" -ForegroundColor Cyan

  if (-not (Test-Path $charfilePath)) {
    Write-Host "char.bin file was not created by BuildChar.exe at expected location: $charfilePath" -ForegroundColor Red
    Write-Host "Current directory contents:" -ForegroundColor Yellow
    Get-ChildItem . | ForEach-Object { Write-Host "  $($_.Name)" -ForegroundColor Gray }

    # Also check if out directory exists and list its contents
    if (Test-Path "out") {
      Write-Host "Contents of 'out' directory:" -ForegroundColor Yellow
      Get-ChildItem "out" | ForEach-Object { Write-Host "  $($_.Name)" -ForegroundColor Gray }
    } else {
      Write-Host "'out' directory does not exist" -ForegroundColor Yellow
    }

    return $false
  }

  # Check if CharSplit.exe exists
  $charSplitPath = (Get-Command "CharSplit.exe" -ErrorAction SilentlyContinue).Source
  if (-not $charSplitPath) {
    Write-Host "CharSplit.exe not found in PATH" -ForegroundColor Red
    return $false
  }

  & CharSplit.exe $charfilePath "-$Format" $OutputFile
  $charSplitExitCode = $LASTEXITCODE

  if ($charSplitExitCode -ne 0) {
    Write-Host "CharSplit.exe failed with exit code $charSplitExitCode" -ForegroundColor Red
    return $false
  }

  Remove-Item -Path $charfilePath -Force

  if ((Test-Path -Path "$OutputFile.$Format") -eq $true) {
    Write-Host "Builded sprites $OutputFile.$Format" -ForegroundColor Green
    Write-Host ""
    return $true
  } else {
    Write-Host "Current directory contents:" -ForegroundColor Red
    Get-ChildItem . | ForEach-Object { Write-Host "  $($_.Name)" -ForegroundColor Red }
    Write-Host ("error - {0}.{1} was not generated" -f $OutputFile, $Format) -ForegroundColor Red
    return $false
  }
}
