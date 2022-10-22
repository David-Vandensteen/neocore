$projectSetting = "config\project.xml"
[xml]$config = (Get-Content -Path $projectSetting)

$toolchainPath = $config.project.toolchainPath

if ($args[0]) {
  powershell -ExecutionPolicy Bypass -File $toolchainPath\scripts\Builder-Manager.ps1 -ConfigFile config\project.xml -Rule $args[0]
} else {
  powershell -ExecutionPolicy Bypass -File $toolchainPath\scripts\Builder-Manager.ps1 -ConfigFile config\project.xml
}
