# ====================================================
# APEXONE Enterprise Platform
# DBOPS-005.002
# SQLPlus Process Runner
# ====================================================

Set-StrictMode -Version Latest

if (-not (Get-Command Write-Log -ErrorAction SilentlyContinue))
{
    throw "Write-Log not loaded. Load maintenance_logging.ps1 first."
}

if (-not $ConnectionString)
{
    throw "ConnectionString variable not initialized."
}

function Invoke-SqlPlus
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$ScriptFile,

        [string]$Connection = $ConnectionString,

        [switch]$Silent
    )

    if (!(Test-Path $ScriptFile))
    {
        throw "SQL file not found: $ScriptFile"
    }

    $SqlPlus = Get-Command "sqlplus" -ErrorAction SilentlyContinue
    if (-not $SqlPlus)
    {
        throw "Command not found: sqlplus"
    }

    Write-Log "Executing SQL: $(Split-Path $ScriptFile -Leaf)" "INFO"

    $Arguments = @(
        "-L"
        "-S"
        $Connection
        "@$ScriptFile"
    )

    $Output = & $SqlPlus.Source @Arguments 2>&1
    $ExitCode = $LASTEXITCODE

    if ($ExitCode -ne 0)
    {
        Write-Log "FAILED : $(Split-Path $ScriptFile -Leaf)" "ERROR"
        $Details = ($Output | ForEach-Object { $_.ToString() } | Select-Object -Last 20) -join [Environment]::NewLine
        throw "SQLPlus failed with exit code $ExitCode while executing $(Split-Path $ScriptFile -Leaf).$([Environment]::NewLine)$Details"
    }

    Write-Log "SUCCESS : $(Split-Path $ScriptFile -Leaf)" "SUCCESS"

    if ($Silent)
    {
        return
    }

    return @($Output | ForEach-Object { $_.ToString() })
}
