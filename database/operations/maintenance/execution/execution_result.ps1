# ============================================================
# APEXONE Enterprise Platform
# Execution Layer
# Execution Result Contract v2.0
# ============================================================

Set-StrictMode -Version Latest

function New-ExecutionResult{

param(
[string]$Status="RUNNING"
)

return @{
ExecutionId=[guid]::NewGuid().ToString()
Project="APEXONE"
FrameworkVersion="2.0"
Status=$Status
StartedAt=Get-Date
FinishedAt=$null

SuccessCount=0
FailedCount=0

Collectors=@()

Statistics=@{
CollectorCount=0
SuccessfulCollectors=0
FailedCollectors=0
ExecutionSeconds=0
}

Errors=@()
}

}

function Complete-ExecutionResult{

param(
[Parameter(Mandatory)]
[hashtable]$Result
)

$Result.FinishedAt=Get-Date

$Result.Statistics.CollectorCount=$Result.Collectors.Count
$Result.Statistics.SuccessfulCollectors=$Result.SuccessCount
$Result.Statistics.FailedCollectors=$Result.FailedCount

$Result.Statistics.ExecutionSeconds=
[Math]::Round(
($Result.FinishedAt-$Result.StartedAt).TotalSeconds,
2
)

if($Result.FailedCount -eq 0)
{
$Result.Status="SUCCESS"
}
else
{
$Result.Status="FAILED"
}

return $Result

}