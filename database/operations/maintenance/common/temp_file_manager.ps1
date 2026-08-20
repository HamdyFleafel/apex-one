<#
    Temporary SQL file lifecycle helpers.
#>
Set-StrictMode -Version Latest

function New-ApexOneTempSqlFile
{
    param(
        [Parameter(Mandatory)]
        [string]$Sql,

        [string]$Prefix = "apexone"
    )

    $FileName = "{0}_{1}.sql" -f $Prefix, [guid]::NewGuid().ToString("N")
    $Path = Join-Path ([System.IO.Path]::GetTempPath()) $FileName
    [System.IO.File]::WriteAllText($Path, $Sql, [System.Text.UTF8Encoding]::new($false))
    return $Path
}

function Remove-ApexOneTempFile
{
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (Test-Path -LiteralPath $Path)
    {
        Remove-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    }
}
