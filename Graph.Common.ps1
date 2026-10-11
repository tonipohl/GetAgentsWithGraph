# Graph.Common.ps1
# Shared helpers for loading the configured tenant ID and validating the Microsoft Graph session.

function Get-ConfiguredTenantId {
    $tenantIdPath = Join-Path $PSScriptRoot 'tenantid.txt'
    if (-not (Test-Path -LiteralPath $tenantIdPath -PathType Leaf)) {
        throw "Tenant ID file not found: $tenantIdPath"
    }

    $tenantId = (Get-Content -LiteralPath $tenantIdPath -Raw).Trim()
    $parsedTenantId = [guid]::Empty
    if (-not [guid]::TryParse($tenantId, [ref]$parsedTenantId)) {
        throw "Tenant ID file does not contain a valid GUID: $tenantIdPath"
    }

    return $parsedTenantId.ToString()
}

function Assert-GraphConnection {
    param(
        [Parameter(Mandatory)]
        [string]$TenantId
    )

    if (-not (Get-Command Get-MgContext -ErrorAction SilentlyContinue)) {
        throw 'Microsoft Graph PowerShell SDK is not installed. Install Microsoft.Graph.Authentication first.'
    }

    $context = Get-MgContext
    if (-not $context) {
        throw 'Not connected to Microsoft Graph. Run 00-Connect.ps1 first.'
    }

    if ($context.TenantId -ne $TenantId) {
        throw "The active Microsoft Graph session uses tenant '$($context.TenantId)', but tenantid.txt specifies '$TenantId'. Run 00-Connect.ps1."
    }

    if (-not (Get-Command Invoke-MgGraphRequest -ErrorAction SilentlyContinue)) {
        throw 'Invoke-MgGraphRequest is unavailable. Install or import Microsoft.Graph.Authentication.'
    }
}
