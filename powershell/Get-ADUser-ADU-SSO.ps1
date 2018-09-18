$hash_lastLogonTimestamp = @{Name="LastLogonTimeStamp";Expression={([datetime]::FromFileTime($_.LastLogonTimeStamp))}}
$hash_pwdLastSet = @{Name="pwdLastSet";Expression={([datetime]::FromFileTime($_.pwdLastSet))}}

Get-ADUser -Filter { enabled -eq $true -and (Name -like "a*" -or Name -like "d*" -or Name -like "u*") } -Properties Name,lastlogontimestamp,pwdLastSet | Select-Object Name,$hash_lastLogonTimestamp,$hash_pwdLastSet |  Export-csv c:\adu-ssos.csv -NoTypeInformation
