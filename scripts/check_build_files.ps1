# ============================================================================
# APEXONE Release Integrity Gate
# Version: 1.0.0-alpha.5
# ============================================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ============================================================================
# Repository Paths
# ============================================================================

$repoRoot = (
    Resolve-Path (
        Join-Path $PSScriptRoot '..'
    )
).Path

$databaseRoot = Join-Path $repoRoot 'database'

# ============================================================================
# Required Database Build Files
# ============================================================================

$requiredFiles = @(
    'platform\framework\install\install_framework.sql',

    'platform\framework\errors\spec\PKG_ERRORS.pks',
    'platform\framework\errors\body\PKG_ERRORS.pkb',

    'modules\core\install_core.sql',
    'modules\core\tables\app_schema_version.sql',
    'modules\core\tables\app_install_log.sql',
    'modules\core\constraints\core_constraints.sql',
    'modules\core\indexes\core_indexes.sql',
    'modules\core\sequences\core_sequences.sql',
    'modules\core\packages\spec\PKG_CORE.pks',
    'modules\core\packages\body\PKG_CORE.pkb',

    'modules\identity\install_identity.sql',
    'modules\identity\tables\app_users.sql',
    'modules\identity\tables\app_roles.sql',
    'modules\identity\tables\app_permissions.sql',
    'modules\identity\tables\app_role_permissions.sql',
    'modules\identity\tables\app_user_roles.sql',
    'modules\identity\packages\spec\PKG_IDENTITY.pks',
    'modules\identity\packages\body\PKG_IDENTITY.pkb',
    'modules\identity\packages\spec\PKG_SESSION.pks',
    'modules\identity\packages\body\PKG_SESSION.pkb',

    'modules\security\install_security.sql',
    'modules\security\tables\app_password_history.sql',
    'modules\security\tables\app_login_history.sql',

    'modules\security\packages\spec\PKG_SECURITY_LOCKOUT.pks',
    'modules\security\packages\body\PKG_SECURITY_LOCKOUT.pkb',

    'modules\security\packages\spec\PKG_AUTHENTICATION.pks',
    'modules\security\packages\body\PKG_AUTHENTICATION.pkb',

    'modules\security\packages\spec\PKG_SECURITY.pks',
    'modules\security\packages\body\PKG_SECURITY.pkb',

    'modules\security\packages\spec\PKG_SECURITY_POLICY.pks',
    'modules\security\packages\body\PKG_SECURITY_POLICY.pkb',

    'modules\security\packages\spec\PKG_AUDIT.pks',
    'modules\security\packages\body\PKG_AUDIT.pkb',

    'modules\security\packages\spec\PKG_AUTHORIZATION.pks',
    'modules\security\packages\body\PKG_AUTHORIZATION.pkb',

    'platform\framework\security\spec\PKG_SECURITY_HASH.pks',
    'platform\framework\security\body\PKG_SECURITY_HASH.pkb',

    'modules\identity\constraints\app_sessions_pk.sql',
    'modules\identity\constraints\app_sessions_token_uk.sql',
    'modules\identity\constraints\app_login_attempts_pk.sql',

    'modules\security\constraints\app_password_history_pk.sql',
    'modules\security\constraints\app_login_history_pk.sql',
    'modules\security\constraints\app_password_history_user_fk.sql',

    'seed\security\seed_roles.sql',
    'seed\security\seed_permissions.sql',
    'seed\security\seed_role_permissions.sql',
    'seed\identity\seed_admin_user.sql',

    'modules\configuration\install_configuration.sql',
    'modules\configuration\tables\app_config_groups.sql',
    'modules\configuration\tables\app_config.sql',
    'modules\configuration\packages\spec\PKG_CONFIGURATION.pks',
    'modules\configuration\packages\body\PKG_CONFIGURATION.pkb',

    'modules\notification\install_notification.sql',
    'modules\notification\tables\app_notification_templates.sql',
    'modules\notification\tables\app_notifications.sql',
    'modules\notification\packages\spec\PKG_NOTIFICATION.pks',
    'modules\notification\packages\body\PKG_NOTIFICATION.pkb',

    'modules\workflow\install_workflow.sql',
    'modules\workflow\tables\app_workflow_definitions.sql',
    'modules\workflow\tables\app_workflow_tasks.sql',
    'modules\workflow\packages\spec\PKG_WORKFLOW.pks',
    'modules\workflow\packages\body\PKG_WORKFLOW.pkb',

    'verification\identity\verify_identity.sql',
    'verification\identity\verify_rbac_integrity.sql',
    'verification\security\verify_security.sql'
)

$failures = New-Object System.Collections.Generic.List[string]

# ============================================================================
# Helper Functions
# ============================================================================

function Add-Failure {
    param(
        [Parameter(Mandatory)]
        [string]$Message
    )

    $failures.Add($Message)
}

function Get-RelativeRepositoryPath {
    param(
        [Parameter(Mandatory)]
        [string]$FullPath
    )

    $normalizedRoot = $repoRoot.TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar
    )

    if ($FullPath.StartsWith(
        $normalizedRoot,
        [System.StringComparison]::OrdinalIgnoreCase
    )) {
        return $FullPath.Substring(
            $normalizedRoot.Length
        ).TrimStart(
            [System.IO.Path]::DirectorySeparatorChar,
            [System.IO.Path]::AltDirectorySeparatorChar
        )
    }

    return $FullPath
}

# ============================================================================
# Validation Header
# ============================================================================

Write-Host ""
Write-Host "============================================================"
Write-Host "APEXONE RELEASE INTEGRITY VALIDATION"
Write-Host "============================================================"
Write-Host ""

Write-Host "Repository Root:"
Write-Host $repoRoot
Write-Host ""

