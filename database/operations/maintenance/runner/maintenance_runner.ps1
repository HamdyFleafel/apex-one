# ============================================================
# APEXONE Enterprise Platform
# DBOPS-005.008
# Maintenance Orchestrator v2.0
# ============================================================

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet(
        "daily",
        "weekly",
        "monthly"
    )]
    [string]$Schedule
)

Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

$RunnerFolder=Split-Path -Parent $MyInvocation.MyCommand.Path
$MaintenanceRoot=Split-Path -Parent $RunnerFolder
$DatabaseRoot=Split-Path -Parent $MaintenanceRoot
$ProjectRoot=Split-Path -Parent $DatabaseRoot

$CommonFolder=Join-Path $MaintenanceRoot "common"

. (Join-Path $CommonFolder "load_environment.ps1")
. (Join-Path $CommonFolder "maintenance_logging.ps1")
. (Join-Path $CommonFolder "sqlplus_runner.ps1")

$ExecutionFolder=Join-Path $MaintenanceRoot "execution"

. (Join-Path $ExecutionFolder "collector_registry.ps1")
. (Join-Path $ExecutionFolder "execution_result.ps1")
. (Join-Path $ExecutionFolder "execution_engine.ps1")
. (Join-Path $ExecutionFolder "report_integration.ps1")

Write-Log "====================================================" SUCCESS
Write-Log "APEXONE Enterprise Maintenance Framework" SUCCESS
Write-Log "Schedule : $Schedule" INFO
Write-Log "Project  : $ProjectRoot" INFO
Write-Log "====================================================" SUCCESS

$ExecutionStart=Get-Date

$ScheduleFolder=Join-Path $DatabaseMaintenanceRoot $Schedule

if(!(Test-Path $ScheduleFolder))
{
    Write-Log "Folder not found : $ScheduleFolder" ERROR
    exit 1
}

$SqlFiles=
Get-ChildItem `
-Path $ScheduleFolder `
-Filter "*.sql" `
-File |
Sort-Object Name

if($SqlFiles.Count -eq 0)
{
    Write-Log "No SQL scripts found." WARN
}

[int]$SuccessCount=0
[int]$FailureCount=0


foreach($Sql in $SqlFiles)
{

    Write-Log "====================================================" INFO
    Write-Log "Running : $($Sql.Name)" INFO
    Write-Log "====================================================" INFO

    $ScriptStart=Get-Date

    $Result=
    Invoke-SqlScript `
    $Sql.FullName


    $Duration=
    [math]::Round(
        ((Get-Date)-$ScriptStart).TotalSeconds,
        2
    )


    if($Result)
    {
        $SuccessCount++

        Write-Log `
        "Completed : $($Sql.Name) (${Duration}s)" `
        SUCCESS
    }
    else
    {
        $FailureCount++

        Write-Log `
        "FAILED : $($Sql.Name)" `
        ERROR
    }

}


Write-Log "====================================================" SUCCESS
Write-Log "Executing Collectors" INFO
Write-Log "====================================================" SUCCESS


$Execution=
Invoke-CollectorExecution


Write-Log `
"Collectors Success : $($Execution.SuccessCount)" `
SUCCESS

Write-Log `
"Collectors Failed : $($Execution.FailedCount)" `
INFO


$Execution.FinishedAt=Get-Date


$ReportResult=
Publish-ExecutionReport `
-Execution $Execution


Write-Log "====================================================" SUCCESS
Write-Log "Maintenance Summary" SUCCESS
Write-Log "====================================================" SUCCESS


$ExecutionTime=
[math]::Round(
((Get-Date)-$ExecutionStart).TotalSeconds,
2
)


Write-Log "Schedule        : $Schedule" INFO
Write-Log "SQL Scripts     : $($SqlFiles.Count)" INFO
Write-Log "SQL Success     : $SuccessCount" SUCCESS
Write-Log "SQL Failed      : $FailureCount" INFO
Write-Log "Collectors      : $($Execution.Collectors.Count)" INFO
Write-Log "Execution Time  : ${ExecutionTime} sec" INFO


Write-Log `
"Report JSON : $($ReportResult.Json)" `
SUCCESS


Write-Log `
"Report HTML : $($ReportResult.Html)" `
SUCCESS


Write-Log "====================================================" SUCCESS


if(
$FailureCount -gt 0 `
-or `
$Execution.FailedCount -gt 0
)
{
    exit 1
}

exit 0