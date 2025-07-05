function Watch-Error {
  $buildPathProject = "$($Config.project.buildPath)\$($Config.project.name)"
  Get-Content -Path "$buildPathProject\sprite.log" -Force
  if (Select-String -Path "$buildPathProject\sprite.log" -Pattern "Invalid dimension") {
    Write-Host "Invalid dimension" -ForegroundColor Red
    exit 1
  }
  if (Select-String -Path "$buildPathProject\sprite.log" -Pattern "est pas valide") {
    Write-Host "Invalid parameter" -ForegroundColor Red
    exit 1
  }

  if ((Get-ChildItem -Path "." -Filter "*.*_reject.*" -Recurse -ErrorAction SilentlyContinue -Force).Length -ne 0) {
    Write-Host "Open reject *_reject file(s)" -ForegroundColor Red
    Write-Host "Fix asset and remove *_reject file(s) in your project before launch a new build ..." -ForegroundColor Red
    Write-Host "Sprite reject..." -ForegroundColor Red
    exit 1
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
  $buildPathProject = "$($Config.project.buildPath)\$($Config.project.name)"
  Write-Host "Compiling sprites" -ForegroundColor Yellow
  if ((Test-Path -Path $XMLFile) -eq $false) {
    Write-Host "$XMLFile not found" -ForegroundColor Red
    exit 1
  }

  # TODO : timeout managment
  $process = Start-Process `
    -File "BuildChar.exe" `
    -NoNewWindow `
    -ArgumentList $XMLFile `
    -PassThru `
    -RedirectStandardOutput "$buildPathProject\sprite.log"

  $timeout = 5 * 60
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
      Write-Host "Timeout : compiling sprite exceed timeout ..." -ForegroundColor Red
      exit 1
      Watch-Error
  } else {
      Write-Host "Compiled"
  }

  $timer.Stop()

  Watch-Error

  if ($Config.project.gfx.DAT.chardata.setup.PSObject.Properties.Name -contains "charfile" -and $Config.project.gfx.DAT.chardata.setup.charfile) {
    $charfile = $Config.project.gfx.DAT.chardata.setup.charfile
  } else {
    $charfile = "char.bin"
  }

  & CharSplit.exe $charfile "-$Format" $OutputFile
  Remove-Item -Path $charfile -Force

  if ((Test-Path -Path "$OutputFile.$Format") -eq $true) {
    Write-Host "Builded sprites $OutputFile.$Format" -ForegroundColor Green
    Write-Host ""
  } else {
    Write-Host ("error - {0}.{1} was not generated" -f $OutputFile, $Format) -ForegroundColor Red
    exit 1
  }
}
