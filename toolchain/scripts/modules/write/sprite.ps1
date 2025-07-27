function Watch-Error {
  $buildPathProject = "$($Config.project.buildPath)\$($Config.project.name)"

  if (-not (Test-Path "$buildPathProject\sprite.log")) {
    return $true  # No log file yet, continue
  }

  Get-Content -Path "$buildPathProject\sprite.log" -Force
  if (Select-String -Path "$buildPathProject\sprite.log" -Pattern "Invalid dimension") {
    Write-Host "Invalid dimension" -ForegroundColor Red
    return $false
  }
  if (Select-String -Path "$buildPathProject\sprite.log" -Pattern "est pas valide") {
    Write-Host "Invalid parameter" -ForegroundColor Red
    return $false
  }

  if ((Get-ChildItem -Path "." -Filter "*.*_reject.*" -Recurse -ErrorAction SilentlyContinue -Force).Length -ne 0) {
    Write-Host "Open reject *_reject file(s)" -ForegroundColor Red
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
  $buildPathProject = "$($Config.project.buildPath)\$($Config.project.name)"

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

  $process = Start-Process `
    -File "BuildChar.exe" `
    -NoNewWindow `
    -ArgumentList $XMLFile `
    -PassThru `
    -RedirectStandardOutput "$buildPathProject\sprite.log"

  $timeout = 120
  $timer = [System.Diagnostics.Stopwatch]::StartNew()

  $progressUpdateInterval = 5
  $lastProgressUpdate = 0

  while (-not $process.HasExited -and $timer.Elapsed.TotalSeconds -lt $timeout) {
      $currentTime = $timer.Elapsed.TotalSeconds

      if ($currentTime - $lastProgressUpdate -ge $progressUpdateInterval) {
          Write-Host "in progress, elapsed time : $($currentTime.toString("N0")) seconds"
          if (-not (Watch-Error)) {
            $process.Kill()
            return $false
          }
          $lastProgressUpdate = $currentTime
      }
      Start-Sleep -Milliseconds 500
  }

  if (-not $process.HasExited) {
      $process.Kill()
      Write-Host "Timeout : compiling sprite exceed timeout ..." -ForegroundColor Red
      return $false
  } else {
      Write-Host "Compiled"
      if ($process.ExitCode -ne 0) {
          # Read and display the log content for debugging
          if (Test-Path "$buildPathProject\sprite.log") {
            Write-Host "Contents of sprite.log:" -ForegroundColor Red
            Get-Content "$buildPathProject\sprite.log" | ForEach-Object { Write-Host "LOG: $_" -ForegroundColor Red }
          }
          Write-Host "BuildChar.exe failed with exit code $($process.ExitCode)" -ForegroundColor Red
          return $false
      }
  }

  $timer.Stop()

  if (-not (Watch-Error)) {
    return $false
  }

  # Check if char.bin was created
  if (-not (Test-Path "char.bin")) {
    Write-Host "char.bin file was not created by BuildChar.exe" -ForegroundColor Red
    return $false
  }

  # Check if CharSplit.exe exists
  $charSplitPath = (Get-Command "CharSplit.exe" -ErrorAction SilentlyContinue).Source
  if (-not $charSplitPath) {
    Write-Host "CharSplit.exe not found in PATH" -ForegroundColor Red
    return $false
  }

  & CharSplit.exe char.bin "-$Format" $OutputFile
  $charSplitExitCode = $LASTEXITCODE

  if ($charSplitExitCode -ne 0) {
    Write-Host "CharSplit.exe failed with exit code $charSplitExitCode" -ForegroundColor Red
    return $false
  }

  Remove-Item -Path char.bin -Force

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
