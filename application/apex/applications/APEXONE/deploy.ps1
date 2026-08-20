# APEXONE APEX Application Deployment Contract
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$DatabaseConnection,
    [string]$SqlPlus = "sqlplus"
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$Install = Join-Path $Root "install/install.sql"

if (-not (Test-Path $Install)) {
    throw "APEXONE install contract not found: $Install"
}

Write-Host "APEXONE APEX deployment target: $DatabaseConnection"
& $SqlPlus -L $DatabaseConnection "@$Install"
if ($LASTEXITCODE -ne 0) {
    throw "APEXONE APEX deployment failed with exit code $LASTEXITCODE"
}

Write-Host "APEXONE APEX deployment completed."
