Import-Module ActiveDirectory

$Users = Import-Csv -Path C:\Scripts\CSV\Terms.csv
foreach ($User in $Users)
{
    $SAM = $User.SAM

    $Description = 'Termed ' + $User.TermDate + ' - CMT'

    $NoHoldPath = 'OU=NonLitigationHold,OU=Inactive,OU=OU_Org1,DC=CONTOSO,DC=LOCAL'
    $HoldPath = 'OU=LitigationHold,OU=Inactive,OU=OU_Org1,DC=CONTOSO,DC=LOCAL'
    $GenericPath = 'OU=Inactive,OU=OU_Org1,DC=CONTOSO,DC=LOCAL'
    $Hold = $User.Hold


    $Groups = (Get-ADPrincipalGroupMembership -Identity $SAM | Select-Object -ExpandProperty name) -join ','
    Get-ADUser $SAM -properties memberof,samaccountname,givenname,surname | select samaccountname,givenname,surname, @{name="Groups";expression={$Groups}} | export-csv 'C:\scripts\csv\TermedUserGroups.csv' -Append -Encoding UTF8

    Set-ADUser -Identity $SAM -Description $Description -Manager $null

    Disable-ADAccount -Identity $SAM

    Get-ADPrincipalGroupMembership -Identity $SAM| where {$_.Name -notlike "Domain Users"} |% {Remove-ADPrincipalGroupMembership -Identity $SAM -MemberOf $_ -Confirm:$false}

    #Activate after new AD structure is live!
    #If ($Hold -eq "Yes"){
    #    Get-ADUser $SAM | Move-ADObject -TargetPath $HoldPath
    #    }

    #ElseIf ($Hold -eq "No"){
    #    Get-ADUser $SAM | Move-ADObject -TargetPath $NoHoldPath
    #    }

    #ElseIf (!($Hold)){
    #    Get-ADUser $SAM | Move-ADObject -TargetPath $GenericPath
    #    }

    Else {
       write-host $SAM "Not Moved"
    }
}