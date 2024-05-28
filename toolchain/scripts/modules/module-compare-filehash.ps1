function Compare-FileHash {
  param (
      [Parameter(Mandatory = $true)]
      [ValidateScript({Test-Path $_})]
      [string]$SrcFile,

      [Parameter(Mandatory = $true)]
      [ValidateScript({Test-Path $_})]
      [string]$DestFile
  )

  $hasher = [System.Security.Cryptography.SHA256]::Create()

  $file1Bytes = [System.IO.File]::ReadAllBytes($SrcFile)
  $file2Bytes = [System.IO.File]::ReadAllBytes($DestFile)

  $file1Hash = $hasher.ComputeHash($file1Bytes)
  $file2Hash = $hasher.ComputeHash($file2Bytes)

  $file1HashString = [System.BitConverter]::ToString($file1Hash) -replace "-", ""
  $file2HashString = [System.BitConverter]::ToString($file2Hash) -replace "-", ""

  if ($file1HashString -eq $file2HashString) {
    return $true
  }
  else {
    return $false
  }
}
