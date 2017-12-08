Import-Module ActiveDirectory

#Change username!!!
Get-ADPrincipalGroupMembership -Identity 'name of person' | where {$_.Name -notlike "Domain Users" -and ($_.Name -notlike "Rackspace_Exchange_Email_Sync_SG")} |% {Remove-ADPrincipalGroupMembership -Identity 'name of person' -MemberOf $_ -Confirm:$false}

#Change username!!!
Get-ADUser -identity '' -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -members lakrami

#Change username and info!!!
Set-ADUser -identity name1 -Enabled $true -City 'Tampa' -State 'FL' -Office 'Office1' -Title 'Quality Assurance Specialist' -Department 'Academics' -Manager $null -server dc01