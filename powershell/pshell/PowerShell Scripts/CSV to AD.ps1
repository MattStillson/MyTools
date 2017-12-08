Import-Module ActiveDirectory
$PathCSV = (Read-Host "Please give me the path to the file")
Import-Csv $PathCSV | Foreach-Object {
        New-AdUser
        -Name $_.Username `
        -GivenName $_.Firstname `
        -Surname $_.LastName `
        -SamAccountName $_.Username `
        -UserPrincipalName ($_.Username + "@conversionpt.com") `
        -Path 'OU=Sample,DC=demo,DC=local' `
        -Title $_.Title `
        -EmailAddress $_.E-mail `
        -OfficePhone $_.Telephone `
        -AccountPassword (ConvertTo-SecureString $_.Password -AsPlainText -force) `
        -ChangePasswordAtLogon $true `
        -Enabled $true `
}
