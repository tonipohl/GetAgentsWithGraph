# 06-GetOneAgent.ps1
# atwork.at. Toni Pohl
# Retrieves one agent package.
# https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/package/copilotpackages-list?pivots=graph-v1
# Note: Delegated + Application permissions: CopilotPackages.Read.All

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$PackageId
)

. (Join-Path $PSScriptRoot 'Graph.Common.ps1')

$tenantId = Get-ConfiguredTenantId
Assert-GraphConnection -TenantId $tenantId

$escapedPackageId = [uri]::EscapeDataString($PackageId)
$uri = "https://graph.microsoft.com/v1.0/copilot/admin/catalog/packages/$escapedPackageId"
$agent = Invoke-MgGraphRequest -Method GET -Uri $uri -ErrorAction Stop
$agentJson = ConvertTo-Json -InputObject $agent -Depth 100

# Show all agent properties:
Write-Output $agentJson
$agentForSummary = ConvertFrom-Json -InputObject $agentJson

# Prepare only specific properties as overview:
$summaryProperties = @(
    'id', 'displayName', 'appId', 'ownerId', 'isBlocked', 'availableTo',
    'publisher', 'shortDescription', 'activeUsers'
)

Write-Output ''
Write-Output "Selected properties of $PackageId"
$agentForSummary | Select-Object -Property $summaryProperties | Format-List