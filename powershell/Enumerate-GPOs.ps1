Get-GPO -All | select DisplayName, ID, Description, CreationTime, ModificationTime | Export-Csv C:\Users\YOURSSO\Documents\GPOs.csv -NoTypeInformation
