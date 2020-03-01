<# 

Version 1.1.abcdefg

Developed by : Josh and Conan
 
Change Log

1.0.abcdefg - created inistal script to zip and email output to user
1.1 abcdefg - remove file after run

#>

$LogSource = ".\Upload"
$ZipFileName = "sds-export.zip"

$CreateZip = Compress-Archive -Update -Path $LogSource\*.* -DestinationPath .\$ZipFileName

Send-MailMessage -From 'SDS Export <sds-export@domain.com>' -To 'Josh <josh@domain.com>' -Subject 'SDS Export' -Body "Daily SDS Export From Kamar" -Attachments .\sds-export.zip -Priority High -DeliveryNotificationOption OnSuccess, OnFailure -SmtpServer 'relay.domain.com'

Remove-Item .\sds-export.zip
