# ============================================================
# APEXONE Enterprise Platform
# Maintenance Bootstrap
# Framework Version 2.0
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

$BootstrapRoot=$PSScriptRoot

$CommonRoot=Join-Path $BootstrapRoot "common"
$ExecutionRoot=Join-Path $BootstrapRoot "execution"
$ReportsRoot=Join-Path $BootstrapRoot "reports\engine"

#------------------------------------------------------------
# Environment
#------------------------------------------------------------

. (Join-Path $CommonRoot "load_environment.ps1")

#------------------------------------------------------------
# Logging
#------------------------------------------------------------

. (Join-Path $CommonRoot "maintenance_logging.ps1")

#------------------------------------------------------------
# Database Access Layer
#------------------------------------------------------------

. (Join-Path $CommonRoot "temp_file_manager.ps1")
. (Join-Path $CommonRoot "sqlplus_parser.ps1")
. (Join-Path $CommonRoot "sqlplus_runner.ps1")
. (Join-Path $CommonRoot "database_api.ps1")

#------------------------------------------------------------
# Report Engine
#------------------------------------------------------------

. (Join-Path $ReportsRoot "report_contract.ps1")
. (Join-Path $ReportsRoot "execution_collector.ps1")
. (Join-Path $ReportsRoot "json_renderer.ps1")
. (Join-Path $ReportsRoot "html_renderer.ps1")
. (Join-Path $ReportsRoot "archive_manager.ps1")
. (Join-Path $ReportsRoot "report_engine.ps1")

#------------------------------------------------------------
# Execution Engine
#------------------------------------------------------------

. (Join-Path $ExecutionRoot "collector_registry.ps1")
. (Join-Path $ExecutionRoot "execution_result.ps1")
. (Join-Path $ExecutionRoot "execution_engine.ps1")
. (Join-Path $ExecutionRoot "execution_merger.ps1")
. (Join-Path $ExecutionRoot "report_integration.ps1")

#------------------------------------------------------------
# Bootstrap Information
#------------------------------------------------------------

$Script:MaintenanceFramework=[PSCustomObject]@{

    Project="APEXONE"

    FrameworkVersion="2.0"

    LoadedAt=Get-Date

    ProjectRoot=$ProjectRoot

    MaintenanceRoot=$DatabaseMaintenanceRoot

    LogsFolder=$LogsFolder

    ReportsFolder=$ReportsFolder

    ConnectionString=$ConnectionString

}

Write-Log `
"Maintenance Bootstrap Loaded" `
"SUCCESS"

function Get-MaintenanceFramework
{

    return $Script:MaintenanceFramework

}
