Start-Transcript -OutputDirectory "C:\Scripts\Logs\RoleChange" -Force

Import-Module ActiveDirectory

$Users = Import-Csv -Path C:\Scripts\CSV\Mirrors.csv
foreach ($User in $Users)            
{            
    $SAM = $User.Username
    $Mirror = $User.Mirror
    
Get-ADPrincipalGroupMembership -Identity $SAM | where {$_.Name -notlike "Domain Users"} |% {Remove-ADPrincipalGroupMembership -Identity $SAM -MemberOf $_ -Confirm:$false}

Get-ADUser -identity $Mirror -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -members $SAM

}

Stop-Transcript