#####
##
## SortStudentGender.ps1
##
## This script polls student accounts checking for the value in 'DepartmentNumber'
## Based on the value returned the student is moved to a group for this gender, their year level, and their Surname first letter.
##
## These groups are then used for BYOD radius to break students down to managable chunks for VLAN assignment. 
## Another messey script, but was done in a pinch, and it works. Come back later to do loops and grouping. 
##
## Josh A - Jan 2019
##
##### 
#
# (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
# | Where-Object { $_.Surname -like  "A*" -or ($_.Surname -like  "B*") -or ($_.Surname -like  "C*") -or ($_.Surname -like  "D*")-or ($_.Surname -like  "E*")-or ($_.Surname -like  "F*") -or ($_.Surname -like  "G*") -or ($_.Surname -like  "H*") -or ($_.Surname -like  "I*") -or ($_.Surname -like  "J*") -or ($_.Surname -like  "K*") -or ($_.Surname -like  "L*") -or ($_.Surname -like  "M*") }
#
# | Where-Object { $_.Surname -like  "N*" -or ($_.Surname -like  "O*") -or ($_.Surname -like  "P*") -or ($_.Surname -like  "Q*")-or ($_.Surname -like  "R*")-or ($_.Surname -like  "S*") -or ($_.Surname -like  "T*") -or ($_.Surname -like  "U*") -or ($_.Surname -like  "V*") -or ($_.Surname -like  "W*") -or ($_.Surname -like  "X*") -or ($_.Surname -like  "Y*") -or ($_.Surname -like  "Z*") } 
#
# ~~~ Start

#Clean up old groups



