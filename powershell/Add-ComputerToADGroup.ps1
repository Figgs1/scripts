# Variables

    $UserList = Get-Content "C:\Users\<username>\Desktop\ComputerNames.txt"

    $GroupName = "UNV_SC_IT_ALL"

    $Members = Get-ADGroupMember -Identity $GroupName | Select -Expand memberof



# Process to check if already exists and add if not

    ForEach ($User in $UserList){



        If ($Members -contains $User){



            Write-Host "$User is member of $GroupName"

            }



        Else{

            Write-Host "$User is not a member. Attempting to add now. Rerun script again for verification"

            Add-ADGroupMember -identity "$GroupName" -Members "$User$"

            }

    }
