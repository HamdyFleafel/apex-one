# ============================================================
# APEXONE Enterprise Platform
# Collector 003 v1.0
# Invalid Objects Collector
# ============================================================
Set-StrictMode -Version Latest
. (Join-Path $PSScriptRoot "..\common\database_connection.ps1")
function Get-InvalidObjects {
$Result=New-CollectorResult -Name "INVALID_OBJECTS"
try {
$Sql=@'
set heading off
set feedback off
set pagesize 0
set trimspool on
set echo off
select
owner
||'|'
||object_name
||'|'
||object_type
||'|'
||status
from dba_objects
where status='INVALID'
order by owner,object_type,object_name;
exit;
'@
$TempFile=Join-Path $env:TEMP "apexone_invalid_objects.sql"
$Sql | Out-File -FilePath $TempFile -Encoding ASCII
$Connection=Get-APEXONEDatabaseConnection
$Arguments=@("-s",$Connection,"@$TempFile")
$Output=& sqlplus @Arguments 2>&1
$Objects=@()
foreach($Line in $Output){
$Clean=$Line.ToString().Trim()
if($Clean -match "\|"){
$Parts=$Clean.Split("|")
$Objects+=@{
Owner=$Parts[0].Trim()
Name=$Parts[1].Trim()
Type=$Parts[2].Trim()
Status=$Parts[3].Trim()
}
}
}
$Result.Data=@{
InvalidCount=$Objects.Count
Objects=$Objects
}
$Result.Status="SUCCESS"
}
catch{
$Result.Status="FAILED"
$Result.Errors += $_.Exception.Message
}
return Complete-CollectorResult $Result
}