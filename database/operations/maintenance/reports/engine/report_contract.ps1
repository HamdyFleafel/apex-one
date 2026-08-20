# ============================================================
# APEXONE Enterprise Platform
# Report Contract
# Version: 3.0
# ============================================================

Set-StrictMode -Version Latest

function New-ReportContract{

param(
[Parameter(Mandatory)]
[string]$Schedule
)

return [PSCustomObject]@{

Metadata=[PSCustomObject]@{
ReportVersion="3.0"
FrameworkVersion="2.0"
Project="APEXONE"
RunId=[guid]::NewGuid().ToString()
Schedule=$Schedule
StartedAt=(Get-Date).ToString("o")
FinishedAt=""
DurationSeconds=0
ComputerName=$env:COMPUTERNAME
UserName=$env:USERNAME
OracleVersion=""
Database=""
PDB=""
}

Summary=[PSCustomObject]@{
TotalScripts=0
Successful=0
Failed=0
Warnings=0
Skipped=0
}

Execution=[PSCustomObject]@{
CollectorCount=0
SuccessfulCollectors=0
FailedCollectors=0
ExecutionSeconds=0
}

Scripts=[System.Collections.Generic.List[object]]::new()

Collectors=[System.Collections.Generic.List[object]]::new()

Messages=[System.Collections.Generic.List[object]]::new()

}

}

function Add-ReportScript{

param(
[Parameter(Mandatory)]$Report,
[Parameter(Mandatory)][string]$ScriptName,
[Parameter(Mandatory)][string]$Status,
[double]$DurationSeconds=0,
[string]$StartedAt="",
[string]$FinishedAt="",
[int]$ExitCode=0,
[int]$WarningCount=0,
[string]$ErrorMessage=""
)

$Item=[PSCustomObject]@{
Name=$ScriptName
Status=$Status.ToUpper()
StartedAt=$StartedAt
FinishedAt=$FinishedAt
DurationSeconds=$DurationSeconds
ExitCode=$ExitCode
WarningCount=$WarningCount
ErrorMessage=$ErrorMessage
}

$Report.Scripts.Add($Item)

$Report.Summary.TotalScripts++

switch($Status.ToUpper())
{
"SUCCESS"{$Report.Summary.Successful++}
"FAILED"{$Report.Summary.Failed++}
"WARNING"{$Report.Summary.Warnings++}
"SKIPPED"{$Report.Summary.Skipped++}
}

}

function Add-CollectorResult{

param(
[Parameter(Mandatory)]$Report,
[Parameter(Mandatory)]$Collector
)

$Report.Collectors.Add($Collector)

}

function Set-ExecutionStatistics{

param(
[Parameter(Mandatory)]$Report,
[Parameter(Mandatory)]$Execution
)

$Report.Execution.CollectorCount=$Execution.Statistics.CollectorCount
$Report.Execution.SuccessfulCollectors=$Execution.Statistics.SuccessfulCollectors
$Report.Execution.FailedCollectors=$Execution.Statistics.FailedCollectors
$Report.Execution.ExecutionSeconds=$Execution.Statistics.ExecutionSeconds

}

function Add-ReportMessage{

param(
[Parameter(Mandatory)]$Report,
[Parameter(Mandatory)]
[ValidateSet("INFO","SUCCESS","WARNING","ERROR")]
[string]$Level,
[Parameter(Mandatory)]
[string]$Message
)

$Report.Messages.Add(
[PSCustomObject]@{
Time=(Get-Date).ToString("o")
Level=$Level
Message=$Message
}
)

}

function Set-DatabaseInformation{

param(
[Parameter(Mandatory)]$Report,
[string]$OracleVersion,
[string]$Database,
[string]$PDB
)

$Report.Metadata.OracleVersion=$OracleVersion
$Report.Metadata.Database=$Database
$Report.Metadata.PDB=$PDB

}

function Complete-ReportContract{

param(
[Parameter(Mandatory)]$Report
)

$Report.Metadata.FinishedAt=(Get-Date).ToString("o")

$Start=[datetime]::Parse($Report.Metadata.StartedAt)
$Finish=[datetime]::Parse($Report.Metadata.FinishedAt)

$Report.Metadata.DurationSeconds=
[Math]::Round(
($Finish-$Start).TotalSeconds,
2
)

return $Report

}