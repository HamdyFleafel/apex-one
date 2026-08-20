# ============================================================================

# APEXONE ORDS Smoke Test

# ============================================================================

[CmdletBinding()]
param(
[string]$BaseUrl = "http://localhost:8080/ords/",
[int]$TimeoutSeconds = 30
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Pass {
param([string]$Message)
Write-Host "[PASS] $Message" -ForegroundColor Green
}

function Write-Fail {
param([string]$Message)
Write-Host "[FAIL] $Message" -ForegroundColor Red
}

function Write-Warn {
param([string]$Message)
Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

$BaseUrl = $BaseUrl.Trim()

if ([string]::IsNullOrWhiteSpace($BaseUrl)) {
throw "BaseUrl cannot be empty."
}

if (-not $BaseUrl.EndsWith('/')) {
$BaseUrl = $BaseUrl + '/'
}

Write-Host ""
Write-Host "============================================================"
Write-Host "APEXONE ORDS SMOKE TEST"
Write-Host "============================================================"
Write-Host ""

Write-Host "ORDS Base URL:"
Write-Host $BaseUrl
Write-Host ""

Write-Host "[1/3] Testing ORDS connectivity..."
Write-Host ""

try {
$response = Invoke-WebRequest -Uri $BaseUrl -Method Get -TimeoutSec $TimeoutSeconds -ErrorAction Stop

$statusCode = [int]$response.StatusCode

if ($statusCode -ge 200 -and $statusCode -lt 500) {
    Write-Pass "ORDS endpoint responded with HTTP $statusCode."
}
else {
    throw "Unexpected HTTP status code: $statusCode"
}

}
catch {
Write-Fail "Unable to reach ORDS endpoint."
Write-Host $_.Exception.Message -ForegroundColor Red
exit 1
}

Write-Host ""
Write-Host "[2/3] Validating ORDS HTTP response..."
Write-Host ""

if ($null -eq $response) {
Write-Fail "ORDS returned no response."
exit 1
}

$responseContent = [string]$response.Content

if ([string]::IsNullOrWhiteSpace($responseContent)) {
Write-Warn "ORDS responded successfully but returned an empty response body."
}
else {
Write-Pass "ORDS returned a response body."
}

Write-Host ""
Write-Host "[3/3] Finalizing smoke test..."
Write-Host ""

Write-Pass "ORDS smoke test completed successfully."

Write-Host ""
Write-Host "============================================================"
Write-Host "APEXONE ORDS SMOKE TEST PASSED"
Write-Host "============================================================"
Write-Host ""

exit 0
