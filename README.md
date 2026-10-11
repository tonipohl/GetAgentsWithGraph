# GetAgentsWithGraph

PowerShell examples for managing Microsoft 365 Copilot agent packages through the Microsoft Graph package management API. The scripts connect to Graph, list and inspect packages, and update, block, unblock, or reassign them.

## Prerequisites

- PowerShell.
- The `Microsoft.Graph.Authentication` module.
- A work or school account with the required Microsoft Graph permissions for the operation. `00-Connect.ps1` requests `CopilotPackages.ReadWrite.All` and `User.ReadBasic.All`.
- An applicable Microsoft Agent 365 license for Package Management API access.
- A valid tenant GUID in `tenantid.txt` beside the scripts.

## Getting started

1. Set `tenantid.txt` to the tenant GUID to use.
2. Connect to Microsoft Graph:

   ```powershell
   .\00-Connect.ps1
   ```

3. Run a read or management script in the same PowerShell session. The scripts validate that Graph is connected to the tenant in `tenantid.txt`.

The scripts load shared functions from `Graph.Common.ps1`. This helper reads and validates the tenant ID and checks that the current Graph session is connected to the configured tenant.

## Scripts

| Script | Purpose |
| --- | --- |
| `00-Connect.ps1` | Connects to Microsoft Graph using the tenant in `tenantid.txt` and requests the required delegated scopes. |
| `01-GetAgents.ps1` | Lists Copilot-supported packages and writes `agents.csv` and `agents.json` to the chosen output directory (the script directory by default). |
| `02-UpdateAgent.ps1` | Updates package properties such as availability, deployment, allowed users/groups, and acquisition users/groups. Supports `-WhatIf` and confirmation. |
| `03-BlockAgent.ps1` | Blocks a package. Supports `-WhatIf` and confirmation. |
| `04-UnblockAgent.ps1` | Unblocks a package. Supports `-WhatIf` and confirmation. |
| `05-ReassignAgent.ps1` | Reassigns a package to a Graph user ID. Supports `-WhatIf` and confirmation. |
| `06-GetOneAgent.ps1` | Retrieves one package by ID and displays its full JSON plus selected summary properties. |
| `Graph.Common.ps1` | Shared tenant-ID and Graph-session helper functions; normally dot-sourced by the other scripts. |

## Example runners

The numbered `*-run.ps1` files show example invocations:

- `02-run.ps1` updates a package's availability for a configured group.
- `03-run.ps1` blocks a configured package.
- `04-run.ps1` unblocks a configured package.
- `05-run.ps1` looks up a configured user's ID from their UPN, then reassigns a configured package to that user.
- `06-run.ps1` retrieves the configured package's details.

These are examples, not generic command-line interfaces: edit their package IDs, group ID, and user UPN before use. In particular, `02-run.ps1` through `05-run.ps1` pass `-Confirm:$false`, so they do not prompt before making changes. Review the values and target carefully before running them.

## Direct usage examples

```powershell
# List packages and save the output in a different directory
.\01-GetAgents.ps1 -OutputDirectory .\output

# Inspect one package
.\06-GetOneAgent.ps1 -PackageId 'PACKAGE_ID'

# Preview a package update without applying it
.\02-UpdateAgent.ps1 -PackageId 'PACKAGE_ID' -AvailableTo 'allowedForAll' -WhatIf

# Preview blocking a package
.\03-BlockAgent.ps1 -PackageId 'PACKAGE_ID' -WhatIf
```

Run `00-Connect.ps1` first in the same session. Package IDs and API-supported property values depend on the target package and Microsoft Graph API behavior.

## API references

- [Copilot package management API overview](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/package/overview)
- [List packages](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/package/copilotpackages-list)
- [Update package details](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/package/copilotpackagedetail-update)
- [Block a package](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/package/copilotpackage-block)
- [Unblock a package](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/package/copilotpackage-unblock)
- [Reassign a package](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/api/admin-settings/package/copilotpackage-reassign)
