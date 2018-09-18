""
Write-output "This script will configure your PowerShell profile for ONLY your username, across all local PS hosts"
Sleep -Seconds 2
$psprofile = @'
Set-ExecutionPolicy bypass -Scope CurrentUser
$Host.UI.RawUI.BackgroundColor = 'Black'
$Host.UI.RawUI.ForegroundColor = 'Green'
$Host.PrivateData.ErrorForegroundColor = 'Red'
$Host.PrivateData.ErrorBackgroundColor = 'Black'
$Host.PrivateData.WarningForegroundColor = 'Magenta'
$Host.PrivateData.WarningBackgroundColor = 'Black'
$Host.PrivateData.DebugForegroundColor = 'Yellow'
$Host.PrivateData.DebugBackgroundColor = 'Black'
$Host.PrivateData.VerboseForegroundColor = 'White'
$Host.PrivateData.VerboseBackgroundColor = 'Black'
$Host.PrivateData.ProgressForegroundColor = 'Cyan'
$Host.PrivateData.ProgressBackgroundColor = 'Black'
$Host.UI.RawUI.WindowTitle = "Securing All The Things"
set-location c:\working
Set-Alias tc Test-Connection
Set-Alias p Ping
Set-Alias np c:\windows\notepad.exe
Install-Module MSOnline
 $autodir=::"\\UNC\PATH"
 Get-ChildItem "${autodir}\*.ps1" | ForEach-Object {.$_}
 $output = "Scripts in " + $autodir  + " loaded"
 Write-Host $output
Sleep -Seconds 5
Clear-Host
'@
$psprofile | Out-File -FilePath $Profile.CurrentUserAllHosts -Encoding UTF8
Sleep -Seconds 1
""
Write-output "Your profile has successfully been reconfigured, but PS will need to close and reopen for changes to take effect."
Sleep -Seconds 5
Get-Process powershell* | % { $_.CloseMainWindow() }
