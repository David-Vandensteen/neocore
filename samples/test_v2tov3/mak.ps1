$projectSetting = "project.xml"
$neocorePath = Resolve-Path -Path "..\.."

cd $neocorePath
powershell -ExecutionPolicy Bypass -File bootstrap\scripts\project\mak.ps1 -ProjectSetting $projectSetting $args
