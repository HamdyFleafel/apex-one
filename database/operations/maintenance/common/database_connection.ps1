# ============================================================
# APEXONE Enterprise Platform
# Database Connection Provider
# ============================================================

Set-StrictMode -Version Latest


function Get-APEXONEProjectRoot
{

    $CurrentFolder =
    Split-Path `
    -Parent `
    $PSScriptRoot


    $DatabaseFolder =
    Split-Path `
    -Parent `
    $CurrentFolder


    $ProjectRoot =
    Split-Path `
    -Parent `
    $DatabaseFolder


    return $ProjectRoot
}



function Get-APEXONEConfig
{

    $ProjectRoot =
    Get-APEXONEProjectRoot


    $ConfigFile =
    Join-Path `
    $ProjectRoot `
    "config\development\database.psd1"


    if(!(Test-Path $ConfigFile))
    {
        throw "Database configuration not found: $ConfigFile"
    }


    return Import-PowerShellDataFile `
    $ConfigFile
}



function Get-APEXONEDatabaseConnection
{
    $ProjectRoot = Get-APEXONEProjectRoot
    $LocalConfigFile = Join-Path $ProjectRoot "config\local\database.env"

    if (!(Test-Path -LiteralPath $LocalConfigFile))
    {
        throw "Local database configuration not found: $LocalConfigFile"
    }

    $Settings = @{}
    foreach ($Line in Get-Content -LiteralPath $LocalConfigFile)
    {
        if ($Line -match '^\s*([^#=][^=]*)=(.*)$')
        {
            $Settings[$Matches[1].Trim()] = $Matches[2].Trim()
        }
    }

    foreach ($Key in @("DB_USERNAME", "DB_PASSWORD", "DB_HOST", "DB_PORT", "DB_SERVICE"))
    {
        if ([string]::IsNullOrWhiteSpace($Settings[$Key]))
        {
            throw "Required database setting is missing from $LocalConfigFile: $Key"
        }
    }

    return "{0}/{1}@//{2}:{3}/{4}" -f `
        $Settings["DB_USERNAME"], `
        $Settings["DB_PASSWORD"], `
        $Settings["DB_HOST"], `
        $Settings["DB_PORT"], `
        $Settings["DB_SERVICE"]
}
