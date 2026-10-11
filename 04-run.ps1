# 04-run.ps1 

$agent = "<your-agent-packageid>"

.\04-UnblockAgent.ps1 `
  -PackageId $agent `
  -Confirm:$false
