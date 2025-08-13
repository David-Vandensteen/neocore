# Migration-Validation.ps1
# Project validation functions for migration process

function Test-MigrationPrerequisites {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectSrcPath,

        [Parameter(Mandatory=$true)]
        [string]$ProjectNeocorePath
    )

    Write-MigrationLog -Message "Testing migration prerequisites..." -Level "INFO"

    $tests = @{
        "Project source path" = { Test-Path $ProjectSrcPath }
        "Project NeoCore path" = { Test-Path $ProjectNeocorePath }
        "NeoCore src-lib directory" = { Test-Path "$ProjectNeocorePath\src-lib" }
        "NeoCore toolchain directory" = { Test-Path "$ProjectNeocorePath\toolchain" }
        "Manifest file" = { Test-Path "$ProjectNeocorePath\manifest.xml" }
    }

    $failed = @()
    foreach ($testName in $tests.Keys) {
        $testResult = & $tests[$testName]
        if ($testResult) {
            Write-MigrationLog -Message "Checkmark $testName" -Level "INFO"
        } else {
            Write-MigrationLog -Message "X $testName" -Level "ERROR"
            $failed += $testName
        }
    }

    if ($failed.Count -gt 0) {
        Show-Error "Prerequisites failed: $($failed -join ', ')"
    }

    Write-MigrationLog -Message "All prerequisites validated successfully" -Level "SUCCESS"
    return $true
}

function Test-ProjectXmlV3Compatibility {
    param(
        [Parameter(Mandatory=$true)]
        [xml]$ProjectXml,

        [Parameter(Mandatory=$true)]
        [string]$ProjectPath
    )

    Write-MigrationLog -Message "Starting v3 compatibility analysis..." -Level "INFO"
    $issues = @()

    # Define required elements with their descriptions
    $RequiredElements = @{
        "//platform" = "Add platform element if missing"
        "//DAT//chardata//setup" = "Add DAT setup elements if missing"
        "//DAT//fixdata" = "Add fixdata section if missing"
        "//emulator/raine/config" = "Add RAINE config section if missing"
        "//emulator/mame/profile" = "Add MAME profile section if missing"
        "//compiler/crtPath" = "Add compiler crtPath element if missing"
    }

    # Test each required element
    foreach ($xpath in $RequiredElements.Keys) {
        Write-MigrationLog -Message "Checking for element: $xpath" -Level "INFO"
        $element = $ProjectXml.SelectSingleNode($xpath)

        if (-not $element) {
            $issues += $RequiredElements[$xpath]
            Write-MigrationLog -Message "Missing element: $xpath" -Level "WARN"
        } elseif ([string]::IsNullOrWhiteSpace($element.InnerText) -and $xpath -eq "//platform") {
            $issues += "Update platform element - should specify target platform (e.g. cd)"
            Write-MigrationLog -Message "Empty platform element detected" -Level "WARN"
        } else {
            Write-MigrationLog -Message "Found element: $xpath" -Level "INFO"
        }
    }

    # Check DAT setup sub-elements if DAT setup exists
    $datSetupNode = $ProjectXml.SelectSingleNode("//DAT//chardata//setup")
    if ($datSetupNode) {
        $requiredDatElements = @("charfile", "mapfile", "palfile", "incfile", "incprefix")
        $missingDatElements = @()

        foreach ($elementName in $requiredDatElements) {
            $existingElement = $datSetupNode.SelectSingleNode($elementName)
            if (-not $existingElement) {
                $missingDatElements += $elementName
            }
        }

        if ($missingDatElements.Count -gt 0) {
            $issues += "Add DAT setup elements if missing: $($missingDatElements -join ', ')"
        }
    }

    # Check systemFile structure for v3 compatibility
    $compilerNode = $ProjectXml.SelectSingleNode("//compiler")
    if ($compilerNode) {
        $systemFileNode = $compilerNode.SelectSingleNode("systemFile")
        if ($systemFileNode) {
            $cdSystemFile = $systemFileNode.SelectSingleNode("cd")
            $cartridgeSystemFile = $systemFileNode.SelectSingleNode("cartridge")

            if (-not $cdSystemFile -or -not $cartridgeSystemFile) {
                $issues += "Add missing cd/cartridge elements to systemFile structure"
            }
        } else {
            $issues += "Add systemFile section with cd/cartridge elements"
        }
    }

    Write-MigrationLog -Message "V3 compatibility analysis completed. Found $($issues.Count) potential issues." -Level "INFO"
    return $issues
}

function Get-ProjectVersion {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectNeocorePath
    )

    $manifestPath = "$ProjectNeocorePath\manifest.xml"
    if (Test-Path $manifestPath) {
        try {
            [xml]$manifestXml = Get-Content -Path $manifestPath
            $versionNode = $manifestXml.SelectSingleNode("//version")
            if ($versionNode) {
                return $versionNode.InnerText
            }
        } catch {
            Write-MigrationLog -Message "Error reading manifest version: $($_.Exception.Message)" -Level "WARN"
        }
    }

    return "Unknown"
}

function Test-MinimumVersionSupport {
    param(
        [Parameter(Mandatory=$true)]
        [string]$CurrentVersion,

        [Parameter(Mandatory=$false)]
        [string]$MinimumVersion = "2.0.0"
    )

    if ($CurrentVersion -eq "Unknown") {
        Write-MigrationLog -Message "Cannot determine project version - assuming migration is possible" -Level "WARN"
        return $true
    }

    try {
        # Parse version strings (handle versions like "2.0.0", "2.1.0-rc", etc.)
        $currentVersionParts = $CurrentVersion -split '\.' | ForEach-Object { ($_ -split '-')[0] }
        $minimumVersionParts = $MinimumVersion -split '\.'

        # Ensure we have at least major.minor.patch
        while ($currentVersionParts.Count -lt 3) { $currentVersionParts += "0" }
        while ($minimumVersionParts.Count -lt 3) { $minimumVersionParts += "0" }

        # Convert to integers for comparison
        $currentMajor = [int]$currentVersionParts[0]
        $currentMinor = [int]$currentVersionParts[1]
        $currentPatch = [int]$currentVersionParts[2]

        $minimumMajor = [int]$minimumVersionParts[0]
        $minimumMinor = [int]$minimumVersionParts[1]
        $minimumPatch = [int]$minimumVersionParts[2]

        # Compare versions
        if ($currentMajor -gt $minimumMajor) { return $true }
        if ($currentMajor -lt $minimumMajor) { return $false }

        if ($currentMinor -gt $minimumMinor) { return $true }
        if ($currentMinor -lt $minimumMinor) { return $false }

        if ($currentPatch -ge $minimumPatch) { return $true }

        return $false
    } catch {
        Write-MigrationLog -Message "Error comparing versions: $($_.Exception.Message)" -Level "WARN"
        return $true  # If we can't compare, allow migration to proceed
    }
}

function Test-FileExists {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath,

        [Parameter(Mandatory=$true)]
        [string]$Description
    )

    if (Test-Path -Path $FilePath) {
        Write-MigrationLog -Message "$Description exists: $FilePath" -Level "INFO"
        return $true
    } else {
        Write-MigrationLog -Message "$Description not found: $FilePath" -Level "WARN"
        return $false
    }
}
