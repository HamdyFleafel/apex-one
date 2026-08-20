# =============================================================================
# Project        : APEXONE Enterprise Platform
# Component      : ORDS
# File           : SMOKE_TEST_CREATE_USER.ps1
# Purpose        : Runtime smoke tests for POST /api/v1/users
# Version        : 2.0.1-final
# =============================================================================

param (
    [string]$BaseUrl = "http://localhost:8080/ords/apexone/api/v1/users"
)

function Invoke-ApexOneRequest {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Body
    )

    try {
        $response = Invoke-WebRequest `
            -Uri $BaseUrl `
            -Method POST `
            -ContentType "application/json" `
            -Body $Body `
            -UseBasicParsing `
            -ErrorAction Stop

        return @{
            StatusCode = [int]$response.StatusCode
            Content    = $response.Content
        }
    }
    catch {
        $response = $_.Exception.Response

        if ($null -ne $response) {

            $reader = New-Object System.IO.StreamReader(
                $response.GetResponseStream()
            )

            $content = $reader.ReadToEnd()

            return @{
                StatusCode = [int]$response.StatusCode
                Content    = $content
            }
        }

        throw $_
    }
}

function Assert-StatusCode {
    param (
        [Parameter(Mandatory = $true)]
        [string]$TestName,

        [Parameter(Mandatory = $true)]
        [int]$ExpectedStatusCode,

        [Parameter(Mandatory = $true)]
        [hashtable]$Response
    )

    if ($Response.StatusCode -eq $ExpectedStatusCode) {

        Write-Host ""
        Write-Host "PASS - $TestName -> $ExpectedStatusCode"

        Write-Host $Response.Content
    }
    else {

        Write-Host ""
        Write-Host "FAIL - $TestName"
        Write-Host "Expected Status Code: $ExpectedStatusCode"
        Write-Host "Actual Status Code:   $($Response.StatusCode)"
        Write-Host "Response Body:"
        Write-Host $Response.Content

        exit 1
    }
}

Write-Host ""
Write-Host "============================================================"
Write-Host "APEXONE ORDS CREATE USER SMOKE TEST"
Write-Host "============================================================"

# =============================================================================
# Generate unique values to allow repeated execution.
# =============================================================================

$Timestamp = Get-Date -Format "yyyyMMddHHmmssfff"

$CreateUsername = "smoke_user_$Timestamp"
$CreateEmail    = "smoke_user_$Timestamp@example.com"

$DuplicateUsername = "duplicate_user_$Timestamp"
$DuplicateEmail    = "duplicate_user_$Timestamp@example.com"

$Password = "SmokeTestPassword123!"

# =============================================================================
# TEST 1 - Successful user creation
# Expected: 201
# =============================================================================

$response = Invoke-ApexOneRequest `
    -Body @"
{
    "username": "$CreateUsername",
    "email": "$CreateEmail",
    "password": "$Password"
}
"@

Assert-StatusCode `
    -TestName "Create user" `
    -ExpectedStatusCode 201 `
    -Response $response


# =============================================================================
# TEST 2 - Missing password
# Expected: 400
# =============================================================================

$response = Invoke-ApexOneRequest `
    -Body @"
{
    "username": "missing_password_$Timestamp",
    "email": "missing_password_$Timestamp@example.com"
}
"@

Assert-StatusCode `
    -TestName "Missing password" `
    -ExpectedStatusCode 400 `
    -Response $response


# =============================================================================
# TEST 3 - Invalid JSON
# Expected: 400
# =============================================================================

$response = Invoke-ApexOneRequest `
    -Body @"
{
    "username": "invalid_json_$Timestamp",
    "email": "invalid_json_$Timestamp@example.com",
    "password": "$Password"
"@

Assert-StatusCode `
    -TestName "Invalid JSON" `
    -ExpectedStatusCode 400 `
    -Response $response


# =============================================================================
# TEST 4 - Seed duplicate identity
# Expected: 201
# =============================================================================

$response = Invoke-ApexOneRequest `
    -Body @"
{
    "username": "$DuplicateUsername",
    "email": "$DuplicateEmail",
    "password": "$Password"
}
"@

Assert-StatusCode `
    -TestName "Duplicate seed" `
    -ExpectedStatusCode 201 `
    -Response $response


# =============================================================================
# TEST 5 - Duplicate username
# Expected: 409
# =============================================================================

$response = Invoke-ApexOneRequest `
    -Body @"
{
    "username": "$DuplicateUsername",
    "email": "different_email_$Timestamp@example.com",
    "password": "$Password"
}
"@

Assert-StatusCode `
    -TestName "Duplicate username" `
    -ExpectedStatusCode 409 `
    -Response $response


# =============================================================================
# TEST 6 - Duplicate email
# Expected: 409
# =============================================================================

$response = Invoke-ApexOneRequest `
    -Body @"
{
    "username": "different_username_$Timestamp",
    "email": "$DuplicateEmail",
    "password": "$Password"
}
"@

Assert-StatusCode `
    -TestName "Duplicate email" `
    -ExpectedStatusCode 409 `
    -Response $response


Write-Host ""
Write-Host "============================================================"
Write-Host "APEXONE ORDS SMOKE TEST COMPLETED SUCCESSFULLY"
Write-Host "============================================================"