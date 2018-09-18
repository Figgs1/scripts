Set-Service wuauserv -StartupType Disabled
Stop-Service wuauserv
Stop-Service bits
Stop-Service dosvc
Start-Sleep 5
Remove-Item -Recurse -Force C:\Windows\SoftwareDistribution\Download\*
