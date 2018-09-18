"" ; ""

Write-Output "Cybersecurity Operations Phishing Cleanup Tool - Block O365 User"

""

Sleep -Seconds 2

#Read username into script
$username = 'username@domain.onmicrosoft.com'

#Read password into script
$password = get-content .\2.txt | convertto-securestring

$email = read-host "Enter the email address of the compromised user"

""

$UserCredential = new-object -typename System.Management.Automation.PSCredential -argumentlist $username,$password

Write-Output "Connecting to the O365 tenant..."

""

Connect-MsolService -Credential $UserCredential

Write-Output "Blocking compromised user..."

""

Set-MsolUser -UserPrincipalName $email -BlockCredential $true

Write-Output "The script will now query the account to confirm it is blocked"

Sleep -Seconds 2

""

Get-MsolUser -UserPrincipalName $email | Select DisplayName,BlockCredential

Sleep -Seconds 5
