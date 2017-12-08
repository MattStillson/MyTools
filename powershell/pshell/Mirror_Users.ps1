Import-Module ActiveDirectory
Get-ADUser -Identity alan0 -Properties memberof  | Select-Object -ExpandProperty memberof  | Add-ADGroupMember -Members frank0, gary0, jack0, john0, michael0, paul0