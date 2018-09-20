#####
#  Users at Risk report - Azure API
# 
#   This script will pull the last X (definable) days of reports for users at risk, or risky signins. 
#   Normally this is only avalible via Azure GUI however this script will use custom app API credentials to pull 
#   the report from the Azure graph API service. https://graph.microsoft.com
#  
#  Usage --
#   1. Create a new Custom App Registration, as a Web app /API, in Azure and provide it with "Microsoft Graph" API permissions.
#   2. Fill out the variables with your app credentials and any other changes you wish.
#   3. Run or schedule the script!
#
#
#   Credits - Josh A, Conan B.
#   Last edit - Sept 2018
#####

#------- Variables - Change as required.
$date = Get-Date -format "yyyy-MMM-dd"
$csvFileName = "C:\Reporting\Users-At-Risk-$date.csv"                # Location to save reports
$ClientID       = ""                                                 # Should be a ~35 character Application ID 
$ClientSecret   = ""                                                 # Should be a ~44 character Application Password Key 
$tenantdomain   = "Domain.com"                                       # Your o365 / Azure Domain
#----------- EMAIL settings
$From = "AzureReports@Domain.com"
$To = "alerts@Domain.com"
$Cc = "user@Domain.com"
$Attachment = $csvFileName
$Subject = "Users At Risk - $date (7 days)"
$Body = "Report sent from Your server here."
$SMTPServer = "relay.domain.com"
$SMTPPort = "25"

# --- Don't change below this line -------------------- #
$loginURL       = "https://login.microsoft.com"
$resource       = "https://graph.microsoft.com"
$body       = @{grant_type="client_credentials";resource=$resource;client_id=$ClientID;client_secret=$ClientSecret}
$oauth      = Invoke-RestMethod -Method Post -Uri $loginURL/$tenantdomain/oauth2/token?api-version=1.0 -Body $body
$datechange = (Get-Date).AddDays(-7) | Get-Date -Format O  # Change if you wish to have longer thant 7 days of entries. 
$compare = $datechange.Substring(0.16)

#----------- Start 
Write-Output $oauth

if ($oauth.access_token -ne $null) 
{
    $headerParams = @{'Authorization'="$($oauth.token_type) $($oauth.access_token)"}
    $url = "https://graph.microsoft.com/beta/identityRiskEvents"
    Write-Output $url
    $myReport = (Invoke-WebRequest -UseBasicParsing -Headers $headerParams -Uri $url)
    $output = foreach ($event in ($myReport.Content | ConvertFrom-Json).value) 
    {
     Write-Output $event | Select-Object riskEventDateTime, userPrincipalName, riskEventType, riskLevel, ipAddress 
    }   
    $output | Sort-Object riskEventDateTime | Where-Object {($_.riskEventDateTime -ge $compare)} | Export-csv -Path $csvFileName -NoTypeInformation 
    Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -Attachments $Attachment
} 
else {
    Write-Host "ERROR: No Access Token - Are your app permissions set correctly?"
     } 

#------------- End
