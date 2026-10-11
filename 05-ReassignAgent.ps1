# 05-ReassignAgent.ps1
# atwork.at. Toni Pohl
# Reassign ownership of a Copilot package to a different user.
# https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/package/copilotpackage-reassign
# Note: Application	Not available.

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$PackageId,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$UserId
)

. (Join-Path $PSScriptRoot 'Graph.Common.ps1')

$tenantId = Get-ConfiguredTenantId
Assert-GraphConnection -TenantId $tenantId

$escapedPackageId = [uri]::EscapeDataString($PackageId)
$uri = "https://graph.microsoft.com/beta/copilot/admin/catalog/packages/$escapedPackageId/reassign"
$body = ConvertTo-Json -InputObject @{ userId = $UserId } -Depth 3

if ($PSCmdlet.ShouldProcess($PackageId, "Reassign Copilot package to user '$UserId'")) {
    Invoke-MgGraphRequest -Method POST -Uri $uri -Body $body -ContentType 'application/json' -ErrorAction Stop | Out-Null
    Write-Host "Reassigned Copilot package '$PackageId' to '$UserId'."
}