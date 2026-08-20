. .\database\operations\maintenance\common\maintenance_logging.ps1

Initialize-Log `
    -LogFolder ".\logs\application" `
    -LogName "logging_test.log"

Write-Log "Framework Started"

Write-WarningLog "This is Warning"

Write-ErrorLog "This is Error"

Write-SuccessLog "Framework Completed"