#==============================================================================
# APEXONE ENTERPRISE PLATFORM
#==============================================================================
#
# File.........: maintenance_common.ps1
# Module.......: Enterprise Maintenance Framework
# Component....: Common Functions
# Purpose......: Shared Utility Functions
# Version......: 1.0.0
# Status.......: Production
#
#==============================================================================

Set-StrictMode -Version Latest

#------------------------------------------------------------------------------
# Ensure Directory Exists
#------------------------------------------------------------------------------

function Ensure-Directory
{
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (!(Test-Path $Path))
    {
        New-Item `
            -ItemType Directory `
            -Path $Path `
            -Force | Out-Null
    }
}

#------------------------------------------------------------------------------
# Test File Exists
#------------------------------------------------------------------------------

function Test-RequiredFile
{
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (!(Test-Path $Path))
    {
        throw "Required file not found: $Path"
    }
}

#------------------------------------------------------------------------------
# Test Executable Exists
#------------------------------------------------------------------------------

function Test-Command
{
    param(
        [Parameter(Mandatory)]
        [string]$Command
    )

    if (-not (Get-Command $Command -ErrorAction SilentlyContinue))
    {
        throw "Command not found: $Command"
    }
}

#------------------------------------------------------------------------------
# Execute SQL Script
#------------------------------------------------------------------------------

function Invoke-SqlScript
{
    param(
        [Parameter(Mandatory)]
        [string]$Connection,

        [Parameter(Mandatory)]
        [string]$Script
    )

    Test-RequiredFile $Script
    Test-Command "sqlplus"

    & sqlplus -L $Connection "@$Script"

    if ($LASTEXITCODE -ne 0)
    {
        throw "SQL execution failed."
    }
}

#------------------------------------------------------------------------------
# Get Timestamp
#------------------------------------------------------------------------------

function Get-TimeStamp
{
    return Get-Date -Format "yyyyMMdd_HHmmss"
}