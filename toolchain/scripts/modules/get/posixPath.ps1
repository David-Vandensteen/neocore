function Get-PosixPath {
  <#
  .SYNOPSIS
    Converts Windows paths to POSIX/Unix-style paths for MSYS compatibility.
  
  .DESCRIPTION
    This function converts Windows-style paths (e.g., C:\path\to\file) to 
    POSIX/Unix-style paths (e.g., /c/path/to/file) for use with MSYS tools.
    
  .PARAMETER Path
    The Windows path to convert.
    
  .EXAMPLE
    Get-PosixPath "C:\Users\name\project"
    Returns: /c/Users/name/project
    
  .EXAMPLE
    $env:GCC_PATH = Get-PosixPath $env:GCC_PATH
  #>
  param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [String] $Path
  )
  
  process {
    if ([string]::IsNullOrWhiteSpace($Path)) {
      return $Path
    }
    
    # Convert Windows path to POSIX style
    # Replace C:\ with /c/ and all backslashes with forward slashes
    $posixPath = $Path -replace '([A-Z]):\\', '/$1/' -replace '\\', '/'
    
    # Convert drive letter to lowercase for consistency
    if ($posixPath -match '^/([A-Z])/') {
      $driveLetter = $Matches[1].ToLower()
      $posixPath = $posixPath -replace "^/[A-Z]/", "/$driveLetter/"
    }
    
    return $posixPath
  }
}
