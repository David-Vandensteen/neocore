
<#
### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = "c:\temp\test"
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
$action = { $path = $Event.SourceEventArgs.FullPath
            $changeType = $Event.SourceEventArgs.ChangeType
            $logline = "$(Get-Date), $changeType, $path"
            Add-content "c:\temp\log.txt" -value $logline

            // get-job
            // todo (minor) get-job | receive-job
            // receive
          }
### DECIDE WHICH EVENTS SHOULD BE WATCHED
Register-ObjectEvent $watcher "Created" -Action $action
Register-ObjectEvent $watcher "Changed" -Action $action
Register-ObjectEvent $watcher "Deleted" -Action $action
Register-ObjectEvent $watcher "Renamed" -Action $action
while ($true) {sleep 5}
#>



Param(
  [String] $projectPath
)

function _main{
  .\mak.bat run
  $sizeLast = (Get-ChildItem $projectPath | Measure-Object -Sum Length | Select-Object Count, Sum).Sum
  $sizeCurrent = $sizeLast

  Write-Host $sizeCurrent

  While ($sizeLast -like $sizeCurrent){
      Start-Sleep -Seconds 5
      $sizeCurrent = (Get-ChildItem $projectPath | Measure-Object -Sum Length | Select-Object Count, Sum).Sum
  }
  Clear-Host
  _main
}

_main
