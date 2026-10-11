# 00-Connect.ps1
# atwork.at. Toni Pohl
# Working with Graph API for CopilotPackages management.
# Requirements: Microsoft.Graph.Authentication, a valid tenantid.txt beside this script,
# and a work/school account authorized for CopilotPackages.ReadWrite.All and User.ReadBasic.All.
# Access to the Package Management API requires a Microsoft Agent 365 license.
# https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/package/overview

[CmdletBinding()]
param()

# Load and run Graph.Common.ps1 in the current scope. 
. (Join-Path $PSScriptRoot 'Graph.Common.ps1')

$tenantId = Get-ConfiguredTenantId

if (-not (Get-Command Connect-MgGraph -ErrorAction SilentlyContinue)) {
    throw 'Microsoft Graph PowerShell SDK is not installed. Install Microsoft.Graph.Authentication first.'
}

# Connect to Graph.
# We need CopilotPackages.ReadWrite.All and User.ReadBasic.All to get the user information and reassign Copilot packages.
Connect-MgGraph -TenantId $tenantId -Scopes 'CopilotPackages.ReadWrite.All', 'User.ReadBasic.All' -NoWelcome

# Check connection and context
Get-MgContext | Format-List Account, TenantId, Scopes

# Continue with the script to interact with Copilot packages as needed.
