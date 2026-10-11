# 03-run.ps1 

$agent = "<your-agent-packageid>"

.\03-BlockAgent.ps1 `
  -PackageId $agent `
  -Confirm:$false
