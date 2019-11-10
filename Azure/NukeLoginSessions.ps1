#####
#
# Repeatable one liner to nuke a users current login state on all devices world wide. 
#
#####

Get-AzureADuser -SearchString user1@Domain.nz | Revoke-AzureADUserAllRefreshToken
Get-AzureADuser -SearchString user2@Domain.nz | Revoke-AzureADUserAllRefreshToken
Get-AzureADuser -SearchString user3@Domain.nz | Revoke-AzureADUserAllRefreshToken
Get-AzureADuser -SearchString user4@Domain.nz | Revoke-AzureADUserAllRefreshToken


## Easily loopable or to concat with spreadsheets. 
## Very useful for breached accounts. 
