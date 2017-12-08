Import-Module ActiveDirectory

$Users = Import-Csv -Path C:\Scripts\CSV\ADM040317.csv
foreach ($User in $Users)            
{            
    $SAM = $User.Username
    $Phone = $User.Phone                                  
    
    Set-ADUser $SAM -OfficePhone $Phone
}