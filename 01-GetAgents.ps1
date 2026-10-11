# 01-GetAgents.ps1 
# atwork.at. Toni Pohl
# Retrieves a list of all packages available in the tenant.
# https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/package/copilotpackages-list?pivots=graph-v1
# Note: Delegated + Application permissions: CopilotPackages.Read.All

[CmdletBinding()]
param(
    [string]$OutputDirectory = $PSScriptRoot
)

. (Join-Path $PSScriptRoot 'Graph.Common.ps1')

$tenantId = Get-ConfiguredTenantId
Assert-GraphConnection -TenantId $tenantId

$uri = "https://graph.microsoft.com/v1.0/copilot/admin/catalog/packages?`$filter=supportedHosts/any(h:h eq 'Copilot')"
$packages = [System.Collections.Generic.List[object]]::new()

do {
    $response = Invoke-MgGraphRequest -Method GET -Uri $uri
    foreach ($package in $response.value) {
        $packages.Add($package)
    }
    $uri = $response.'@odata.nextLink'
} while ($uri)

# Write the result to files
if (-not (Test-Path -LiteralPath $OutputDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}

$csvPath = Join-Path $OutputDirectory 'agents.csv'
$jsonPath = Join-Path $OutputDirectory 'agents.json'

$agentJson = ConvertTo-Json -InputObject @($packages.ToArray()) -Depth 100
$agentJson | Set-Content -LiteralPath $jsonPath -Encoding UTF8

$csvPackages = @(ConvertFrom-Json -InputObject $agentJson)
$csvColumns = @(
    'appId', 'displayName', 'id', 'version', 'ownerId', 'publisher', 
    'deployedTo', 'requestType', 'type', 'isBlocked',
    'createdDateTime', 'shortDescription', 'availableTo',
    'lastModifiedDateTime', 'platform'
)
# Remove linebreaks to get a clean CSV file: one row per agent
$csvPackages |
    Select-Object -Property $csvColumns |
    ForEach-Object {
        if ($null -ne $_.shortDescription) {
            $_.shortDescription = [regex]::Replace($_.shortDescription, '\s*[\r\n]+\s*', ' ').Trim()
        }
        $_
    } |
    Export-Csv -LiteralPath $csvPath -NoTypeInformation -Encoding UTF8

Write-Host "Retrieved $($packages.Count) agents."
Write-Host "CSV:  $csvPath"
Write-Host "JSON: $jsonPath"
$packages | Select-Object displayName, id, isBlocked | Format-Table -AutoSize