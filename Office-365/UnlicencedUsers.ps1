#requires -version 2
<#
.SYNOPSIS
  Script to finds unlicensed user accounts in Office 365 and apply a defined license.
.DESCRIPTION
  This script will query the Office 365 user database and find unlicensed users. Once the users are found a CSV is generated
  and emailed to the defined email address. The script then applies your defined Office 365 license to the users.
.PARAMETER <Destination>
    Desired store of generated logs.
.PARAMETER <AccountSkuId>
    License to apply to users.
.PARAMETER <LicenseOptions>
    Allows defined license options.
.PARAMETER <SMTP>
    Your SMTP server address.
.OUTPUTS
  Log file stored in C:\Scripts\OutputData\Server Diskspace {0:dd-MM-yyyy hh.mm}.log>
.NOTES
  Version:        1.0
  Author:         Josh Angel
  Creation Date:  2014
  Last Edit:      18/09/2015
  Purpose/Change: Creation of synopsis.
   
.EXAMPLE
  "This email was sent by XXXXXX.ps1 running on XXXXXX server. 09/18/2015 12:00:00
The following account(s) have had the 'OFFICE365_LICENSE' licence applied:
*
user@domain.com
 
"
#>
#----------------------------------------------------------[Declarations]----------------------------------------------------------
#General
$Destination = "C:\Scripts\UnlicencedUsers\Output"
$CSV = ("$Destination\UnlicencedUsers {0:dd-MM-yyyy hh.mm}.csv" -f (get-date))
[System.IO.Directory]::CreateDirectory($Destination)
$CurrentDate = Get-Date
$dtmToday = ((Get-Date).dateTime).tostring()
#365 data
$User = "admin@domain.com"
$Pass = "Password"
$Cred = New-Object System.Management.Automation.PsCredential($User, (ConvertTo-SecureString $Pass -AsPlainText -Force))
$AccountSkuId = "DOMAIN:LICENCE"
#$LicenseOptions = New-MsolLicenseOptions -AccountSkuId $AccountSkuId
$Location = "NZ"
#Email stuff
$Sender = "NoReply@doamin.com"
$Recipient = "user1@domain.com"
$Subject = "REPORT: Office365 unlicensed users - $dtmToday"
$SMTP = "YourSMTP-Server"
$Att = $CSV
#-----------------------------------------------------------[Functions]------------------------------------------------------------
Function GetUsers {
Get-MsolUser -All | Where-Object {$_.IsLicensed -like "false" -and $_.UserPrincipalName -like "[1234]*@yourDomain.com"}|
Select-Object UserPrincipalName | Export-Csv $CSV
}
# For students > "[3]*"
Function Email {
$Data = Import-CSV $CSV | ConvertTo-Html
$emailBody = @"
<basefont face="Calibri">
This email was sent by <font color="#3CB371">UnlicensedStudents.ps1</font> running on <font color="#4169E1">YourServer/font> server. $CurrentDate
<br>
<br>
The following account(s) have had the 'XXXXXX XXXXX' licence applied:
<br>
$Data
<br>
"@
 $MailMessage = New-Object System.Net.Mail.MailMessage
      $SMTPClient = New-Object System.Net.Mail.smtpClient
      $SMTPClient.host = $SMTP
       
      $MailMessage.Sender = $Sender
      $MailMessage.From = $Sender
      $MailMessage.Subject = $Subject
      $MailMessage.To.add($Recipient)
      $MailMessage.IsBodyHTML = $true
      $MailMessage.Body = $emailBody
      if ($Att -ne $null) {$MailMessage.attachments.add($Att) }
      $SMTPClient.Send($MailMessage)
      $MailMessage.Dispose()
      }
Function SetLicense{
$UnlicensedList = (Import-CSV $CSV)
Write-Host "
Applying licenses to the following users:"
$UnlicensedList
foreach ($user in $UnlicensedList){
  Set-MsolUser `
    -UserPrincipalName $user.UserPrincipalName -UsageLocation $Location
  Set-MsolUserLicense `
    -UserPrincipalName $user.UserPrincipalName -AddLicenses $AccountSkuId 
  <#Set-MsolUserLicense `
    -UserPrincipalName $user.UserPrincipalName -LicenseOptions $LicenseOptions #>
    }
}
#-----------------------------------------------------------[Execution]------------------------------------------------------------
Import-Module MSOnline
Connect-MsolService -Credential $Cred
# Run Functions
GetUsers
SetLicense
Email
# End
 
# Use the following to check if licence application is working
#(Get-MsolUser -UserPrincipalName "user@domain.com").Licenses.ServiceStatus
