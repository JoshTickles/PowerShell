# Josh A - 2018
# This will grab all your o365 groups by your identity filter of choice, then check if they are hidden in GAL. If they are 
# not hidden, then the script will add the hidden ($true) flag.
# --- Comment out line 39 to test. 
#
# Last update 7/6/2018
#
#--------------- Variables
$User = "user@doamin.nz" # An Office365 admin
$Pass = "1234"                # Password (**** bleh, user get-credential instead here and save it to a variable.)
$Path = "C:\Temp\GroupsToHide.csv"        # Export location for CSV report
$ID = "* Department Team"                 # Your search term for getting groups
$Cred = New-Object System.Management.Automation.PsCredential($User, (ConvertTo-SecureString $Pass -AsPlainText -Force))

#--------------- Create / Import Office Powershell sesison
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Cred -Authentication Basic -AllowRedirection
Import-PSSession $session

#--------------- Start
$Groups = Get-UnifiedGroup -ResultSize Unlimited -Identity $ID | Select DisplayName, Alias, PrimarySmtpAddress, HiddenFromExchangeClientsEnabled
Write-Host "Processing" $Groups.Count "groups"
$Report = @()
$TeamsGroups = 0
ForEach ($G in $Groups) {
   Write-Host "Processing" $G.DisplayName 
   If ($G.HiddenFromExchangeClientsEnabled -eq $False) { # Used to be HiddenFromExchangeClients
         $TeamsGroups++ 
         $ReportLine = [PSCustomObject][Ordered]@{
            GroupName = $G.DisplayName}
          $Report += $ReportLine }
    }
#--------------- Display section + Action.
Write-Host $TeamsGroups "groups need to be hidden from Exchange Clients"
Sleep 2
If ($TeamsGroups -ne 0){
    $Report | Export-csv -Path $Path
    ForEach ($r in $Report) {
        Write-Host "Hiding" $r.GroupName "from Exchange Clients"
        Set-UnifiedGroup -Identity $r.GroupName -HiddenFromExchangeClientsEnabled:$true }
        }
