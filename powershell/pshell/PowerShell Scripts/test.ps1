#
# PowerShell to remove .tmp files from user profile first
# Remove .tmp files from system.
# Remove Items from temp directories
#
Param (
	[Parameter(Mandatory = $true)]
	[string]$ComputerName,
	[string]$Path = ("C:\"),
	[switch]$Recurse
)
cls
$Result = @()
Write-Host "We are removing temp files please wait...."
$Files = Get-ChildItem -Path -Recurse
If ($File)
{ Write-Host "Processing Files...."
	ForEach ($File in $Files )
	{
		If(!_.PSIsContainer and $_.Extension -contains "$_.tmp")
		{
			Remove-Item -Force
		}
		Else
		{Continue}
	}
	#puts it into a text files to parse and see whats removed
	$Result += New-Object PSObject -Property @(
		Add-Content -Path "C:\Windows\Logs\ItemsRemove.txt" -Value ("{0}: {1}" -f $_.FullName, $_.length)
	)
}