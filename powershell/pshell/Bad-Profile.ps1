$objUser = New-Object System.Security.Principal.NTAccount(Read-Host -Prompt "Enter Username")
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$fldLoc = "C:\Users\$($strSID.Value)"
#$strSID.Value
Rename-Item -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList\$($strSID.Value)" -NewName "$($strSID.Value).old"
Rename-Item -Path $fldLoc -NewName "$($strSID.Value).old"