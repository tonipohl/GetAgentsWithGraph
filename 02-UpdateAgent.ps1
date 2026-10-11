# 02-UpdateAgent.ps1
# atwork.at. Toni Pohl
# Update a copilotPackageDetail object.
# https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/package/copilotpackagedetail-update
# Note: Application	Not available.

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$PackageId,

    [string]$AvailableTo,

    [string]$DeployedTo,

    [hashtable[]]$AllowedUsersAndGroups,

    [hashtable[]]$AcquireUsersAndGroups
)

. (Join-Path $PSScriptRoot 'Graph.Common.ps1')

$tenantId = Get-ConfiguredTenantId
Assert-GraphConnection -TenantId $tenantId

$body = @{}
if ($PSBoundParameters.ContainsKey('AvailableTo')) {
    $body.availableTo = $AvailableTo
}
if ($PSBoundParameters.ContainsKey('DeployedTo')) {
    $body.deployedTo = $DeployedTo
}
if ($PSBoundParameters.ContainsKey('AllowedUsersAndGroups')) {
    $body.allowedUsersAndGroups = @($AllowedUsersAndGroups)
    if (-not $PSBoundParameters.ContainsKey('AvailableTo')) {
        throw 'Specify -AvailableTo when updating -AllowedUsersAndGroups.'
    }
}
if ($PSBoundParameters.ContainsKey('AcquireUsersAndGroups')) {
    $body.acquireUsersAndGroups = @($AcquireUsersAndGroups)
    if (-not $PSBoundParameters.ContainsKey('DeployedTo')) {
        throw 'Specify -DeployedTo when updating -AcquireUsersAndGroups.'
    }
}
if ($body.Count -eq 0) {
    throw 'Specify at least one package property to update.'
}

$escapedPackageId = [uri]::EscapeDataString($PackageId)
$uri = "https://graph.microsoft.com/beta/copilot/admin/catalog/packages/$escapedPackageId"
$jsonBody = ConvertTo-Json -InputObject $body -Depth 10

if ($PSCmdlet.ShouldProcess($PackageId, 'Update Copilot package')) {
    Invoke-MgGraphRequest -Method PATCH -Uri $uri -Body $jsonBody -ContentType 'application/json' -ErrorAction Stop | Out-Null

    $detailsUri = "https://graph.microsoft.com/v1.0/copilot/admin/catalog/packages/$escapedPackageId"
    $updatedPackage = Invoke-MgGraphRequest -Method GET -Uri $detailsUri -ErrorAction Stop

    Write-Host "Updated Copilot package '$PackageId'. Changed details returned by Graph:"
    $updatedPackage | Select-Object -Property @($body.Keys) | Format-List
}

<# 
Note if this error happens:
Admins Cannot modify allow policy for Shared Titles
The request was rejected by Graph: 
this agent is type: shared, and the API explicitly disallows admins from changing the allow policy for Shared titles. 
The group ID and command syntax aren’t the cause; this endpoint can’t restrict this title to AgentsTesters. 
The failed request should leave availableTo unchanged.
#>
