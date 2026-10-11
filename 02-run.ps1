# 02-run.ps1 

$agentsTestersGroupId = '<Group-ID>'
$agent = "<your-agent-packageid>"

.\02-UpdateAgent.ps1 `
  -PackageId $agent `
  -AvailableTo 'allowedForSome' `
  -AllowedUsersAndGroups @{ resourceType = 'group'; resourceId = $agentsTestersGroupId } `
  -Confirm:$false
  