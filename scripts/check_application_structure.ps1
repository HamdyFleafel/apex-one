$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$App = Join-Path $Root 'application'
$Canonical = Join-Path $App 'apex/applications/APEXONE'

if (-not (Test-Path $Canonical)) { throw 'Canonical APEXONE application directory is missing.' }
if (Test-Path (Join-Path $App 'export')) { throw 'Duplicate application/export root exists.' }
if (-not (Test-Path (Join-Path $Canonical 'export'))) { throw 'Canonical APEX export directory is missing.' }
if (-not (Test-Path (Join-Path $Canonical 'metadata/application.json'))) { throw 'Application metadata contract is missing.' }
if (-not (Test-Path (Join-Path $Canonical 'pages/page-map.json'))) { throw 'Page ownership map is missing.' }
if (-not (Test-Path (Join-Path $Canonical 'security/security-contract.md'))) { throw 'Security contract is missing.' }

Write-Host 'APEX application structure check: PASS' -ForegroundColor Green
