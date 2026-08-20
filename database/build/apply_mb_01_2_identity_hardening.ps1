$ErrorActionPreference = 'Stop'

$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if (-not (Test-Path (Join-Path $repo 'database'))) {
    throw "Repository root could not be resolved from script location: $repo"
}

$targets = @(
    'database/modules/identity/indexes/IDX_APP_ROLE_PERMISSIONS_PERMISSION_ID.sql',
    'database/modules/identity/indexes/IDX_APP_USERS_STATUS.sql',
    'database/modules/core/install_core.sql',
    'database/deployment/lifecycle/release/release_dry_run.sql'
)

function Write-Utf8NoBom([string]$Path, [string]$Content) {
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $utf8)
}

function Backup-Once([string]$Path) {
    $backup = "$Path.bak"
    if (-not (Test-Path -LiteralPath $backup)) {
        Copy-Item -LiteralPath $Path -Destination $backup
        return $backup
    }
    return $null
}

function Make-IdempotentIndex([string]$RelativePath, [string]$IndexName, [string]$TableName, [string]$ColumnName) {
    $path = Join-Path $repo $RelativePath
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing file: $path" }

    $content = Get-Content -LiteralPath $path -Raw
    $backup = Backup-Once $path

    $header = $content -replace '(?s)\r?\nCREATE INDEX.*$', ''
    $body = @"

PROMPT Checking $IndexName

DECLARE
    l_exists PLS_INTEGER;
BEGIN
    SELECT COUNT(*)
      INTO l_exists
      FROM USER_INDEXES
     WHERE INDEX_NAME = UPPER('$IndexName');

    IF l_exists = 0 THEN
        EXECUTE IMMEDIATE 'CREATE INDEX $IndexName ON $TableName ($ColumnName) TABLESPACE APEXONE_INDEX';
        DBMS_OUTPUT.PUT_LINE('$IndexName : CREATED');
    ELSE
        DBMS_OUTPUT.PUT_LINE('$IndexName : EXISTS - SKIPPED');
    END IF;
END;
/
"@

    Write-Utf8NoBom $path ($header.TrimEnd() + $body)
    return [pscustomobject]@{ Path=$RelativePath; Backup=$backup; Status='FIXED' }
}

Write-Host ''
Write-Host '============================================================' -ForegroundColor Cyan
Write-Host 'APEXONE MB-01.2 IDENTITY INDEX + ENCODING HARDENING' -ForegroundColor Cyan
Write-Host '============================================================' -ForegroundColor Cyan
Write-Host "Repository : $repo"

Make-IdempotentIndex 'database/modules/identity/indexes/IDX_APP_ROLE_PERMISSIONS_PERMISSION_ID.sql' 'IDX_APP_ROLE_PERMISSIONS_PERMISSION_ID' 'APP_ROLE_PERMISSIONS' 'PERMISSION_ID' | Format-Table -AutoSize
Make-IdempotentIndex 'database/modules/identity/indexes/IDX_APP_USERS_STATUS.sql' 'IDX_APP_USERS_STATUS' 'APP_USERS' 'ACCOUNT_STATUS_CODE' | Format-Table -AutoSize

foreach ($relative in @(
    'database/modules/core/install_core.sql',
    'database/deployment/lifecycle/release/release_dry_run.sql'
)) {
    $path = Join-Path $repo $relative
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing file: $path" }
    $bytes = [System.IO.File]::ReadAllBytes($path)
    $hasBom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
    if ($hasBom) {
        $content = [System.IO.File]::ReadAllText($path, (New-Object System.Text.UTF8Encoding($true)))
        $null = Backup-Once $path
        Write-Utf8NoBom $path $content
        Write-Host "BOM REMOVED: $relative" -ForegroundColor Yellow
    } else {
        Write-Host "BOM CLEAN  : $relative"
    }
}

Write-Host ''
Write-Host '------------------------------------------------------------'
Write-Host 'POST-CHECK: MB-01.2 target files'
Write-Host '------------------------------------------------------------'

$fail = $false
foreach ($relative in $targets) {
    $path = Join-Path $repo $relative
    $text = Get-Content -LiteralPath $path -Raw
    $bytes = [System.IO.File]::ReadAllBytes($path)
    $bom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
    if ($bom) {
        Write-Host "FAIL: BOM remains: $relative" -ForegroundColor Red
        $fail = $true
    }
}

foreach ($relative in @(
    'database/modules/identity/indexes/IDX_APP_ROLE_PERMISSIONS_PERMISSION_ID.sql',
    'database/modules/identity/indexes/IDX_APP_USERS_STATUS.sql'
)) {
    $path = Join-Path $repo $relative
    $text = Get-Content -LiteralPath $path -Raw
    if ($text -notmatch 'USER_INDEXES' -or $text -notmatch 'IF l_exists = 0') {
        Write-Host "FAIL: idempotency guard missing: $relative" -ForegroundColor Red
        $fail = $true
    } else {
        Write-Host "PASS: idempotent index installer: $relative" -ForegroundColor Green
    }
}

if ($fail) { throw 'MB-01.2 post-check FAILED.' }

Write-Host ''
Write-Host '============================================================' -ForegroundColor Green
Write-Host 'MB-01.2 HARDENING COMPLETED SUCCESSFULLY' -ForegroundColor Green
Write-Host '============================================================' -ForegroundColor Green
Write-Host 'Next gate: run build_all.sql from the database execution root.'
