# ============================================================
# APEXONE Enterprise Platform
# Execution Collector
# Version: 1.0
# ============================================================

Set-StrictMode -Version Latest

function Start-ScriptExecution{
    param(
        [Parameter(Mandatory)]
        [string]$ScriptName
    )

    return [PSCustomObject]@{
        ScriptName=$ScriptName
        StartedAt=(Get-Date).ToString("o")
        StartTime=Get-Date
    }
}

function Complete-ScriptExecution{
    param(
        [Parameter(Mandatory)]
        $Execution,

        [Parameter(Mandatory)]
        [string]$Status,

        [int]$ExitCode=0,

        [int]$WarningCount=0,

        [string]$ErrorMessage=""
    )

    $Finished=Get-Date

    $Duration=[Math]::Round(
        ($Finished-$Execution.StartTime).TotalSeconds,
        2
    )

    return [PSCustomObject]@{
        ScriptName=$Execution.ScriptName
        Status=$Status.ToUpper()
        StartedAt=$Execution.StartedAt
        FinishedAt=$Finished.ToString("o")
        DurationSeconds=$Duration
        ExitCode=$ExitCode
        WarningCount=$WarningCount
        ErrorMessage=$ErrorMessage
    }
}

function Add-ExecutionToReport{
    param(
        [Parameter(Mandatory)]
        $Report,

        [Parameter(Mandatory)]
        $ExecutionResult
    )

    Add-ReportScript `
        -Report $Report `
        -ScriptName $ExecutionResult.ScriptName `
        -Status $ExecutionResult.Status `
        -StartedAt $ExecutionResult.StartedAt `
        -FinishedAt $ExecutionResult.FinishedAt `
        -DurationSeconds $ExecutionResult.DurationSeconds `
        -ExitCode $ExecutionResult.ExitCode `
        -WarningCount $ExecutionResult.WarningCount `
        -ErrorMessage $ExecutionResult.ErrorMessage
}