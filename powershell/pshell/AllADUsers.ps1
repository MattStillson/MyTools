$jobs =
Start-Job -ScritBlock {
Job1{
Get-ADUser -SearchBase "OU=Users,OU=MLK,OU=Online,OU=UMA,DC=contoso,DC=LOCAL" -filter * -Properties * |
Select -Property DisplayName,GivenName,Surname,
Enabled,EmailAddress,UserPrincipalName,Description,HomePhone,MobilePhone,OfficePhone,Created,
Modified,LastLogonDate,PasswordLastSet,LastBadPasswordAttempt,ObjectClass,SamAccountName,PostalCode,
AllowReversiblePasswordEncryption,CannotChangePassword,LogonWorkstations,PasswordExpired,PasswordNeverExpires,
PasswordNotRequired,ProtectedFromAccidentalDeletion,ScriptPath,SmartcardLogonRequired,Country,State,City,StreetAddress,
Office,Organization,Company,Department,Title,Manager,EmployeeID,HomeDirectory,HomedirRequired,HomeDrive,LockedOut,ProfilePath,CanonicalName |
Export-Csv C:\Scripts\BookADMLK.csv}

Job2{
Get-ADUser -SearchBase "OU=Users,OU=Tampa,OU=Online,OU=UMA,DC=contoso,DC=LOCAL" -filter * -Properties * |
Select -Property DisplayName,GivenName,Surname,
Enabled,EmailAddress,UserPrincipalName,Description,HomePhone,MobilePhone,OfficePhone,Created,
Modified,LastLogonDate,PasswordLastSet,LastBadPasswordAttempt,ObjectClass,SamAccountName,PostalCode,
AllowReversiblePasswordEncryption,CannotChangePassword,LogonWorkstations,PasswordExpired,PasswordNeverExpires,
PasswordNotRequired,ProtectedFromAccidentalDeletion,ScriptPath,SmartcardLogonRequired,Country,State,City,StreetAddress,
Office,Organization,Company,Department,Title,Manager,EmployeeID,HomeDirectory,HomedirRequired,HomeDrive,LockedOut,ProfilePath,CanonicalName |
Export-Csv C:\Scripts\BookADNFL.csv}}
$jobs | Wait-Job | Export-Csv C:\Scripts\bookTest.csv