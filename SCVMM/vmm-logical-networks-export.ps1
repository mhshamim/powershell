Import-Module virtualmachinemanager 
# all Logical network definitions 
$LogicalNetsdef = Get-SCLogicalNetworkDefinition

Foreach ($def in $LogicalNetsdef){ 
    foreach ($SubnetVlan in $def.SubnetVLans){ 
        $data=[ordered]@{ 
                    LogicalNetworkName = $def.LogicalNetwork.Name 
                    Name=$def.Name 
                    Subnet=$SubnetVlan.Subnet 
                    VlanID=$SubnetVlan.VLanID 
                } 
         $Obj=New-Object -TypeName PSObject -Property $data 
         Write-Output $Obj  
    } 
}