Write-Host "Database Root:"
Write-Host $databaseRoot
Write-Host ""

# ============================================================================
# 1. Required Build Files
# ============================================================================

Write-Host "[1/4] Validating required build files..."
Write-Host ""

foreach ($relativePath in $requiredFiles) {

    $fullPath = Join-Path $databaseRoot $relativePath

    if (
        -not (
            Test-Path `
                -LiteralPath $fullPath `
                -PathType Leaf
        )
    ) {

        Write-Host "[MISSING] $relativePath" -ForegroundColor Red

        Add-Failure "Missing required build file: $relativePath"

        continue
    }

    $fileInfo = Get-Item -LiteralPath $fullPath

    if ($fileInfo.Length -eq 0) {

        Write-Host "[EMPTY] $relativePath" -ForegroundColor Red

        Add-Failure "Empty required build file: $relativePath"

        continue
    }

    Write-Host "[OK] $relativePath" -ForegroundColor Green
}

Write-Host ""

# ============================================================================
# 2. PowerShell Markdown Fence Validation
# ============================================================================

Write-Host "[2/4] Validating PowerShell source files..."
Write-Host ""

$powerShellFiles = @(
    Get-ChildItem `
        -LiteralPath $repoRoot `
        -Recurse `
        -File `
        -Filter '*.ps1' `
        -ErrorAction Stop
)

foreach ($file in $powerShellFiles) {

    $relativePath = Get-RelativeRepositoryPath `
        -FullPath $file.FullName

    try {

        $content = Get-Content `
            -LiteralPath $file.FullName `
            -Raw `
            -ErrorAction Stop

    }
    catch {

        Write-Host "[INVALID] Cannot read: $relativePath" `
            -ForegroundColor Red

        Add-Failure (
            "Unable to read PowerShell file: {0}. {1}" -f `
                $relativePath,
                $_.Exception.Message
        )

        continue
    }

    if ($null -eq $content) {
        $content = [string]::Empty
    }

    # Detect Markdown code fences only when they appear
    # at the beginning of a line.
    $hasMarkdownFence = [regex]::IsMatch(
        [string]$content,
        '(?m)^\s*```'
    )

    if ($hasMarkdownFence) {

        Write-Host "[INVALID] Markdown fence: $relativePath" `
            -ForegroundColor Red

        Add-Failure "Markdown fence detected: $relativePath"

        continue
    }

    Write-Host "[OK] $relativePath" -ForegroundColor Green
}

Write-Host ""

# ============================================================================
# 3. Repository Placeholder Validation
# ============================================================================

Write-Host "[3/4] Validating repository placeholders..."
Write-Host ""

$sourcePatterns = @(
    '*.ps1',
    '*.sql',
    '*.pks',
    '*.pkb'
)

$placeholder = '<APEXONE' + '_REPO>'

foreach ($pattern in $sourcePatterns) {

    $files = @(
        Get-ChildItem `
            -LiteralPath $repoRoot `
            -Recurse `
            -File `
            -Filter $pattern `
            -ErrorAction Stop
    )

    foreach ($file in $files) {

        $relativePath = Get-RelativeRepositoryPath `
            -FullPath $file.FullName

        $containsPlaceholder = Select-String `
            -LiteralPath $file.FullName `
            -Pattern $placeholder `
            -SimpleMatch `
            -Quiet

        if ($containsPlaceholder) {

            Write-Host "[INVALID] Repository placeholder: $relativePath" `
                -ForegroundColor Red

            Add-Failure "Repository placeholder detected: $relativePath"
        }
    }
}

Write-Host "[OK] Repository placeholder validation completed." `
    -ForegroundColor Green

Write-Host ""

# ============================================================================
# 4. Database Entry Point Validation
# ============================================================================

Write-Host "[4/4] Validating database entry point..."
Write-Host ""

$entryPoint = Join-Path `
    $databaseRoot `
    'deployment\install\install.sql'

if (
    -not (
        Test-Path `
            -LiteralPath $entryPoint `
            -PathType Leaf
    )
) {

    $relativeEntryPoint = Get-RelativeRepositoryPath `
        -FullPath $entryPoint

    Write-Host "[INVALID] Missing entry point: $relativeEntryPoint" `
        -ForegroundColor Red

    Add-Failure "Missing database entry point: $relativeEntryPoint"

}
else {

    $entryPointInfo = Get-Item `
        -LiteralPath $entryPoint

    if ($entryPointInfo.Length -eq 0) {

        $relativeEntryPoint = Get-RelativeRepositoryPath `
            -FullPath $entryPoint

        Write-Host "[INVALID] Empty entry point: $relativeEntryPoint" `
            -ForegroundColor Red

        Add-Failure "Empty database entry point: $relativeEntryPoint"

    }
    else {

        $relativeEntryPoint = Get-RelativeRepositoryPath `
            -FullPath $entryPoint

        Write-Host "[OK] $relativeEntryPoint" `
            -ForegroundColor Green
    }
}

Write-Host ""

# ============================================================================
# Final Result
# ============================================================================

Write-Host "============================================================"

if ($failures.Count -eq 0) {

    Write-Host "RELEASE INTEGRITY PASSED." `
        -ForegroundColor Green

    Write-Host "All required build files and release source checks are valid." `
        -ForegroundColor Green

    Write-Host "============================================================"

    exit 0
}

Write-Host (
    "RELEASE INTEGRITY FAILED: {0} issue(s)." -f $failures.Count
) -ForegroundColor Red

Write-Host ""

foreach ($failure in $failures) {

    Write-Host " - $failure" `
        -ForegroundColor Red
}

Write-Host "============================================================"

exit ([Math]::Min(255, $failures.Count))