####
#### All Y9 Male A-M
####
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y09-Male-A_M"
$Filter = "Y9-M"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{(departmentNumber -like $Filter)} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "A*" -or ($_.Surname -like  "B*") -or ($_.Surname -like  "C*") -or ($_.Surname -like  "D*")-or ($_.Surname -like  "E*")-or ($_.Surname -like  "F*") -or ($_.Surname -like  "G*") -or ($_.Surname -like  "H*") -or ($_.Surname -like  "I*") -or ($_.Surname -like  "J*") -or ($_.Surname -like  "K*") -or ($_.Surname -like  "L*") -or ($_.Surname -like  "M*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
####
#### All Y9 Male N-Z
####
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y09-Male-N_Z"
$Filter = "Y9-M"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{(departmentNumber -like $Filter)} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "N*" -or ($_.Surname -like  "O*") -or ($_.Surname -like  "P*") -or ($_.Surname -like  "Q*")-or ($_.Surname -like  "R*")-or ($_.Surname -like  "S*") -or ($_.Surname -like  "T*") -or ($_.Surname -like  "U*") -or ($_.Surname -like  "V*") -or ($_.Surname -like  "W*") -or ($_.Surname -like  "X*") -or ($_.Surname -like  "Y*") -or ($_.Surname -like  "Z*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
####
#### All Y9 Females A-M
####
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y09-Female-A_M"
$Filter = "Y9-F"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "A*" -or ($_.Surname -like  "B*") -or ($_.Surname -like  "C*") -or ($_.Surname -like  "D*")-or ($_.Surname -like  "E*")-or ($_.Surname -like  "F*") -or ($_.Surname -like  "G*") -or ($_.Surname -like  "H*") -or ($_.Surname -like  "I*") -or ($_.Surname -like  "J*") -or ($_.Surname -like  "K*") -or ($_.Surname -like  "L*") -or ($_.Surname -like  "M*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /22 has 512 usable addresses."
####
#### All Y9 Females N-Z
####
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y09-Female-N_Z"
$Filter = "Y9-F"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "N*" -or ($_.Surname -like  "O*") -or ($_.Surname -like  "P*") -or ($_.Surname -like  "Q*")-or ($_.Surname -like  "R*")-or ($_.Surname -like  "S*") -or ($_.Surname -like  "T*") -or ($_.Surname -like  "U*") -or ($_.Surname -like  "V*") -or ($_.Surname -like  "W*") -or ($_.Surname -like  "X*") -or ($_.Surname -like  "Y*") -or ($_.Surname -like  "Z*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /22 has 512 usable addresses."
####
#### All Y10 Males A-M
####
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y10-Male-A_M"
$Filter = "Y10-M"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "A*" -or ($_.Surname -like  "B*") -or ($_.Surname -like  "C*") -or ($_.Surname -like  "D*")-or ($_.Surname -like  "E*")-or ($_.Surname -like  "F*") -or ($_.Surname -like  "G*") -or ($_.Surname -like  "H*") -or ($_.Surname -like  "I*") -or ($_.Surname -like  "J*") -or ($_.Surname -like  "K*") -or ($_.Surname -like  "L*") -or ($_.Surname -like  "M*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
####
#### All Y10 Males N-Z
####
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y10-Male-N_Z"
$Filter = "Y10-M"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "N*" -or ($_.Surname -like  "O*") -or ($_.Surname -like  "P*") -or ($_.Surname -like  "Q*")-or ($_.Surname -like  "R*")-or ($_.Surname -like  "S*") -or ($_.Surname -like  "T*") -or ($_.Surname -like  "U*") -or ($_.Surname -like  "V*") -or ($_.Surname -like  "W*") -or ($_.Surname -like  "X*") -or ($_.Surname -like  "Y*") -or ($_.Surname -like  "Z*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
####
#### All Y10 females A-M
#### 
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y10-Female-A_M"
$Filter = "Y10-F"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "A*" -or ($_.Surname -like  "B*") -or ($_.Surname -like  "C*") -or ($_.Surname -like  "D*")-or ($_.Surname -like  "E*")-or ($_.Surname -like  "F*") -or ($_.Surname -like  "G*") -or ($_.Surname -like  "H*") -or ($_.Surname -like  "I*") -or ($_.Surname -like  "J*") -or ($_.Surname -like  "K*") -or ($_.Surname -like  "L*") -or ($_.Surname -like  "M*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
####
#### All Y10 females N-Z
#### 
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y10-Female-N_Z"
$Filter = "Y10-F"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "N*" -or ($_.Surname -like  "O*") -or ($_.Surname -like  "P*") -or ($_.Surname -like  "Q*")-or ($_.Surname -like  "R*")-or ($_.Surname -like  "S*") -or ($_.Surname -like  "T*") -or ($_.Surname -like  "U*") -or ($_.Surname -like  "V*") -or ($_.Surname -like  "W*") -or ($_.Surname -like  "X*") -or ($_.Surname -like  "Y*") -or ($_.Surname -like  "Z*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
####
#### All Y11 Male A-M
####
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y11-Male-A_M"
$Filter = "Y11-M"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" }  | Where-Object { $_.Surname -like  "A*" -or ($_.Surname -like  "B*") -or ($_.Surname -like  "C*") -or ($_.Surname -like  "D*")-or ($_.Surname -like  "E*")-or ($_.Surname -like  "F*") -or ($_.Surname -like  "G*") -or ($_.Surname -like  "H*") -or ($_.Surname -like  "I*") -or ($_.Surname -like  "J*") -or ($_.Surname -like  "K*") -or ($_.Surname -like  "L*") -or ($_.Surname -like  "M*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
####
#### All Y11 Male N-Z
####
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y11-Male-N_Z"
$Filter = "Y11-M"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "N*" -or ($_.Surname -like  "O*") -or ($_.Surname -like  "P*") -or ($_.Surname -like  "Q*")-or ($_.Surname -like  "R*")-or ($_.Surname -like  "S*") -or ($_.Surname -like  "T*") -or ($_.Surname -like  "U*") -or ($_.Surname -like  "V*") -or ($_.Surname -like  "W*") -or ($_.Surname -like  "X*") -or ($_.Surname -like  "Y*") -or ($_.Surname -like  "Z*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
#
#### All Y11 Female A-M
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y11-Female-A_M"
$Filter = "Y11-F"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "A*" -or ($_.Surname -like  "B*") -or ($_.Surname -like  "C*") -or ($_.Surname -like  "D*")-or ($_.Surname -like  "E*")-or ($_.Surname -like  "F*") -or ($_.Surname -like  "G*") -or ($_.Surname -like  "H*") -or ($_.Surname -like  "I*") -or ($_.Surname -like  "J*") -or ($_.Surname -like  "K*") -or ($_.Surname -like  "L*") -or ($_.Surname -like  "M*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
####
#### All Y11 Female N-Z
####
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y11-Female-N_Z"
$Filter = "Y11-F"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "N*" -or ($_.Surname -like  "O*") -or ($_.Surname -like  "P*") -or ($_.Surname -like  "Q*")-or ($_.Surname -like  "R*")-or ($_.Surname -like  "S*") -or ($_.Surname -like  "T*") -or ($_.Surname -like  "U*") -or ($_.Surname -like  "V*") -or ($_.Surname -like  "W*") -or ($_.Surname -like  "X*") -or ($_.Surname -like  "Y*") -or ($_.Surname -like  "Z*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."

#### All Y12 Males A-M
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y12-Male-A_M"
$Filter = "Y12-M"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "A*" -or ($_.Surname -like  "B*") -or ($_.Surname -like  "C*") -or ($_.Surname -like  "D*")-or ($_.Surname -like  "E*")-or ($_.Surname -like  "F*") -or ($_.Surname -like  "G*") -or ($_.Surname -like  "H*") -or ($_.Surname -like  "I*") -or ($_.Surname -like  "J*") -or ($_.Surname -like  "K*") -or ($_.Surname -like  "L*") -or ($_.Surname -like  "M*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
#
#### All Y12 Males N-Z
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y12-Male-N_Z"
$Filter = "Y12-M"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "N*" -or ($_.Surname -like  "O*") -or ($_.Surname -like  "P*") -or ($_.Surname -like  "Q*")-or ($_.Surname -like  "R*")-or ($_.Surname -like  "S*") -or ($_.Surname -like  "T*") -or ($_.Surname -like  "U*") -or ($_.Surname -like  "V*") -or ($_.Surname -like  "W*") -or ($_.Surname -like  "X*") -or ($_.Surname -like  "Y*") -or ($_.Surname -like  "Z*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
#
#### All Y12 Female A-M
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y12-Female-A_M"
$Filter = "Y12-F"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "A*" -or ($_.Surname -like  "B*") -or ($_.Surname -like  "C*") -or ($_.Surname -like  "D*")-or ($_.Surname -like  "E*")-or ($_.Surname -like  "F*") -or ($_.Surname -like  "G*") -or ($_.Surname -like  "H*") -or ($_.Surname -like  "I*") -or ($_.Surname -like  "J*") -or ($_.Surname -like  "K*") -or ($_.Surname -like  "L*") -or ($_.Surname -like  "M*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
#
#### All Y12 Female N-Z
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y12-Female-N_Z"
$Filter = "Y12-F"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "N*" -or ($_.Surname -like  "O*") -or ($_.Surname -like  "P*") -or ($_.Surname -like  "Q*")-or ($_.Surname -like  "R*")-or ($_.Surname -like  "S*") -or ($_.Surname -like  "T*") -or ($_.Surname -like  "U*") -or ($_.Surname -like  "V*") -or ($_.Surname -like  "W*") -or ($_.Surname -like  "X*") -or ($_.Surname -like  "Y*") -or ($_.Surname -like  "Z*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*2
Write-host "There are a total of $Count users in $Group... For each student to connect two devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
#
#### All Y13 Male A-M
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y13-Male-A_M"
$Filter = "Y13-M"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "A*" -or ($_.Surname -like  "B*") -or ($_.Surname -like  "C*") -or ($_.Surname -like  "D*")-or ($_.Surname -like  "E*")-or ($_.Surname -like  "F*") -or ($_.Surname -like  "G*") -or ($_.Surname -like  "H*") -or ($_.Surname -like  "I*") -or ($_.Surname -like  "J*") -or ($_.Surname -like  "K*") -or ($_.Surname -like  "L*") -or ($_.Surname -like  "M*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*3
Write-host "There are a total of $Count users in $Group... For each student to connect three devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
#
#### All Y13 Male N-Z
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y13-Male-N_Z"
$Filter = "Y13-M"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "N*" -or ($_.Surname -like  "O*") -or ($_.Surname -like  "P*") -or ($_.Surname -like  "Q*")-or ($_.Surname -like  "R*")-or ($_.Surname -like  "S*") -or ($_.Surname -like  "T*") -or ($_.Surname -like  "U*") -or ($_.Surname -like  "V*") -or ($_.Surname -like  "W*") -or ($_.Surname -like  "X*") -or ($_.Surname -like  "Y*") -or ($_.Surname -like  "Z*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*3
Write-host "There are a total of $Count users in $Group... For each student to connect three devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
#
#### All Y13 females A-M
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y13-Female-A_M"
$Filter = "Y13-F"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "A*" -or ($_.Surname -like  "B*") -or ($_.Surname -like  "C*") -or ($_.Surname -like  "D*")-or ($_.Surname -like  "E*")-or ($_.Surname -like  "F*") -or ($_.Surname -like  "G*") -or ($_.Surname -like  "H*") -or ($_.Surname -like  "I*") -or ($_.Surname -like  "J*") -or ($_.Surname -like  "K*") -or ($_.Surname -like  "L*") -or ($_.Surname -like  "M*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*3
Write-host "There are a total of $Count users in $Group... For each student to connect three devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
#
#### All Y13 females N-Z
$Exclude = "OU=Left,OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz"
$Group = "Y13-Female-N_Z"
$Filter = "Y13-F"
## Clean old group
Get-ADGroupMember $Group | ForEach-Object {Remove-ADGroupMember $Group $_ -Confirm:$false}
## Populate again
Get-ADuser -SearchBase "OU=OU1,OU=OU2,DC=DOMAIN,DC=co,DC=nz" -filter{departmentNumber -like $Filter} | Where-Object { $_.DistinguishedName -notlike "*,$Exclude" } | Where-Object { $_.Surname -like  "N*" -or ($_.Surname -like  "O*") -or ($_.Surname -like  "P*") -or ($_.Surname -like  "Q*")-or ($_.Surname -like  "R*")-or ($_.Surname -like  "S*") -or ($_.Surname -like  "T*") -or ($_.Surname -like  "U*") -or ($_.Surname -like  "V*") -or ($_.Surname -like  "W*") -or ($_.Surname -like  "X*") -or ($_.Surname -like  "Y*") -or ($_.Surname -like  "Z*") } | %{Add-ADGroupMember $Group $_.SamAccountName}
$Count = (Get-ADGroupMember -Identity $Group).count
$DevicesAllowed = $Count*3
Write-host "There are a total of $Count users in $Group... For each student to connect three devices you will need $DevicesAllowed assignable Addresses. A /23 has 512 usable addresses."
#
