. .\database\operations\maintenance\common\maintenance_common.ps1

Write-Host "Testing Common Library..."

Ensure-Directory ".\logs\test"

Test-RequiredFile ".\VERSION"

Write-Host (Get-TimeStamp)

Write-Host "Common Library Passed"