Import-Module ActiveDirectory

$Users = Import-Csv -Path C:\Scripts\CSV\NewHires.csv      
foreach ($User in $Users)            
{            
    $SAM = $User.Username 
    $Email = $User.Email
         
    Set-ADUser -Identity (Get-ADUser $SAM) -Clear proxyAddresses
       
    Set-ADUser -Identity (Get-ADUser $SAM) -Add @{proxyAddresses = ('SMTP:' + $Email)}
}