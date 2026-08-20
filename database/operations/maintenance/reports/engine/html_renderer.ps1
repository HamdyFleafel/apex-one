# ============================================================
# APEXONE Enterprise Platform
# HTML Renderer
# Version: 1.0
# ============================================================

Set-StrictMode -Version Latest

function Save-HtmlReport{
    param(
        [Parameter(Mandatory)]
        $Report,

        [string]$ReportRoot=(Split-Path -Parent $PSScriptRoot)
    )

    $Folder=Join-Path $ReportRoot "html"

    if(!(Test-Path $Folder)){
        New-Item -ItemType Directory -Path $Folder -Force | Out-Null
    }

    $FileName="APEXONE_{0}_{1}.html" -f `
        $Report.Metadata.Schedule,
        (Get-Date -Format "yyyyMMdd_HHmmss")

    $Path=Join-Path $Folder $FileName

    $Metadata=$Report.Metadata | Out-String
    $Summary=$Report.Summary | Out-String
    $Scripts=$Report.Scripts | Out-String
    $Messages=$Report.Messages | Out-String

    $Html=@"
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>APEXONE Maintenance Report</title>
</head>

<body>

<h1>APEXONE Maintenance Report</h1>

<h2>Metadata</h2>
<pre>
$Metadata
</pre>

<h2>Summary</h2>
<pre>
$Summary
</pre>

<h2>Scripts</h2>
<pre>
$Scripts
</pre>

<h2>Messages</h2>
<pre>
$Messages
</pre>

</body>
</html>
"@

    $Html |
    Out-File `
        -FilePath $Path `
        -Encoding UTF8

    return $Path
}