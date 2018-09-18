Get-ADGroup -Filter { Name -like "UNV_SAPM_*" }  | Get-ADGroupMember  -Recursive | Get-ADUser -Properties Mail | Select-Object Mail | Out-File -filepath .\email_list.txt
