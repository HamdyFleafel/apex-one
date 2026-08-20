#==============================================================================
# APEXONE ENTERPRISE PLATFORM
#==============================================================================
#
# File.........: bootstrap.ps1
# Module.......: Enterprise Maintenance Framework
# Component....: Bootstrap
# Purpose......: Initialize Maintenance Environment
# Version......: 1.0.0
# Status.......: Production
#
#==============================================================================

Set-StrictMode -Version Latest

#------------------------------------------------------------------------------
# Resolve Paths
#------------------------------------------------------------------------------

$Script:BootstrapRoot = $PSScriptRoot

#------------------------------------------------------------------------------
# Load Core Libraries
#------------------------------------------------------------------------------

. (Join-Path $Script:BootstrapRoot "load_environment.ps1")
. (Join-Path $Script:BootstrapRoot "maintenance_logging.ps1")
. (Join-Path $Script:BootstrapRoot "maintenance_common.ps1")

#------------------------------------------------------------------------------
# Ensure Log Directory
#------------------------------------------------------------------------------

Ensure-Directory (Join-Path $Global:ProjectRoot "logs")
Ensure-Directory (Join-Path $Global:ProjectRoot "logs\database")

#------------------------------------------------------------------------------
# Verify Required Commands
#------------------------------------------------------------------------------

$RequiredCommands = @(
    "sqlplus"
)

foreach ($Command in $RequiredCommands)
{
    Test-Command $Command
}

Write-Host ""
Write-Host "========================================="
Write-Host "APEXONE Bootstrap Initialized"
Write-Host "========================================="
Write-Host "Project Root : $Global:ProjectRoot"
Write-Host "Database     : $Global:DB_SERVICE"
Write-Host "========================================="
Write-Host ""