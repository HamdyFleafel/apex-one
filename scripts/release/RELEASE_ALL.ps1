[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(Mandatory = $true)]
    [string]$ConnectionString,

    [string]$SqlExecutable = "sqlplus",

    [switch]$SkipDatabaseInstall,

    [switch]$SkipIntegrationVerification,

    [switch]$SkipOrdsInstall,

    [switch]$SkipSmokeTest,

    [switch]$SkipStructureChecks
)

Set-StrictMode -Version Latest

$ErrorActionPreference = "Stop"

# =============================================================================
# APEXONE FULL RELEASE PIPELINE
# =============================================================================
#
# Project : APEXONE Enterprise Platform
# Script  : RELEASE_ALL.ps1
#
# Pipeline:
#
#   [0/6] Repository / structure validation
#   [1/6] Database installation
#   [2/6] Integration verification
#   [3/6] ORDS installation / deployment
#   [4/6] ORDS smoke tests
#   [5/6] Final release summary
#
# =============================================================================


# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

function Write-Section {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Title
    )

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host $Title -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
}


function Write-Step {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Host ""
    Write-Host $Message -ForegroundColor Yellow
    Write-Host ""
}


function Write-Pass {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Host "[PASS] $Message" -ForegroundColor Green
}


function Write-WarningMessage {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}


function Write-Fail {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Host "[FAIL] $Message" -ForegroundColor Red
}


function Invoke-ExternalCommand {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Executable,

        [Parameter(Mandatory = $true)]
        [string[]]$Arguments,

        [Parameter(Mandatory = $true)]
        [string]$WorkingDirectory,

        [Parameter(Mandatory = $true)]
        [string]$Description
    )

    $originalLocation = Get-Location

    try {
        Set-Location $WorkingDirectory

        Write-Host ""
        Write-Host "Working Directory:" -ForegroundColor DarkGray
        Write-Host $WorkingDirectory -ForegroundColor DarkGray
        Write-Host ""

        Write-Host "Command:" -ForegroundColor DarkGray
        Write-Host "$Executable $($Arguments -join ' ')" -ForegroundColor DarkGray
        Write-Host ""

        & $Executable @Arguments

        $exitCode = $LASTEXITCODE

        if ($null -eq $exitCode) {
            $exitCode = 0
        }

        if ($exitCode -ne 0) {
            throw "$Description failed with exit code $exitCode."
        }
    }
    finally {
        Set-Location $originalLocation
    }
}


function Invoke-SqlScript {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ScriptPath,

        [Parameter(Mandatory = $true)]
        [string]$WorkingDirectory,

        [Parameter(Mandatory = $true)]
        [string]$Description
    )

    if (-not (Test-Path $ScriptPath)) {
        throw "SQL script not found: $ScriptPath"
    }

    if (-not (Test-Path $WorkingDirectory)) {
        throw "SQL working directory not found: $WorkingDirectory"
    }

    $resolvedScriptPath = (Resolve-Path $ScriptPath).Path
    $resolvedWorkingDirectory = (Resolve-Path $WorkingDirectory).Path

    Write-Host ""
    Write-Host "============================================================"
    Write-Host $Description
    Write-Host "============================================================"

    Write-Host ""
    Write-Host "SQL Working Directory:"
    Write-Host $resolvedWorkingDirectory

    Write-Host ""
    Write-Host "SQL Script:"
    Write-Host $resolvedScriptPath

    $originalLocation = Get-Location

    try {
        Set-Location $resolvedWorkingDirectory

        $sqlInput = @(
            "CONNECT $ConnectionString"
            "@$resolvedScriptPath"
            "EXIT"
        )

        $sqlInput | & $SqlExecutable "-L" "/nolog"

        $exitCode = $LASTEXITCODE

        if ($null -eq $exitCode) {
            $exitCode = 0
        }

        if ($exitCode -ne 0) {
            throw "SQL script failed with exit code $exitCode : $resolvedScriptPath"
        }

        Write-Pass "$Description completed successfully."
    }
    finally {
        Set-Location $originalLocation
    }
}

# =============================================================================
# PROJECT PATHS
# =============================================================================

$ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$DatabaseRoot = Join-Path $ProjectRoot "database"

$ScriptsRoot = Join-Path $ProjectRoot "scripts"

$DatabaseInstallScript = Join-Path `
    $DatabaseRoot `
    "deployment\install\install.sql"

$IntegrationVerificationScript = Join-Path `
    $DatabaseRoot `
    "verification\integration\verify_integration.sql"

$RepositoryCheckScript = Join-Path `
    $ScriptsRoot `
    "check_repository_structure.ps1"

$BuildCheckScript = Join-Path `
    $ScriptsRoot `
    "check_build_files.ps1"

$ApplicationCheckScript = Join-Path `
    $ScriptsRoot `
    "check_application_structure.ps1"


# =============================================================================
# PIPELINE START
# =============================================================================

Write-Section "APEXONE FULL RELEASE PIPELINE"

Write-Host "Project Root:"
Write-Host $ProjectRoot

Write-Host ""

