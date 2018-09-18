<span style="color: #008000">#write the files to be deleted to a text log</span>
  where { $_ <span style="color: #cc6633">-is</span> [System.IO.FileInfo] } |
  AttachMD5 |
  group-object Length,MD5 |
  where { $_.Count <span style="color: #cc6633">-gt</span> 1 }|<span style="color: #0000ff">foreach</span>{$_.Group -join <span style="color: #006080">","</span>} &gt; some_file.txt &nbsp;
<span style="color: #008000">#Delete the duplicate files (but keep 1 of each unique file) </span>
Get-Content some_file.txt|<span style="color: #0000ff">foreach</span>{remove-item ($_.split(<span style="color: #006080">","</span>)[1..($_.split(<span style="color: #006080">","</span>)).count])-whatif}

<#Instructions for use:

Change the file path to the directory where the files from which you would like to remove duplicates are located. (it’s i:\music in this sample)
Remove –whatif in the last line of the script if you want to actually delete the duplicates (remember 1 copy of each unique file will be saved)
You run this against a target directory with duplicate files and it will get the duplicates out. #>

<span style="color: #008000">## BEGIN SAMPLE SCRIPT</span>
<span style="color: #008000">#This function retrieves the MD5 hash for a file</span>
  <span style="color: #0000ff">function</span> Get-MD5([System.IO.FileInfo] $file = $(Throw <span style="color: #006080">'Usage: Get-MD5 [System.IO.FileInfo]'</span>))
{
  $stream = $null;
  $cryptoServiceProvider = [System.Security.Cryptography.MD5CryptoServiceProvider];
  $hashAlgorithm = new-object $cryptoServiceProvider
  $stream = $file.OpenRead();
  $hashByteArray = $hashAlgorithm.ComputeHash($stream);
  $stream.Close();
  <span style="color: #008000">## We have to be sure that we close the file stream if any exceptions are thrown.</span>
  <span style="color: #0000ff">trap</span>
  {
    <span style="color: #0000ff">if</span> ($stream <span style="color: #cc6633">-ne</span> $null)
    {
      $stream.Close();
    }
    <span style="color: #0000ff">break</span>;
  }
  <span style="color: #0000ff">return</span> [string]$hashByteArray;
}
<span style="color: #008000"># This filter calls the Get-MD5 hash function to retrieve the files MD5 hash, </span>
<span style="color: #008000"># then uses the AddNote function to add the hash as a note </span>
<span style="color: #008000"># called 'MD5' and finally it will return the object.</span>
<span style="color: #0000ff">filter</span> AttachMD5
{
  $md5hash = Get-MD5 $_;
  <span style="color: #0000ff">return</span> ($_ | AddNote MD5 $md5Hash);
}
<span style="color: #008000">## Adds a note to the pipeline input.</span>
<span style="color: #0000ff">filter</span> AddNote([string] $name, $value)
{
$mshObj = [System.Management.Automation.psObject] $_;
$note = new-object System.Management.AUtomation.psNoteProperty $name, $value
$mshObj.psObject.Members.Add($note);
<span style="color: #0000ff">return</span> $mshObj
}
<span style="color: #008000"># Group the files where number of files with matching hash &gt; 1. </span>
<span style="color: #008000"># These are probable duplicates. Note the path to the files is hard coded here. </span>
Get-ChildItem o:\music\temp\*.* |
&nbsp;
<span style="color: #008000">#write the files to be deleted to a text log</span>
  where { $_ <span style="color: #cc6633">-is</span> [System.IO.FileInfo] } |
  AttachMD5 |
  group-object Length,MD5 |
  where { $_.Count <span style="color: #cc6633">-gt</span> 1 }|<span style="color: #0000ff">foreach</span>{$_.Group -join <span style="color: #006080">","</span>} &gt; some_file.txt
&nbsp;
<span style="color: #008000">#Delete the files </span>
Get-Content some_file.txt|<span style="color: #0000ff">foreach</span>{remove-item ($_.split(<span style="color: #006080">","</span>)[1..($_.split(<span style="color: #006080">","</span>)).count])-whatif}
&nbsp;
## END SAMPLE SCRIPT
