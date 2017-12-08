Import-Module ActiveDirectory
$PersonChanging = 'name1'
$Mirror = 'name2'

#Change username to user that is changing!!!
Get-ADPrincipalGroupMembership -Identity $PersonChanging | where {$_.Name -notlike "Domain Users"} |% {Remove-ADPrincipalGroupMembership -Identity $PersonChanging  -MemberOf $_ -Confirm:$false}
#Change 1st username to mirror and 2nd to user that is changing!!!
Get-ADUser -identity $Mirror -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -members $PersonChanging