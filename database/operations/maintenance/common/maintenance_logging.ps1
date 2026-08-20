# ====================================================
# APEXONE Enterprise Platform
# DBOPS-005.001
# Maintenance Logging Framework
# ====================================================

Set-StrictMode -Version Latest

if (-not $LogsFolder)
{
    throw "LogsFolder variable is not initialized. Load load_environment.ps1 first."
}

if (!(Test-Path $LogsFolder))
{
    New-Item `
        -ItemType Directory `
        -Path $LogsFolder `
        -Force | Out-Null
}

$Script:LogFile = Join-Path `
    $LogsFolder `
    ("maintenance_{0}.log" -f (Get-Date -Format "yyyyMMdd"))

function Write-Log
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [ValidateSet(
            "INFO",
            "WARN",
            "ERROR",
            "SUCCESS"
        )]
        [string]$Level="INFO"
    )

    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $Line = "{0} [{1}] {2}" -f `
        $TimeStamp,
        $Level.PadRight(7),
        $Message

    Write-Host $Line

    Add-Content `
        -Path $Script:LogFile `
        -Value $Line
}

function Get-LogFile
{
    return $Script:LogFile
}

Write-Log `
    "Logging Framework Initialized" `
    "SUCCESS"