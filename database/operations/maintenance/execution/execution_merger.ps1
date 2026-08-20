# ============================================================
# APEXONE Enterprise Platform
# Execution Merger
# Version 1.1
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

function Convert-ExecutionToReport{

param(
[Parameter(Mandatory)]
$Execution,

[Parameter(Mandatory)]
$Report
)

Set-ExecutionStatistics `
-Report $Report `
-Execution $Execution

foreach($Collector in $Execution.Collectors)
{

$Duration=0

if(
$Collector.ContainsKey("StartedAt") -and
$Collector.ContainsKey("FinishedAt")
)
{
try
{
$Duration=[Math]::Round(
(
[datetime]$Collector.FinishedAt-
[datetime]$Collector.StartedAt
).TotalSeconds,
2
)
}
catch
{
$Duration=0
}
}

$Warnings=[System.Collections.Generic.List[object]]::new()

if(
$Collector.ContainsKey("Warnings") -and
$null-ne $Collector.Warnings
)
{
foreach($Item in $Collector.Warnings)
{
$Warnings.Add($Item)
}
}

$Errors=[System.Collections.Generic.List[object]]::new()

if(
$Collector.ContainsKey("Errors") -and
$null-ne $Collector.Errors
)
{
foreach($Item in $Collector.Errors)
{
$Errors.Add($Item)
}
}

$Metrics=@{}

if(
$Collector.ContainsKey("Metrics") -and
$null-ne $Collector.Metrics
)
{
$Metrics=$Collector.Metrics
}

$CollectorContract=[PSCustomObject]@{

Name=$Collector.Name

Category=if($Collector.ContainsKey("Category"))
{
$Collector.Category
}
else
{
"General"
}

Severity=if($Collector.ContainsKey("Severity"))
{
$Collector.Severity
}
else
{
"INFO"
}

Status=$Collector.Status

StartedAt=$Collector.StartedAt

FinishedAt=$Collector.FinishedAt

Duration=$Duration

Metrics=$Metrics

Data=$Collector.Data

Warnings=$Warnings

Errors=$Errors

}

Add-CollectorResult `
-Report $Report `
-Collector $CollectorContract

Add-ReportMessage `
-Report $Report `
-Level INFO `
-Message "$($Collector.Name) : $($Collector.Status)"

}

return $Report

}