Write-Host "Database Root:"
Write-Host $DatabaseRoot

Write-Host ""

Write-Host "SQL Executable:"
Write-Host $SqlExecutable

Write-Host ""


# =============================================================================
# PRE-FLIGHT VALIDATION
# =============================================================================

if (-not (Test-Path $DatabaseRoot)) {
    throw "Database root not found: $DatabaseRoot"
}

if (-not (Test-Path $DatabaseInstallScript)) {
    throw "Database installation script not found: $DatabaseInstallScript"
}

if (-not (Test-Path $IntegrationVerificationScript)) {
    throw "Integration verification script not found: $IntegrationVerificationScript"
}

$resolvedSqlExecutable = Get-Command $SqlExecutable -ErrorAction SilentlyContinue

if ($null -eq $resolvedSqlExecutable) {
    throw "SQL executable '$SqlExecutable' was not found in PATH."
}

Write-Pass "Pre-flight validation completed."


# =============================================================================
# [0/6] STRUCTURE VALIDATION
# =============================================================================

if ($SkipStructureChecks) {

    Write-WarningMessage "Structure checks skipped."

}
else {

    Write-Step "[0/6] Running repository structure validation..."

    if (Test-Path $RepositoryCheckScript) {

        & $RepositoryCheckScript

        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
            throw "Repository structure validation failed."
        }

        Write-Pass "Repository structure validation completed."
    }
    else {
        Write-WarningMessage "Repository check script not found. Skipping."
    }


    Write-Step "[0/6] Running build file validation..."

    if (Test-Path $BuildCheckScript) {

        & $BuildCheckScript

        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
            throw "Build file validation failed."
        }

        Write-Pass "Build file validation completed."
    }
    else {
        Write-WarningMessage "Build check script not found. Skipping."
    }


    Write-Step "[0/6] Running application structure validation..."

    if (Test-Path $ApplicationCheckScript) {

        & $ApplicationCheckScript

        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
            throw "Application structure validation failed."
        }

        Write-Pass "Application structure validation completed."
    }
    else {
        Write-WarningMessage "Application structure check not found. Skipping."
    }
}


# =============================================================================
# [1/6] DATABASE INSTALLATION
# =============================================================================

if ($SkipDatabaseInstall) {

    Write-WarningMessage "Database installation skipped."

}
else {

    Write-Step "[1/6] Installing database..."

    Invoke-SqlScript `
        -ScriptPath $DatabaseInstallScript `
        -WorkingDirectory $DatabaseRoot `
        -Description "Database installation"

    Write-Pass "Database installation completed."
}


# =============================================================================
# [2/6] INTEGRATION VERIFICATION
# =============================================================================

if ($SkipIntegrationVerification) {

    Write-WarningMessage "Integration verification skipped."

}
else {

    Write-Step "[2/6] Running Integration verification..."

    Invoke-SqlScript `
        -ScriptPath $IntegrationVerificationScript `
        -WorkingDirectory $ProjectRoot `
        -Description "Integration verification"

    Write-Pass "Integration verification completed."
}


# =============================================================================
# [3/6] ORDS INSTALLATION
# =============================================================================

$OrdsInstallScript = Join-Path `
    $ProjectRoot `
    "application\ords\install_ords.sql"

if ($SkipOrdsInstall) {

    Write-WarningMessage "ORDS installation skipped."

}
else {

    Write-Step "[3/6] Installing ORDS modules..."

    Invoke-SqlScript `
        -ScriptPath $OrdsInstallScript `
        -WorkingDirectory (Join-Path $ProjectRoot "application\ords") `
        -Description "ORDS installation"

    Write-Pass "ORDS installation completed."
}

# =============================================================================
# [4/6] ORDS SMOKE TEST
# =============================================================================

if ($SkipSmokeTest) {

    Write-WarningMessage "ORDS smoke test skipped."

}
else {

    Write-Step "[4/6] Running ORDS smoke test..."

    $ordsSmokeTestScript = Join-Path `
        $ProjectRoot `
        "scripts\release\ORDS_SMOKE_TEST.ps1"

    if (Test-Path $ordsSmokeTestScript) {

        & $ordsSmokeTestScript

        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
            throw "ORDS smoke test failed."
        }

        Write-Pass "ORDS smoke test completed."
    }
    else {

        Write-WarningMessage `
            "ORDS smoke test script not found: $ordsSmokeTestScript"

        Write-WarningMessage `
            "Skipping ORDS smoke test."
    }
}


# =============================================================================
# [5/6] FINAL STATUS
# =============================================================================

Write-Section "APEXONE RELEASE COMPLETED SUCCESSFULLY"

Write-Host "Project Root:" -ForegroundColor Cyan
Write-Host $ProjectRoot

Write-Host ""

Write-Host "Database Root:" -ForegroundColor Cyan
Write-Host $DatabaseRoot

Write-Host ""

Write-Host "Pipeline Status: SUCCESS" -ForegroundColor Green

Write-Host ""
Write-Host "Completed At:" -ForegroundColor Cyan
Write-Host (Get-Date)

Write-Host ""

exit 0



