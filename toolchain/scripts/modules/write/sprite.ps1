function Watch-Error {
  Get-Content -Path "$($buildConfig.pathBuild)\sprite.log" -Force

  if (Select-String -Path "$($buildConfig.pathBuild)\sprite.log" -Pattern "Invalid dimension") { Logger-Error -Message "Invalid dimension" }
  if (Select-String -Path "$($buildConfig.pathBuild)\sprite.log" -Pattern "est pas valide") { Logger-Error -Message "Invalid parameter" }

  if ((Get-ChildItem -Path "." -Filter "*.*_reject.*" -Recurse -ErrorAction SilentlyContinue -Force).Length -ne 0) {
    Write-Host "Open reject *_reject file(s)" -ForegroundColor Red
    Write-Host "Fix asset and remove *_reject file(s) in your project before launch a new build ..." -ForegroundColor Red
    Logger-Error -Message "Sprite reject..."
  }
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
  Logger-Step -Message "compiling sprites"
  if ((Test-Path -Path $XMLFile) -eq $false) { Logger-Error -Message "$XMLFile not found" }

  # TODO : timeout managment
  # Start-Process -File BuildChar.exe -NoNewWindow -ArgumentList($XMLFile) -Wait -RedirectStandardOutput "$($buildConfig.pathBuild)\sprite.log"
  $process = Start-Process -File "BuildChar.exe" -NoNewWindow -ArgumentList $XMLFile -PassThru -RedirectStandardOutput "$($buildConfig.pathBuild)\sprite.log"

  $timeout = 120
  $timer = [System.Diagnostics.Stopwatch]::StartNew()

  $progressUpdateInterval = 5
  $lastProgressUpdate = 0

  while (-not $process.HasExited -and $timer.Elapsed.TotalSeconds -lt $timeout) {
      $currentTime = $timer.Elapsed.TotalSeconds

      if ($currentTime - $lastProgressUpdate -ge $progressUpdateInterval) {
          Write-Host "in progress, elapsed time : $($currentTime.toString("N0")) seconds"
          Watch-Error
          $lastProgressUpdate = $currentTime
      }
      Start-Sleep -Milliseconds 500
  }

  if (-not $process.HasExited) {
      $process.Kill()
      Logger-Error -Message "Timeout : compiling sprite exceed timeout ..."
      Watch-Error
  } else {
      Write-Host "Compiled"
  }

  $timer.Stop()

  Watch-Error

  & CharSplit.exe char.bin "-$Format" $OutputFile
  Remove-Item -Path char.bin -Force

  if ((Test-Path -Path "$OutputFile.$Format") -eq $true) {
    Logger-Success -Message "builded sprites is available $OutputFile.$Format"
    Write-Host ""
  } else {
    Write-Host ("error - {0}.{1} was not generated" -f $OutputFile, $Format) -ForegroundColor Red
    exit 1
  }
}
