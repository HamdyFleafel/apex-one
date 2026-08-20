# ============================================================
# APEXONE Enterprise Platform
# Execution Engine
# Version 2.0
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

$ExecutionRoot=$PSScriptRoot
$MaintenanceRoot=Split-Path -Parent $ExecutionRoot
$CollectorsRoot=Join-Path $MaintenanceRoot "collectors"

. (Join-Path $ExecutionRoot "collector_registry.ps1")
. (Join-Path $ExecutionRoot "execution_result.ps1")

function Invoke-CollectorExecution{

$ExecutionResult=New-ExecutionResult

try{

$Registry=Get-CollectorRegistry

foreach($Collector in $Registry){

if(!$Collector.Enabled){
continue
}

try{

$CollectorScript=Join-Path $CollectorsRoot $Collector.Script

if(!(Test-Path $CollectorScript)){
throw "Collector script not found: $CollectorScript"
}

. $CollectorScript

$CollectorFunction=Get-Command $Collector.Function -ErrorAction Stop

$Result=& $CollectorFunction

if(!$Result){
throw "Collector returned null."
}

if(!$Result.ContainsKey("Category")){
$Result.Category="General"
}

if(!$Result.ContainsKey("Severity")){
$Result.Severity="INFO"
}

if(!$Result.ContainsKey("Metrics")){
$Result.Metrics=@{}
}

if(!$Result.ContainsKey("Warnings")){
$Result.Warnings=[System.Collections.Generic.List[object]]::new()
}

if(!$Result.ContainsKey("Errors")){
$Result.Errors=[System.Collections.Generic.List[object]]::new()
}

$ExecutionResult.Collectors+=$Result

switch($Result.Status){

"SUCCESS"{
$ExecutionResult.SuccessCount++
}

default{
$ExecutionResult.FailedCount++
}

}

}
catch{

$ExecutionResult.FailedCount++

$ExecutionResult.Collectors+=@{

Name=$Collector.Name
Category="Execution"
Severity="ERROR"
Status="FAILED"

StartedAt=Get-Date
FinishedAt=Get-Date

Metrics=@{}

Data=@{}

Warnings=[System.Collections.Generic.List[object]]::new()

Errors=[System.Collections.Generic.List[object]]::new(
)

}

$ExecutionResult.Errors+=$_.Exception.Message

}

}

}
catch{

$ExecutionResult.FailedCount++

$ExecutionResult.Errors+=$_.Exception.Message

}

return Complete-ExecutionResult $ExecutionResult

}