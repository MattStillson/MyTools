$Users = Import-Csv -Path C:\Scripts\NewUser_AD.csv
foreach ($User in $Users){
    $OU = $User.Path
    $Displayname = $User.Firstname + ' ' + $User.Lastname
    $UserFirstname = $User.FirstName
    $UserLastname = $User.LastName
    $SAM = $User.Username
    $UPN = $SAM + '@contoso.com'
    $Password = $User.Password
    $EmailAddress = $User.Email
    $Description = 'Hired ' + $User.StartDate
    $City = $User.City
    $State = $User.State
    $Office = $User.Campus
    $Title = $User.Title
    $Department = $User.Department
    $HomeDrive = "X:\"
    $UserRoot = "\\networkfileshare\profilelocation\users\"
    $HomeDirectory = $UserRoot + $SAM
    $Address = "SMTP:" + $SAM + "contoso.com"
    $Mirror = $User.Template

    New-ADUser -Path $OU -SamAccountName $SAM  -Name $Displayname -DisplayName $Displayname -GivenName $UserFirstname -Surname $UserLastname -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -force) -Enabled $true -ChangePasswordAtLogon $true -PasswordNeverExpires $false -EmailAddress $EmailAddress -Description $Description -UserPrincipalName $UPN -City $City -State $State -Office $Office -Title $Title -Department $Department
    Set-ADUser -Identity $SAM -HomeDirectory $HomeDirectory -HomeDrive $HomeDrive -Add @{proxyAddresses = ('SMTP:' + $EmailAddress)}
    Get-ADUser -Identity $Mirror -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -members $SAM
}
