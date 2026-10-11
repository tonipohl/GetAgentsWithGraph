# 06-run.ps1 

$agent = "<your-agent-packageid>"

& (Join-Path $PSScriptRoot '06-GetOneAgent.ps1') -PackageId $agent
