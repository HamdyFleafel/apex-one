<#
    Public database access API. Collectors must use these functions instead of
    calling sqlplus.exe directly.
#>
Set-StrictMode -Version Latest

function Invoke-SqlScript
{
    param(
        [Parameter(Mandatory)]
        [string]$ScriptFile
    )

    Invoke-SqlPlus -ScriptFile $ScriptFile -Silent
    return $true
}

function Invoke-SqlQuery
{
    param(
        [Parameter(Mandatory)]
        [string]$Sql,

        [Parameter(Mandatory)]
        [string[]]$Columns,

        [string]$Delimiter = "|"
    )

    $Preamble = @"
whenever oserror exit failure rollback
whenever sqlerror exit sql.sqlcode rollback
set echo off feedback off heading off pagesize 0 verify off trimspool on linesize 32767
"@
    $Script = "$Preamble`n$Sql`nexit success`n"
    $TempFile = New-ApexOneTempSqlFile -Sql $Script -Prefix "apexone_query"
    try
    {
        $Output = Invoke-SqlPlus -ScriptFile $TempFile
        return ConvertFrom-SqlPlusDelimitedOutput -Lines $Output -Columns $Columns -Delimiter $Delimiter
    }
    finally
    {
        Remove-ApexOneTempFile -Path $TempFile
    }
}

function Invoke-SqlScalar
{
    param(
        [Parameter(Mandatory)]
        [string]$Sql
    )

    $Rows = @(Invoke-SqlQuery -Sql $Sql -Columns @("Value"))
    if ($Rows.Count -eq 0) { return $null }
    return $Rows[0].Value
}

function Invoke-SqlNonQuery
{
    param(
        [Parameter(Mandatory)]
        [string]$Sql
    )

    $Preamble = @"
whenever oserror exit failure rollback
whenever sqlerror exit sql.sqlcode rollback
set echo off feedback off heading off verify off
"@
    $Script = "$Preamble`n$Sql`ncommit;`nexit success`n"
    $TempFile = New-ApexOneTempSqlFile -Sql $Script -Prefix "apexone_nonquery"
    try
    {
        Invoke-SqlPlus -ScriptFile $TempFile -Silent
        return $true
    }
    finally
    {
        Remove-ApexOneTempFile -Path $TempFile
    }
}
