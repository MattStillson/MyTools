Import-Module ActiveDirectory

$Users = Import-Csv -Path C:\Scripts\CSV\12345.csv
foreach ($User in $Users)
{
    $SAM = $User.Username
    Get-ADUser -Identity $SAM -Properties * | Select -Property DisplayName,Description,Enabled
}