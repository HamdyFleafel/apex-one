# ============================================================
# APEXONE Enterprise Platform
# Report Engine Orchestrator
# Version: 2.0
# ============================================================

Set-StrictMode -Version Latest

function Initialize-ReportEngine{
    param(
        [string]$ReportRoot=(Split-Path -Parent $PSScriptRoot)
    )

    $Folders=@(
        "$ReportRoot\json",
        "$ReportRoot\html",
        "$ReportRoot\archive"
    )

    foreach($Folder in $Folders){

        if(!(Test-Path $Folder)){
            New-Item `
                -ItemType Directory `
                -Path $Folder `
                -Force |
                Out-Null
        }
    }

    return $true
}


function Publish-Report{
    param(
        [Parameter(Mandatory)]
        $Report,

        [string]$ReportRoot=(Split-Path -Parent $PSScriptRoot),

        [int]$ArchiveKeepDays=30
    )


    Initialize-ReportEngine `
        -ReportRoot $ReportRoot |
        Out-Null


    $JsonFile=Save-JsonReport `
        -Report $Report `
        -ReportRoot $ReportRoot


    $HtmlFile=Save-HtmlReport `
        -Report $Report `
        -ReportRoot $ReportRoot


    Archive-Reports `
        -ReportRoot $ReportRoot `
        -KeepDays $ArchiveKeepDays |
        Out-Null


    return [PSCustomObject]@{

        RunId=$Report.Metadata.RunId

        Schedule=$Report.Metadata.Schedule

        Json=$JsonFile

        Html=$HtmlFile

        Archived=$true

        GeneratedAt=(Get-Date).ToString("o")
    }
}