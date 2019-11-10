## Restrict Distribution group senders to Staff Only. 
## Josh A - Sept 2017 - Last update - June 2019
## This script simply restricts distribution group sending to allowed users only.
## Uses - Stopping users from emailing any dist group such as class groups or 'all-staff' etc.
##
## This is super dirty, and janky, and needs to be tidied with loops when poss.

## ---------- Variables
# Change the below as required. 

# Your OU containing groups. 
$SearchBase ='OU=Groups,OU=OU2,DC=DOAMIN,DC=nz'
# Your security group that contains allowed senders.
$AllowedUsers = "CN=Perm-AllowedToSendToDistributionLists,OU=Office365 Groups,OU=Groups,OU=OU1,DC=DOMAIN,DC=nz"
# NUll sender group
$NULLUsers = "CN=Perm-NULLSending,OU=Office365 Groups,OU=Groups,OU=OU1,DC=DOMAIN,DC=nz"

## ---------- Start

Foreach ($group in (Get-ADGroup -Filter * -SearchBase $SearchBase)) {
  Write-Host "Appling rule to $group"
  Set-ADGroup $group.DistinguishedName -add @{msExchRequireAuthToSendTo=$true}
  Set-ADGroup $group.DistinguishedName -add @{dlMemSubmitPerms=$AllowedUsers}
  }

## ---------- Groups to hide.

  Set-ADGroup "Subject 09AMP" -add @{msExchHideFromAddressLists=$true}
  Set-ADGroup "Subject 10AMP" -add @{msExchHideFromAddressLists=$true} 
  Set-ADGroup "Subject 11AMP" -add @{msExchHideFromAddressLists=$true}
  Set-ADGroup "Subject 12AMP" -add @{msExchHideFromAddressLists=$true} 
  Set-ADGroup "Subject 13AMP" -add @{msExchHideFromAddressLists=$true}

#Now Remove permissions to global Form Classes - We have to do this so that no one emails these groups by accident. Groups still needed at the moment. 
  $group="Subject 09AMP"
  Set-ADGroup $group -add @{msExchRequireAuthToSendTo=$true}
  Set-ADGroup $group -remove @{dlMemSubmitPerms=$AllowedUsers}
  Set-ADGroup $group -add @{dlMemSubmitPerms=$NULLUsers}
  $group="Subject 10AMP"
  Set-ADGroup $group -add @{msExchRequireAuthToSendTo=$true}
  Set-ADGroup $group -remove @{dlMemSubmitPerms=$AllowedUsers}
  Set-ADGroup $group -add @{dlMemSubmitPerms=$NULLUsers}
  $group="Subject 11AMP"
  Set-ADGroup $group -add @{msExchRequireAuthToSendTo=$true}
  Set-ADGroup $group -remove @{dlMemSubmitPerms=$AllowedUsers}
  Set-ADGroup $group -add @{dlMemSubmitPerms=$NULLUsers}
  $group="Subject 12AMP"
  Set-ADGroup $group -add @{msExchRequireAuthToSendTo=$true}
  Set-ADGroup $group -remove @{dlMemSubmitPerms=$AllowedUsers}
  Set-ADGroup $group -add @{dlMemSubmitPerms=$NULLUsers}
  $group="Subject 13AMP"
  Set-ADGroup $group -add @{msExchRequireAuthToSendTo=$true}
  Set-ADGroup $group -remove @{dlMemSubmitPerms=$AllowedUsers}
  Set-ADGroup $group -add @{dlMemSubmitPerms=$NULLUsers}
  
  ## - Done
