<# 

Version 1.0.abcdefg

Developed by : Josh and Conan
 
Change Log

1.0.abcdefg - created inistal script to copy todays date json and over 1meg in size to upload folder
1.1.abcdefg - added zip and email powershell

#>

# Get Todays Date

$date = (Get-date).Day

# Get JSON file where file size is greater than 1 meg and is today's Date and copy to upload folder. Change size as required for your client site. 

Get-ChildItem .\dsdata\*.json | where { $_.Length -gt 1000KB} | Where { $_.LastwriteTime.Day -eq "$date"} | Copy-Item -Destination .\Upload -force

# Execute Teams Export Script

& '.\teamsexport.ps1'

& '.\zip-email.ps1'
