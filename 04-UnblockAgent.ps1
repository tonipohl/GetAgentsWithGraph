# 04-UnblockAgent.ps1
# atwork.at. Toni Pohl
# Unblock a Copilot package to allow its usage.
# https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/package/copilotpackage-unblock
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
$uri = "https://graph.microsoft.com/beta/copilot/admin/catalog/packages/$escapedPackageId/unblock"

if ($PSCmdlet.ShouldProcess($PackageId, 'Unblock Copilot package')) {
    Invoke-MgGraphRequest -Method POST -Uri $uri | Out-Null
    Write-Host "Unblocked Copilot package '$PackageId'."
}