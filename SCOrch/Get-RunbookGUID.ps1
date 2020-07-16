
#https://my330space.wordpress.com/2017/07/03/how-to-run-orchestrator-runbook-using-powershell/

# Configure the following variables
$RunbookName = "runbook"
$SCOWebProt = 'http'
$SCOWebSvc = 'server'
$SCOWebPort = '81'
$UseDefaultCreds = $True  # $False, you'll be prompt for credentials

function QuerySCOWebSvc
{ Param ([string] $url)

$textXML = ""

# Get the Request XML
$SCOrequest = [System.Net.HttpWebRequest]::Create($url)
$SCOrequest.Method = "GET"
$SCOrequest.UserAgent = "Microsoft ADO.NET Data Services"

# Set the credentials to default or prompt for credentials
if ($UseDefaultCreds -eq $true)
{ $SCOrequest.UseDefaultCredentials = $true }
Else
{ $SCOrequest.Credentials = Get-Credential }

# Get the response from the request
[System.Net.HttpWebResponse] $SCOresponse = [System.Net.HttpWebResponse] $SCOrequest.GetResponse()

# Build the XML
$reader = [IO.StreamReader] $SCOresponse.GetResponseStream()
$textxml = $reader.ReadToEnd()
[xml]$textxml = $textxml
$reader.Close()

Return $textxml

Trap {
Write-Host "-> Error Querying Orchestrator Web Service."
Return ""
}
}

# Main
$RbkGUID = ""
$RbkName = ""
$RbkPath = ""
$ParamName = ""
$ParamGUID = ""

# Get the Runbook GUID for the specified Runbook Name
$urlrunbook = "$($SCOWebProt)://$($SCOWebSvc):$($SCOWebPort)/Orchestrator2012/Orchestrator.svc/Runbooks?`$filter=Name eq '$RunbookName'"
$runbookxml = QuerySCOWebSvc $urlrunbook

# Get all the entry nodes in case more then 1 match
$RunbookEntries = $runbookxml.getElementsByTagName('entry')
if ($RunbookEntries.count -eq 0) { Write-Host "-> Runbook Not Found" }

foreach ($RunbookEntry in $RunbookEntries)
{
$RbkGUID = $RunbookEntry.GetElementsByTagName("content").childNodes.childnodes.item(0).innerText
$RbkName = $RunbookEntry.GetElementsByTagName("content").childNodes.childnodes.item(2).innerText
$RbkPath = $RunbookEntry.GetElementsByTagName("content").childNodes.childnodes.item(9).innerText
Write-Host "$RbkGUID ($RbkPath)"

# Get list of Parameters for the Runbook
$urlrunbookparam = "$($SCOWebProt)://$($SCOWebSvc):$($SCOWebPort)/Orchestrator2012/Orchestrator.svc/Runbooks(guid'$RbkGUID')/Parameters"
$runbookxmlparam = QuerySCOWebSvc $urlrunbookparam

# Get all the entry nodes
$ParamEntries = $runbookxmlparam.getElementsByTagName('entry')
if ($ParamEntries.count -eq 0) { Write-Host "-> Runbook Parameters Not Found" }

foreach ($ParamEntry in $ParamEntries)
{
$ParamGUID = $ParamEntry.GetElementsByTagName("content").childNodes.childnodes.item(0).innerText
$ParamName = $ParamEntry.GetElementsByTagName("content").childNodes.childnodes.item(2).innerText
Write-Host "$ParamGUID ($ParamName)"

} # Loop ParamEntries
} # Loop RunbookEntries