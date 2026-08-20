# ============================================================
# APEXONE Enterprise Platform
# Execution Layer
# Collector Registry v1.0
# ============================================================

Set-StrictMode -Version Latest

function Get-CollectorRegistry {

$Collectors=@(
@{
Name="DATABASE_INFO"
Order=1
Script="database_info.ps1"
Function="Get-DatabaseInfo"
Enabled=$true
},
@{
Name="TABLESPACE_HEALTH"
Order=2
Script="tablespace_health.ps1"
Function="Get-TablespaceHealth"
Enabled=$true
},
@{
Name="INVALID_OBJECTS"
Order=3
Script="invalid_objects.ps1"
Function="Get-InvalidObjects"
Enabled=$true
}
)

return $Collectors | Sort-Object Order

}