# 05-run.ps1 

$agent = "<your-agent-packageid>"

# Specify the new owner by UPN
# $newuser = "martina@atwork.fun"
$newuser = "toni@atwork.fun"

. (Join-Path $PSScriptRoot 'Graph.Common.ps1')

$tenantId = Get-ConfiguredTenantId
Assert-GraphConnection -TenantId $tenantId

$context = Get-MgContext
if ($context.Scopes -notcontains 'User.ReadBasic.All') {
  throw 'The current Graph session lacks User.ReadBasic.All. Run 00-Connect.ps1 again and grant the requested permission.'
}

$escapedUpn = [uri]::EscapeDataString($newuser)
$userUri = "https://graph.microsoft.com/v1.0/users/${escapedUpn}?`$select=id,userPrincipalName,displayName"
$resolvedUser = Invoke-MgGraphRequest -Method GET -Uri $userUri -ErrorAction Stop
$newOwnerId = $resolvedUser.id
if ([string]::IsNullOrWhiteSpace($newOwnerId)) {
  throw "Microsoft Graph did not return an ID for user '$newuser'."
}

Write-Host "Resolved '$newuser' to '$($resolvedUser.userPrincipalName)' ($newOwnerId)."

& (Join-Path $PSScriptRoot '05-ReassignAgent.ps1') `
  -PackageId $agent `
  -UserId $newOwnerId `
  -Confirm:$false
