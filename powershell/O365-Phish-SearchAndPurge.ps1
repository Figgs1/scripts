Org  #1.  First, we need to connect to the O365 Security and Compliance Remote PS endpoint using the LogRhythm-Pie account.  Do so by entering each line below, one at a time
$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid -Credential $UserCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session -AllowClobber -DisableNameChecking

$Host.UI.RawUI.WindowTitle = $UserCredential.UserName + " (Office 365 Security & Compliance Center)"

  #2.  This query runs leverages the Office365 Security and Compliance Remote PowerShell connection to query our email environment
New-ComplianceSearch -Name “Org-Phish1” -ExchangeLocation all -ContentMatchQuery ‘subject:"Adding IP Addresses to the Palo Alto Block Rule"’

            #Note:  If the name already exists, you will first need to purge the original using the query below
          Remove-ComplianceSearch -Identity "Org-Phish" -Confirm:$false

  #Another Example
  New-ComplianceSearch -Name “Org-Phish” -ExchangeLocation all -ContentMatchQuery 'sent>=01/01/2018 AND sent<=01/30/2018 AND subject:"Docusign" AND from:"betty.smith@domain.com" AND hasattachment:true'


            #This parameter will return all email from the specified user
          from:john.smith@domain.com

            # This parameter will return all email sent from specified user, only if they have an attachment (be mindful that some signature blocks arrive as attachments)
          from:john.smith@domain.com AND hasattachment:true

            # Participants parameter will include all senders or recipients from domain.com.  Can also specify a single user or DL
          participants:domain.com

            #The Subject parameter allows you to specify part or all of the subject in the query string
          subject:"Quarterly Financials"

  #3.  This query starts running the compliance search that was defined in the previous step
Start-ComplianceSearch -Identity "Org-Phish1" -Force -Confirm:$false

        <#PRO TIP:  If you know the exact text or phrase used in the subject line of the message, use the Subject property in the search query.

        If you know that exact date (or date range) of the message, include the Received property in the search query

        If you know who sent the message, include the From property in the search query

        Preview the search results to verify that the search returned only the message (or messages) that you want to delete

        Use the search estimate statistics (displayed in the details pane of the search in the Security & Compliance Center or by using the Get-ComplianceSearch cmdlet) to get a count of the total number of results
        #>

  #4.  This script will return the number of mailboxes included in the search executed above.  This process has a cap on the number of returned mailboxes that match the query of 500. Cut the search into smaller sections if the query exceeds 500 mailboxes.
SourceMailboxes.ps1 (Create and run this interactive script)

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$SearchName
)

$search = Get-ComplianceSearch $SearchName
if ($search.Status -ne "Completed")
{
                "Please wait until the search finishes.";
                break;
}

$results = $search.SuccessResults;
if (($search.Items -le 0) -or ([string]::IsNullOrWhiteSpace($results)))
{
                "The compliance search " + $SearchName + " didn't return any useful results.";
                break;
}

$mailboxes = @();
$lines = $results -split '[\r\n]+';
foreach ($line in $lines)
{
    if ($line -match 'Location: (\S+),.+Item count: (\d+)' -and $matches[2] -gt 0)
    {
        $mailboxes += $matches[1];
    }
}

"Number of mailboxes that have search hits: " + $mailboxes.Count

  #5.  This query allows you to view the results before performing any purge commands
Get-ComplianceSearch -Identity "Org-Phish1" -ResultSize Unlimited | Format-List

  #6.  This query will take the results from the compliance search performed and move all email found into deleted items
New-ComplianceSearchAction -SearchName "Org-Phish1" -Purge -PurgeType SoftDelete
