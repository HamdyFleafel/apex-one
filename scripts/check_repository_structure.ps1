[CmdletBinding()]
param(
    [string]$RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

$required = @(
    "application",
    "database",
    "database/platform",
    "database/modules",
    "database/deployment",
    "database/verification",
    "database/operations",
    "database/governance/standards",
    "docs",
    "docs/architecture",
    "tests",
    "project-status"
)

$forbidden = @(
    "test",
    "database/architecture",
    "database/monitoring",
    "database/reports",
    "database/restore",
    "database/rollback",
    "database/runbooks",
    "project-tree.txt",
    "project-structure.txt",
    "automation/artifacts/legacy"
)

$errors = New-Object System.Collections.Generic.List[string]

$legacyArtifacts = @(
    "*.bak",
    "*.bom.bak",
    "*.output-hardening.bak",
    "*.workflow-code-index.bak"
)


foreach ($path in $required) {
    $full = Join-Path $RepositoryRoot $path
    if (-not (Test-Path $full)) {
        $errors.Add("Missing required canonical path: $path")
    }
}

foreach ($path in $forbidden) {
    $full = Join-Path $RepositoryRoot $path
    if (Test-Path $full) {
        $errors.Add("Forbidden duplicate/legacy path exists: $path")
    }
}

foreach ($pattern in $legacyArtifacts) {
    Get-ChildItem -Path $RepositoryRoot -Recurse -File -Filter $pattern -ErrorAction SilentlyContinue | ForEach-Object {
        $rel = $_.FullName.Substring($RepositoryRoot.Length).TrimStart("\")
        $errors.Add("Historical/backup artifact must not exist in source tree: $rel")
    }
}

$sourceRoots = @(
    (Join-Path $RepositoryRoot "database/modules"),
    (Join-Path $RepositoryRoot "database/platform")
)

$objectOwners = @{}

$patterns = @(
    @{
        Type  = "TABLE"
        Regex = '(?im)\bCREATE\s+TABLE\s+(?:"?[\w$#]+"?(?:\."?[\w$#]+"?)?)'
    },
    @{
        Type  = "VIEW"
        Regex = '(?im)\bCREATE\s+(?:OR\s+REPLACE\s+)?VIEW\s+(?:"?[\w$#]+"?(?:\."?[\w$#]+"?)?)'
    },
    @{
        Type  = "SEQUENCE"
        Regex = '(?im)\bCREATE\s+(?:OR\s+REPLACE\s+)?SEQUENCE\s+(?:"?[\w$#]+"?(?:\."?[\w$#]+"?)?)'
    },
    @{
        Type  = "PACKAGE"
        Regex = '(?im)\bCREATE\s+(?:OR\s+REPLACE\s+)?PACKAGE(?:\s+BODY)?\s+(?:"?[\w$#]+"?(?:\."?[\w$#]+"?)?)'
    }
)

foreach ($root in $sourceRoots) {

    if (-not (Test-Path -LiteralPath $root -PathType Container)) {
        continue
    }

    $sqlFiles = @(
        Get-ChildItem `
            -LiteralPath $root `
            -Recurse `
            -File `
            -Filter "*.sql" `
            -ErrorAction Stop
    )

    foreach ($file in $sqlFiles) {

        try {
            $sqlContent = Get-Content `
                -LiteralPath $file.FullName `
                -Raw `
                -ErrorAction Stop
        }
        catch {
            $errors.Add(
                "Unable to read SQL file: $($file.FullName). $($_.Exception.Message)"
            )
            continue
        }

        if ($null -eq $sqlContent) {
            $sqlContent = [string]::Empty
        }

        if ([string]::IsNullOrWhiteSpace($sqlContent)) {
            continue
        }

        foreach ($patternDefinition in $patterns) {

            $matches = [regex]::Matches(
                [string]$sqlContent,
                [string]$patternDefinition.Regex
            )

            foreach ($match in $matches) {

                $name = (
                    $match.Value `
                    -replace '(?is)^.*?\b(?:TABLE|VIEW|SEQUENCE|PACKAGE)\s+(?:BODY\s+)?', ''
                ).Trim().Trim('"').ToUpperInvariant()

                if ([string]::IsNullOrWhiteSpace($name)) {
                    continue
                }

                $key = "$($patternDefinition.Type):$name"

                if (-not $objectOwners.ContainsKey($key)) {
                    $objectOwners[$key] = @()
                }

                $objectOwners[$key] += $file.FullName
            }
        }
    }
}

foreach ($key in $objectOwners.Keys) {
    if ($objectOwners[$key].Count -gt 1) {
        $files = ($objectOwners[$key] | ForEach-Object {
            $_.Substring($RepositoryRoot.Length).TrimStart("\")
        }) -join ", "
        $errors.Add("Duplicate database object owner: $key -> $files")
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Repository structure validation FAILED." -ForegroundColor Red
    $errors | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
    exit 1
}

Write-Host "Repository structure validation PASSED." -ForegroundColor Green
Write-Host "Canonical architecture and database object ownership are consistent."
exit 0

