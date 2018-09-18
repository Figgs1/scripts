""; ""
Write-Output "***** Cybersecurity Operations Phishing Cleanup Tool *****"
""
Sleep -Seconds 4

#Read username into script
$username = 'username@domain.onmicrosoft.com'

#Read password into script
$password = get-content .\2.txt | convertto-securestring

#Additional Variables
$startrange = get-date (get-date).AddDays(-1).ToString("MM-dd-yyyy") -Format MM-dd-yyyy
$endrange = get-date (get-date).AddDays(+1).ToString("MM-dd-yyyy") -Format MM-dd-yyyy
$email = read-host "Enter the email address of the compromised user "
""

Write-Output "Connecting to the O365 Remote PowerShell URI..."

$UserCredential = new-object -typename System.Management.Automation.PSCredential -argumentlist $username,$password

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid -Credential $UserCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session

""

Write-Output "Now checking for SharePoint or OneDrive file access for compromised user's account..."

Start-Sleep -s 3

#Check for any OneDrive or SharePoint file access from compromised account
  Search-UnifiedAuditLog -StartDate $startrange -EndDate $endrange -UserIds $email -
       recordtype SharePointFileOperation -resultsize 5000 |
       select-object -expandproperty AuditData | ConvertFrom-Json | select-object CreationTime,WorkLoad,ClientIP |
        foreach {
                  new-object psobject -Property @{
                                       Date = $_.CreationTime
                                       IPAddress    = $_.ClientIP
                                       O365_SVC   = $_.WorkLoad
                                       }
                 } | Select Date,IPAddress,O365_SVC | Export-csv c:\working\o365-file-audit.csv -NoTypeInformation

Start-Sleep -s 5

#Check for inbox rules maliciously created to either forward or redirect email
  Get-InboxRule -Mailbox $email | fl name,forwardTo,forwardAsAttchmentTo,redirectTo | Export-csv c:\working\outlook-rule-audit.csv -NoTypeInformation

Write-Output "This task has been completed"

pause
