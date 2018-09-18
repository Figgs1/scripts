--------------------------------
# Bulk Add Computers to a group

# Variables
    $ComputerList = Get-Content "Text File Path and Name of File with Computer Names inside of it"
    $GroupName = "Group Name"
    $Members = (Get-ADGroupMember -Identity $GroupName).Name


# Process to check if already exists and add if not
    ForEach ($Computer in $ComputerList){

        If ($Members -contains $Computer){

            Write-Output "$Computer is already a member of $GroupName"
            }

        Else{
            Write-Output "$Computer is not a member. Attempting to add now. Rerun script again for verification"
            Add-ADGroupMember -identity "$GroupName" -Members "$Computer$"
            }
    }
