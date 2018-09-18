$lastLogon = (Get-Date).AddDays(-30)
Get-ADComputer -Filter {operatingsystem -like "*windows*" -and lastlogondate -gt $lastLogon} | select -ExpandProperty Name  | Out-File .\pclist.txt
Get-Content .\pclist.txt | foreach {get-service $avservice -computername $_} | Format-Table Machinename, Name, Status -Autosize | Out-File .\Service_Status.txt
del .\pclist.txt
