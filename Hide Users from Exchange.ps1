<#
    .SYNOPSIS
        Hide users  mail address from Exchange address book. 
    .DESCRIPTION
        Hide users mail address from global Exchange address book. Super hand for users that have left your org. 
    .PARAMETER
    $UsersToDisable = Your OU of choice.
    .INPUTS
    .OUTPUTS
    .EXAMPLE
    .NOTES
        NAME:  UsersHaveLeft-HideFromExchange.ps1
        AUTHOR: Josh Angel
        LASTEDIT: 29/30/2015
        KEYWORDS:
    .LINK
#>
if(!(Get-PSSnapin |
    Where-Object {$_.name -eq "Microsoft.Exchange.Management.PowerShell.Admin"}))
    {
      Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
    }
     
$UsersToDisable = @(Get-Mailbox -OrganizationalUnit "UsersHaveLeft")
ForEach ($User in  $UsersToDisable)
{
Set-Mailbox  -HiddenFromAddressListsEnabled $True -Identity $User.samaccountname
}
