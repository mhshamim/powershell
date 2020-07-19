# System Center Virtual Machine Manager Powershell

Powershell scripts/cmdlet

### vmm-logical-networks-export.ps1

Gets the list of logical networks configured in the Virtual machine manager.

```sh
PS C:\> vmm-logical-networks-export.ps1

LogicalNetworkName Name                 Subnet          VlanID
------------------ ----                 ------          ------
MGMT Network       MGMT TEAM - VLAN		  192.1.50.0/24       750
TST_VLAN		       TST_VLAN754_0     	  192.1.54.0/24       754
Multiple Networks  Multiple Networks    192.1.42.0/24       742
Multiple Networks  Multiple Networks    192.1.36.0/24       736

```
