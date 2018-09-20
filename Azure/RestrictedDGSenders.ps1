## Restrict Distribution group senders to Staff Only. 
## Josh A - Sept 2017. 
## This script simply restricts distribution group sending to allowed users only.
## Uses - Stopping users from emailing any dist group such as class groups or 'all-staff' etc.

## ---------- Variables
# Change the below as required. 

# Your OU containing groups. 
$SearchBase ='OU=Groups,OU=OU2,DC=DOAMIN,DC=nz'
# Your security group that contains allowed senders.
$AllowedUsers = "CN=Perm-AllowedToSendToDistributionLists,OU=Office365 Groups,OU=Groups,OU=OU1,DC=DOMAIN,DC=nz"

## ---------- Start

Foreach ($group in (Get-ADGroup -Filter * -SearchBase $SearchBase)) {
  Write-Host "Appling rule to $group"
  Set-ADGroup $group.DistinguishedName -add @{msExchRequireAuthToSendTo=$true}
  Set-ADGroup $group.DistinguishedName -add @{dlMemSubmitPerms=$AllowedUsers}
  }
