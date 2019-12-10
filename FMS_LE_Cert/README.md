## Credit

This is a fork of the work started by: [David Nahodyl, Blue Feather](http://bluefeathergroup.com/blog/how-to-use-lets-encrypt-ssl-certificates-with-filemaker-server/)  

Thanks for figuring out the hard part David!

Then forked again fron dansmith65 who made most major changes. This version has been modified for my own personal use at clients using FMS with a particular database.

## Notes

* Only supports newer OS (only tested on Windows Server 2019).
* Only tested on FileMaker Server 18.
* Installs all dependencies for you.

## Installation

1. Open PowerShell console as an Administrator:

   1. Click **Start**
   2. Type **PowerShell**
   3. Right-click on **Windows PowerShell**
   4. Click **Run as administrator**

2. Download the `GetSSL.ps1` file to your server:

   ```powershell
   Invoke-WebRequest `
     -Uri https://raw.githubusercontent.com/JoshTickles/PowerShell/master/FMS_LE_Cert/GetSSL.ps1 `
     -OutFile "C:\Program Files\FileMaker\FileMaker Server\Data\Scripts\GetSSL.ps1"
   ```

3. Install Dependencies:

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force;
   & 'C:\Program Files\FileMaker\FileMaker Server\Data\Scripts\GetSSL.ps1'
   ```

4. Get your first Certificate:  
   You **should** read this file completely (all below) before continuing. If you like to live dangerously and you have FileMaker Server installed in the default directory you can run this command after replacing `fms.example.com` and `user@email.com` with your own.  
   Consider adding the `-Staging` parameter when first configuring this script, so you can verify there are no permissions or config issues before using Let's Encrypt production server, or restarting FileMaker server.

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force;
   & 'C:\Program Files\FileMaker\FileMaker Server\Data\Scripts\GetSSL.ps1' fms.example.school.nz TTS@example.school.nz
   ```

4. (Optional) Setup scheduled task to renew the certificate:  
   Will schedule a task to re-occur every 63 days. You can modify this task after it's created by opening Task Scheduler. If you don't do this step, you will have to run the above command to renew the certificate before it expires every 90 days.  
   Consider configuring [Log File to be Emailed] to you before you running this step.

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force;
   & 'C:\Program Files\FileMaker\FileMaker Server\Data\Scripts\GetSSL.ps1' fms.example.school.nz TTS@example.school.nz -ScheduleTask
   ```

## Authentication

This script will seamlessly and securely manage authentication for you. If external authentication is setup for the user the script is run as to access the Admin Console, then that will be used. If it's not, you will be asked for your Admin Console Sign In when the script runs. These credentials will be stored in Windows Credential Manager; the same place FileMaker Server stores your encryption at rest password. The next time the script runs, it will load the stored credentials from Credential Manager.

I haven't tested this scenario but the credentials can probably only be retrieved by the same user account that created them. If you modify your scheduled task to run as a different user, that might break this feature.

If you want to, external authentication can easily be enabled on a default installation of FileMaker Server and does not require an Active Directory:

1. Log in to FileMaker Server 18 admin console
2. Administration > External Athentication > External Accounts for Admin Console Sign In: click __Change__
3. Add a group name and click __Save Authentication Settings__  
   (default install of Windows should work with "Administrators" as the group name)
4. Admin Console Sign In > External Accounts: __Enable__
5. Confirm it's working by typing this on the command line: `fmsadmin list files`. If you are not asked for a user/pass, then it has be properly enabled.

If external authentication _is_ enabled but you _don't_ want to use it, you can store credentials with this command:
**NOTE - THIS IS STRONGLY DISCOURAGED BY TTS / MYSELF.**

```powershell
Get-Credential | New-StoredCredential -Target "GetSSL FileMaker Server Admin Console" -Persist LocalMachine
```

## Staging

Let's Encrypt service imposes [Rate Limits](https://letsencrypt.org/docs/rate-limits/), which are less restrictive on their staging environment. While developing this script I repeatedly tested with the same domain and quickly hit the limit of 5 identical certificate requests per week. 
While this won't be an issue to most people, I do want to point out that if you are doing testing, you _should_ use the `-Staging` parameter.

Using this parameter is a great way of doing the initial setup/testing as well. It allows you to go through all the steps without worrying about Rate Limits or your server being restarted. Common issues like permissions to call fmsadmin.exe without having to type a user/pass can be resolved before doing a final install. Since the existing certificate is backed up before being replaced, you could always restore to existing configuration, if needed.

## Restoring a Certificate

Before replacing any files in the CStore directory, they are backed up in a sub-folder with the current date/time and no backups are ever overwritten or deleted by this script. If you need to restore a previously installed certificate, you can do it with a command like this:

```powershell
Remove-Item "C:\Program Files\FileMaker\FileMaker Server\CStore\serverKey.pem"
fmsadmin certificate import `
    "C:\Program Files\FileMaker\FileMaker Server\CStore\Backup\2018-10-09_181822\serverCustom.pem" `
    --keyfile "C:\Program Files\FileMaker\FileMaker Server\CStore\Backup\2018-10-09_181822\serverKey.pem" -y
```

_Make sure to use the actual path to the backup you want to restore; this code is an example for a backup taken at the time of writing this documentation._

## Multiple Domains

You can request a certificate for multiple domains at once by separating them with commas:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force;
& 'C:\Program Files\FileMaker\FileMaker Server\Data\Scripts\GetSSL.ps1' example.school.nz, FMS.example.school.nz, KAMAR.example.school.nz user@email.com
```

## Custom Shutdown/Startup

This script must restart the FileMaker Server process to complete the installtion of the certificate. It does it's best to do a safe shutdown and to start the server, CWP (if it was running), and open files (if there were any open before). However, if you want to customize this process, you could edit the script towards the end where it does these steps. A likely example is if you want to give users longer than 30 seconds to close files before the server restarts. To do that, you would add ` -t #` with the number of seconds timeout you want after: `fmsadmin stop server -y`.

Beware that if you have to enter an encryption at rest password when you open files, you will need to manage this process yourself, in this section of the script. NOTE: this only applies if you've configured your server not to store the password.

Alternatively, if you have your own shutdown/startup scripts already, you could call them directly and remove the default steps provided in this script.



## Email Log File

At the very end of the script, there is a little code to email you the log file if the script was run from a scheduled task. To enable this code, you need to edit the SMTP connection info in the script and store your username and password so the script can access them. You can securely store your credentials by running these from PowerShell (which is running as Administrator):

#TODO: rewrite this to mention new parameter option to setup email

```powershell
Get-Credential | New-StoredCredential -Target "GetSSL Send Email" -Persist LocalMachine -UserName "youruser" -Password "yourpass"
```

That's it! Now you can sleep well, knowing you will get an email when the script runs. You might want to add a reminder to your calendar to expect an email when the task runs, so you can be sure to log into the server and view the log, if you don't happen to get an email.
