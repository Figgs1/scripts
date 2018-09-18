cls
$myArray = @()
$list = Get-Content C:\sapm_groups.txt
foreach ($group_name in $list)
{
$adgroup = Get-ADGroupMember  -Recursive -identity $group_name | Get-ADUser -Properties Mail | Select-Object Mail
	foreach ($property in $adgroup)
	{
		$myArray += $property.mail
	}
}
Set-Content -Path c:\email_list_result.txt -Value $myArray