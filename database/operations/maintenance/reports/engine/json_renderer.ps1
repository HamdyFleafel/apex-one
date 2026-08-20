# ============================================================
# APEXONE Enterprise Platform
# JSON Renderer
# Version: 1.0
# ============================================================

Set-StrictMode -Version Latest

function Save-JsonReport{
    param(
        [Parameter(Mandatory)]
        $Report,

        [string]$ReportRoot=(Split-Path -Parent $PSScriptRoot)
    )

    $Folder=Join-Path $ReportRoot "json"

    if(!(Test-Path $Folder)){
        New-Item -ItemType Directory -Path $Folder -Force | Out-Null
    }

    $FileName="APEXONE_{0}_{1}.json" -f `
        $Report.Metadata.Schedule,
        (Get-Date -Format "yyyyMMdd_HHmmss")

    $Path=Join-Path $Folder $FileName

    $Report |
    ConvertTo-Json -Depth 20 |
    Out-File `
        -FilePath $Path `
        -Encoding UTF8

    return $Path
}