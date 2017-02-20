#Compatible -Version 1.0
<#
.SYNOPSIS
  Email users a report on Exchange database sizes
.DESCRIPTION
  This script will get the information of all attached mailbox databases and compile a report for the end user.
  The report is emailed and archived.
   
.PARAMETER <all>
  Fairly self explanitory
.OUTPUTS
  Log file stored in C:\scripts\OutputLogs\Exchange logs
  Email to defined recipiants.
.NOTES
  Version:        1.6
  Author:         Josh Angel
  Credits:        Email section modified from http://ss64.com/ps/syntax-email.html
  Creation Date:  2015
  Last Edit:      21/2/2017
  Purpose/Change: tweeks
   
.EXAMPLE
Server        StorageGroupName     Name             Size (GB) Size (MB) No. Of Mbx
------        ----------------     ----             --------- --------- ----------
Server1       First Storage Group  Staff               186.28 190752.02        487
Server2       First Storage Group S taff2               11.67  11952.39         22
   
#>
#----------------------------------------------------------[Import Exchange module]------------------------------------------------
if(!(Get-PSSnapin |
    Where-Object {$_.name -eq "Microsoft.Exchange.Management.PowerShell.Admin"}))
    {
      Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
    }
#----------------------------------------------------------[Declarations]----------------------------------------------------------
$destination = "C:\scripts\OutputLogs\Exchange logs"
$smtpServer = "exchange.local"
$Daysback = "-90" # 3 Months
#---[Email]---
$dtmToday = ((Get-Date).dateTime).tostring()
$strSubject = "REPORT: Exchange Database Sizes - $dtmToday"   
$strBody = "Attached is the weekly report of Exchange Database sizes.
 
This email was sent by ExchangeDatabaseReport.ps1 running on 'mailsrv."
$strSender = "Device.Monitor@mail.nz"
$strRecipient = "Josh@mail.nz"
$Attachment = $log
#-----------------------------------------------------------[Functions]------------------------------------------------------------   
    
Function DatabaseReport #Generate report on Database Sizes.
{
Get-MailboxDatabase | Select Server, StorageGroupName, Name, @{Name="Size (GB)";Expression={$objitem =
(Get-MailboxDatabase $_.Identity); $path = "`\`\" + $objitem.server + "`\" + $objItem.EdbFilePath.DriveName.Remove(1).ToString() + "$"+ $objItem.EdbFilePath.PathName.Remove(0,2); $size =
 ((Get-ChildItem $path).length)/1048576KB; [math]::round($size, 2)}}, @{Name="Size (MB)";Expression={$objitem =
 (Get-MailboxDatabase $_.Identity); $path = "`\`\" + $objitem.server + "`\" + $objItem.EdbFilePath.DriveName.Remove(1).ToString() + "$"+ $objItem.EdbFilePath.PathName.Remove(0,2); $size =
 ((Get-ChildItem $path).length)/1024KB; [math]::round($size, 2)}}, @{Name="No. Of Mbx";expression={(Get-Mailbox -Database $_.Identity | Measure-Object).Count}} | Format-table -AutoSize | Out-File $log
}
Function Email #($strSubject, $strBody, $strSender, $strRecipient, $AttachFile)
   {
      #$r = ((Get-Content $log) -join "`n" | Format-table -AutoSize)
      $strSMTP = "stcc-exchange"
      
      $MailMessage = New-Object System.Net.Mail.MailMessage
      $SMTPClient = New-Object System.Net.Mail.smtpClient
      $SMTPClient.host = $strSMTP
      
      $MailMessage.Sender = $strSender
      $MailMessage.From = $strSender
      $MailMessage.Subject = "REPORT: Exchange Database Sizes - $dtmToday"
      $MailMessage.To.add($strRecipient)
      $MailMessage.To.add("helpdesk@mail.nz")
      #$MailMessage.IsBodyHTML = $true
      $MailMessage.Body = $strBody
      if ($Attachment -ne $null) {$MailMessage.attachments.add($Attachment) }
      $SMTPClient.Send($MailMessage)
      $MailMessage.Dispose()
   }
Function CreateLog #Move / Archive and datestamp the log file.
{
if (Test-Path $Log) {
Move-Item $Log ("$destination\Exchange Database Report {0:dd-MM-yyyy hh.mm}.log" -f (get-date))
 }
}
Function LogPurge # Delete all logs older than x day(s)
{
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays($Daysback)
Get-ChildItem $destination | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item
}
#-----------------------------------------------------------[Execution]------------------------------------------------------------
[System.IO.Directory]::CreateDirectory("$destination")
$Log = ("$destination\Exchange Database Report.log")
if (Test-Path $Log) {Remove-Item $Log}
DatabaseReport
Email
CreateLog
LogPurge
