# ============================================================
# APEXONE Enterprise Platform
# Collector 001 v2.0
# Database Information Collector
# ============================================================

Set-StrictMode -Version Latest

. (Join-Path $PSScriptRoot "..\common\database_connection.ps1")


function Get-DatabaseInfo
{

    $Result =
    New-CollectorResult `
    -Name "DATABASE_INFO"


    try
    {

        $Sql = @'
set heading off
set feedback off
set pagesize 0
set trimspool on
set echo off

select
'DATABASE_NAME='||name
from v$database;

select
'INSTANCE_NAME='||instance_name
from v$instance;

select
'HOST_NAME='||host_name
from v$instance;

select
'VERSION='||banner
from v$version
where rownum=1;

select
'PDB_NAME='||sys_context('USERENV','CON_NAME')
from dual;

select
'CURRENT_USER='||user
from dual;

select
'CHARACTERSET='||
(select value
 from nls_database_parameters
 where parameter='NLS_CHARACTERSET')
from dual;

exit;
'@


        $TempFile =
        Join-Path `
        $env:TEMP `
        "apexone_database_info_v2.sql"


        $Sql |
        Out-File `
        -FilePath $TempFile `
        -Encoding ASCII



        $Connection =
        Get-APEXONEDatabaseConnection


        $Arguments=@(
            "-s"
            $Connection
            "@$TempFile"
        )


        $Output =
        & sqlplus @Arguments 2>&1



        $Data=@{}


        foreach($Line in $Output)
        {

            $CleanLine =
            $Line.ToString().Trim()


            if($CleanLine -match "=")
            {

                $Parts =
                $CleanLine.Split("=",2)


                $Data[$Parts[0]] =
                $Parts[1]

            }
        }


        $Result.Data =
        @{
            Database =
            @{
                Name =
                $Data["DATABASE_NAME"]

                Version =
                $Data["VERSION"]

                CharacterSet =
                $Data["CHARACTERSET"]
            }


            Instance =
            @{
                Name =
                $Data["INSTANCE_NAME"]

                Host =
                $Data["HOST_NAME"]
            }


            Container =
            @{
                PDB =
                $Data["PDB_NAME"]
            }


            Session =
            @{
                User =
                $Data["CURRENT_USER"]
            }
        }


        $Result.Status="SUCCESS"

    }
    catch
    {

        $Result.Status="FAILED"

        $Result.Errors += $_.Exception.Message

    }


    return Complete-CollectorResult $Result

}