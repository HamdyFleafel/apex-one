# ============================================================
# APEXONE Enterprise Platform
# Collector
# TABLESPACE_HEALTH
# Version 2.0
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

function Get-TablespaceHealth{

$Result=New-CollectorResult "TABLESPACE_HEALTH"

$Result.Category="Storage"

$Result.Severity="INFO"

try{

$Started=Get-Date

$Sql=@"
SELECT
tablespace_name || '|' ||
round((bytes-free_bytes)/1024/1024,2) || '|' ||
round(bytes/1024/1024,2) || '|' ||
round(free_bytes/1024/1024,2) || '|' ||
round(((bytes-free_bytes)/bytes)*100,2) usage_percent
FROM
(
SELECT
d.tablespace_name,
SUM(d.bytes) bytes,
SUM(f.bytes) free_bytes
FROM dba_data_files d,
(
SELECT
tablespace_name,
SUM(bytes) bytes
FROM dba_free_space
GROUP BY tablespace_name
) f
WHERE d.tablespace_name=f.tablespace_name
GROUP BY d.tablespace_name
)
ORDER BY usage_percent DESC;
"@

$Rows = Invoke-SqlQuery `
    -Sql $Sql `
    -Columns @(
        "TABLESPACE_NAME",
        "USED_MB",
        "TOTAL_MB",
        "FREE_MB",
        "USAGE_PERCENT"
    )

$Tablespaces=@()

$Critical=0
$Warning=0
$Healthy=0

$HighestUsage=0

foreach($Row in $Rows){

$Usage=[double]$Row.USAGE_PERCENT

if($Usage -gt $HighestUsage){
$HighestUsage=$Usage
}

if($Usage -ge 95){

$Critical++

$Result.Severity="ERROR"

$Result.Warnings.Add(
"Tablespace $($Row.TABLESPACE_NAME) usage is $Usage %"
)

}
elseif($Usage -ge 85){

if($Result.Severity -ne "ERROR"){
$Result.Severity="WARNING"
}

$Warning++

$Result.Warnings.Add(
"Tablespace $($Row.TABLESPACE_NAME) usage is $Usage %"
)

}
else{

$Healthy++

}

$Tablespaces+=[PSCustomObject]@{

Name=$Row.TABLESPACE_NAME

UsedMB=[double]$Row.USED_MB

FreeMB=[double]$Row.FREE_MB

TotalMB=[double]$Row.TOTAL_MB

UsagePercent=$Usage

}

}

$Result.Data.Tablespaces=$Tablespaces

$Result.Metrics.TablespaceCount=$Tablespaces.Count

$Result.Metrics.CriticalCount=$Critical

$Result.Metrics.WarningCount=$Warning

$Result.Metrics.HealthyCount=$Healthy

$Result.Metrics.HighestUsagePercent=$HighestUsage

$Result.Status="SUCCESS"

$Result.FinishedAt=Get-Date

}
catch{

$Result.Status="FAILED"

$Result.Errors.Add($_.Exception.Message)

$Result.Severity="ERROR"

$Result.FinishedAt=Get-Date

}

return Complete-CollectorResult $Result

}
