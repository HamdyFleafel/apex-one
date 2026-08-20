# ====================================================
# APEXONE Enterprise Platform
# DBOPS-005.001
# Environment Loader
# ====================================================

$Script:ProjectRoot = (
    Resolve-Path (
        Join-Path `
            $PSScriptRoot `
            "..\..\.."
    )
).Path

$Script:DatabaseMaintenanceRoot =
Join-Path `
    $ProjectRoot `
    "database\operations\maintenance"

$Script:LogsFolder =
Join-Path `
    $DatabaseMaintenanceRoot `
    "logs"

$Script:ReportsFolder =
Join-Path `
    $DatabaseMaintenanceRoot `
    "reports"

$LocalConfigFile = Join-Path $ProjectRoot "config\local\database.env"
if (!(Test-Path -LiteralPath $LocalConfigFile))
{
    throw "Local database configuration not found: $LocalConfigFile. Copy config/local/database.env.example to config/local/database.env and set its values."
}

$LocalDatabaseConfig = @{}
foreach ($Line in Get-Content -LiteralPath $LocalConfigFile)
{
    if ($Line -match '^\s*([^#=][^=]*)=(.*)$')
    {
        $LocalDatabaseConfig[$Matches[1].Trim()] = $Matches[2].Trim()
    }
}

foreach ($Key in @("DB_USERNAME", "DB_PASSWORD", "DB_HOST", "DB_PORT", "DB_SERVICE"))
{
    if ([string]::IsNullOrWhiteSpace($LocalDatabaseConfig[$Key]))
    {
        throw "Required database setting is missing from $LocalConfigFile: $Key"
    }
}

$Script:ConnectionString = "{0}/{1}@//{2}:{3}/{4}" -f `
    $LocalDatabaseConfig["DB_USERNAME"], `
    $LocalDatabaseConfig["DB_PASSWORD"], `
    $LocalDatabaseConfig["DB_HOST"], `
    $LocalDatabaseConfig["DB_PORT"], `
    $LocalDatabaseConfig["DB_SERVICE"]

foreach ($Folder in @(
    $LogsFolder,
    $ReportsFolder
))
{
    if (!(Test-Path $Folder))
    {
        New-Item `
            -ItemType Directory `
            -Path $Folder `
            -Force | Out-Null
    }
}

$Script:Today =
Get-Date -Format "yyyyMMdd"

$Script:Timestamp =
Get-Date -Format "yyyyMMdd_HHmmss"
