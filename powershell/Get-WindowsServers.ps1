Get-ADComputer -Filter 'OperatingSystem -like "Windows Server*"' -Property * | Format-Table Name,OperatingSystem,Operating
SystemServicePack -Wrap -Auto | Export-CSV AllWinServers.csv -NoTypeInformation -Encoding UTF8
