# System Center Orchestrator Powershell

Powershell scripts/cmdlet

### Get-RunbookGUID

Gets runbook GUID from Orchestrator and lists the GUIDs of respective parameters as well for the same runbook. It will scan and run the GUIDs of all runbooks with the same name.

### Start-RunbookJob

Useful in triggering the Runbook Job for respective Runbook configured in $runbookPath and with required $parameter as input.