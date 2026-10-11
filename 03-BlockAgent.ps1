# 03-BlockAgent.ps1
# atwork.at. Toni Pohl
# Block a Copilot package to prevent its usage.
# https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/package/copilotpackage-block
# Note: Application	Not available.

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$PackageId
)

. (Join-Path $PSScriptRoot 'Graph.Common.ps1')

$tenantId = Get-ConfiguredTenantId
Assert-GraphConnection -TenantId $tenantId

$escapedPackageId = [uri]::EscapeDataString($PackageId)
$uri = "https://graph.microsoft.com/beta/copilot/admin/catalog/packages/$escapedPackageId/block"

if ($PSCmdlet.ShouldProcess($PackageId, 'Block Copilot package')) {
    Invoke-MgGraphRequest -Method POST -Uri $uri | Out-Null
    Write-Host "Blocked Copilot package '$PackageId'."
}