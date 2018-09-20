<#
.NAME
 Zabbix Agent Install.

.SYNOPSIS
 Installs Zabbix Agent Service and starts it.

.Descripton
 Checks if the service exists and whether it's in a "Stopped" state. If it exists and is stopped it will start the service, otherwise it will copy
 the Zabbix Agent folder (with the Agent and Config) to the "C:\" drive it will then create a new Service and start the service.

.Remarks
 This can then be deployed via GPO or other means.
 This coupled with a discovery rule in the Zabbix app will set the host up.

 Ensure that you have set the configuration file correctly for your Zabbix setup BEFORE deploying.

#>

# User defined variables.

$SourceFolder = "\\SHARE\softwaredeployment$\Zabbix"
$TargetFolder = "C:\"

# Check if Zabbix Agent is installed and running, if not start the service.
If (get-service -Name "Zabbix Agent" -ErrorAction SilentlyContinue | Where-Object -Property Status -eq "Running")
{
    Exit
}
Elseif (get-service -Name "Zabbix Agent" -ErrorAction SilentlyContinue | Where-Object -Property Status -eq "Stopped")
{
    # Starts service if it exists in a Stopped state.
    Start-Service "Zabbix Agent"
    Exit
}

# Copy Zabbix Agent folder, Create new service, then start service.
Copy-Item -Recurse -Path $SourceFolder -Destination $TargetFolder -ErrorAction SilentlyContinue
New-Service -Name "Zabbix Agent" -BinaryPathName "C:\Zabbix\bin\win64\zabbix_Agentd.exe --config C:\Zabbix\conf\zabbix_Agentd.win.conf" -DisplayName "Zabbix Agent" -Description "Provides system monitoring" -StartupType "Automatic" -ErrorAction SilentlyContinue
(Get-WmiObject win32_service -Filter "name='Zabbix Agent'").StartService()

# End of Script
