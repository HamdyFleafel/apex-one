# ============================================================
# APEXONE Enterprise Platform
# Collector Base Framework
# Version 2.0
# ============================================================

Set-StrictMode -Version Latest

function New-CollectorResult{

param(
[Parameter(Mandatory)]
[string]$Name
)

return [ordered]@{

Name=$Name

Category="General"

Severity="INFO"

Status="RUNNING"

StartedAt=Get-Date

FinishedAt=$null

Metrics=@{}

Data=@{}

Warnings=[System.Collections.Generic.List[object]]::new()

Errors=[System.Collections.Generic.List[object]]::new()

}

}

function Complete-CollectorResult{

param(
[Parameter(Mandatory)]
[hashtable]$Result
)

$Result.FinishedAt=Get-Date

if(
$Result.Status-ne"FAILED" -and
$Result.Status-ne"WARNING"
){
$Result.Status="SUCCESS"
}

return $Result

}