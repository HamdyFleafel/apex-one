# ============================================================
# APEXONE Enterprise Platform
# Archive Manager
# Version: 1.0
# ============================================================

Set-StrictMode -Version Latest

function Archive-Reports{
    param(
        [string]$ReportRoot=(Split-Path -Parent $PSScriptRoot),

        [int]$KeepDays=30
    )

    $ArchiveFolder=Join-Path $ReportRoot "archive"

    if(!(Test-Path $ArchiveFolder)){
        New-Item -ItemType Directory -Path $ArchiveFolder -Force | Out-Null
    }

    $Folders=@(
        (Join-Path $ReportRoot "json"),
        (Join-Path $ReportRoot "html")
    )

    $Limit=(Get-Date).AddDays(-$KeepDays)

    foreach($Folder in $Folders){

        if(Test-Path $Folder){

            Get-ChildItem $Folder -File | 
            Where-Object {
                $_.LastWriteTime -lt $Limit
            } |
            ForEach-Object {

                Move-Item `
                    -Path $_.FullName `
                    -Destination $ArchiveFolder `
                    -Force
            }
        }
    }

    return $true
}