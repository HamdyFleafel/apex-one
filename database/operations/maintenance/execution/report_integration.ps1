# ============================================================
# APEXONE Enterprise Platform
# Execution Layer
# Report Integration v1.3
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

$ExecutionRoot=$PSScriptRoot
$MaintenanceRoot=Split-Path -Parent $ExecutionRoot
$ReportsRoot=Join-Path $MaintenanceRoot "reports"

. (Join-Path $ReportsRoot "engine\report_contract.ps1")
. (Join-Path $ReportsRoot "engine\json_renderer.ps1")
. (Join-Path $ReportsRoot "engine\html_renderer.ps1")
. (Join-Path $ReportsRoot "engine\archive_manager.ps1")

function Publish-ExecutionReport
{
param(
[Parameter(Mandatory=$true)]
$Execution
)

try
{

$Schedule="daily"

if($Execution.ContainsKey("Schedule"))
{
$Schedule=$Execution.Schedule
}

$Report=New-ReportContract -Schedule $Schedule

Add-ReportMessage `
-Report $Report `
-Level INFO `
-Message "Execution Status : $($Execution.Status)"

Add-ReportMessage `
-Report $Report `
-Level INFO `
-Message "Execution ID : $($Execution.ExecutionId)"

Add-ReportMessage `
-Report $Report `
-Level INFO `
-Message "Collectors Count : $($Execution.Collectors.Count)"

foreach($Collector in $Execution.Collectors)
{

Add-ReportMessage `
-Report $Report `
-Level INFO `
-Message "$($Collector.Name) = $($Collector.Status)"

}

$null=Complete-ReportContract $Report

$JsonFile=
Save-JsonReport `
-Report $Report

$HtmlFile=
Save-HtmlReport `
-Report $Report

$Archived=$false

try
{

Archive-Reports `
-Report $Report | Out-Null

$Archived=$true

}
catch
{

$Archived=$false

Add-ReportMessage `
-Report $Report `
-Level WARN `
-Message "Archive Failed : $($_.Exception.Message)"

}

return @{
RunId=$Report.Metadata.RunId
ExecutionId=$Execution.ExecutionId
Status=$Execution.Status
Json=$JsonFile
Html=$HtmlFile
Archived=$Archived
GeneratedAt=Get-Date
}

}
catch
{

throw "Report Publishing Failed : $($_.Exception.Message)"

}

}