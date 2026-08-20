#==============================================================================
# APEXONE ENTERPRISE PLATFORM
#==============================================================================
#
# File.........: daily_maintenance.ps1
# Module.......: Enterprise Maintenance Framework
# Component....: Daily Maintenance Runner
# Purpose......: Execute Daily Database Maintenance
# Version......: 1.1.0
# Status.......: Production
#
#==============================================================================

Set-StrictMode -Version Latest

#------------------------------------------------------------------------------
# Bootstrap
#------------------------------------------------------------------------------

. "$PSScriptRoot\..\common\bootstrap.ps1"

#------------------------------------------------------------------------------
# Initialize Logging
#------------------------------------------------------------------------------

$DailyLog = Join-Path `
    $Global:ProjectRoot `
    "logs\database"

Initialize-Log `
    -LogFolder $DailyLog `
    -LogName ("daily_" + (Get-TimeStamp) + ".log")


Write-Log "========================================="
Write-Log "APEXONE Daily Maintenance Started"
Write-Log "========================================="


#------------------------------------------------------------------------------
# Database Connection
#------------------------------------------------------------------------------

$Connection = $Global:ConnectionString


#------------------------------------------------------------------------------
# Daily Tasks
#------------------------------------------------------------------------------

$Tasks = @(
    @{
        Name = "Database Health"
        Script = "$Global:ProjectRoot\database\operations\maintenance\daily\daily_health.sql"
    },

    @{
        Name = "Tablespace Check"
        Script = "$Global:ProjectRoot\database\operations\maintenance\daily\daily_space_check.sql"
    },

    @{
        Name = "Invalid Objects Check"
        Script = "$Global:ProjectRoot\database\operations\maintenance\daily\daily_invalid_objects.sql"
    }
)


foreach($Task in $Tasks)
{
    Write-Log "Starting Task: $($Task.Name)"

    try
    {
        Invoke-SqlScript `
            -Connection $Connection `
            -Script $Task.Script

        Write-SuccessLog `
            "Completed Task: $($Task.Name)"
    }
    catch
    {
        Write-ErrorLog `
            "Task Failed: $($Task.Name)"
        Write-ErrorLog `
            $_.Exception.Message
    }
}


Write-SuccessLog "APEXONE Daily Maintenance Completed"