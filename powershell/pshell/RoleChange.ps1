Import-Module ActiveDirectory

$Users = Import-Csv -Path C:\Scripts\CSV\ACARoleChange050117.csv
foreach ($User in $Users)            
{
    $SAM = $User.Username
    $Title = $User.Title
    $City = $User.City
    $State = $User.State
    $Office = $User.Campus
    $Department = $User.Department
    $Path = $User.Path
    
    Get-ADPrincipalGroupMembership -Identity $SAM | where {$_.Name -notlike "Domain Users" -and ($_.Name -notlike "Rackspace_Exchange_Email_Sync_SG")} |% {Remove-ADPrincipalGroupMembership -Identity $SAM -MemberOf $_ -Confirm:$false}

    If ($Title -eq "Learner Services Advisor"){
        $groups = Get-ADUser -Identity calstemp -Properties memberof | Select-Object -ExpandProperty memberof
            foreach ($group in $groups)
            {Add-ADGroupMember -Identity $group -members $SAM}}

    Elseif ($Title -eq "New Student Advisor"){
        $groups = Get-ADUser -Identity nsalstemp -Properties memberof | Select-Object -ExpandProperty memberof
            foreach ($group in $groups)
            {Add-ADGroupMember -Identity $group -members $SAM}}

    Elseif ($Title -eq "Classroom Support Specialist"){
        $groups = Get-ADUser -Identity cslstemp -Properties memberof | Select-Object -ExpandProperty memberof
            foreach ($group in $groups)
            {Add-ADGroupMember -Identity $group -members $SAM}}

    Elseif ($Title -eq "Mock Interview Specialist"){
        $groups = Get-ADUser -Identity milstemp -Properties memberof | Select-Object -ExpandProperty memberof
            foreach ($group in $groups)
            {Add-ADGroupMember -Identity $group -members $SAM}}
            
    Elseif ($Title -eq "Career Services Advisor"){
        $groups = Get-ADUser -Identity cstemp -Properties memberof | Select-Object -ExpandProperty memberof
            foreach ($group in $groups)
            {Add-ADGroupMember -Identity $group -members $SAM}}

    Elseif ($Title -eq "Admissions Representative"){
        $groups = Get-ADUser -Identity admtemp -Properties memberof | Select-Object -ExpandProperty memberof
            foreach ($group in $groups)
            {Add-ADGroupMember -Identity $group -members $SAM}}

    Elseif ($Title -eq "Student Finance Planner"){
        $groups = Get-ADUser -Identity sfptemp -Properties memberof | Select-Object -ExpandProperty memberof
            foreach ($group in $groups)
            {Add-ADGroupMember -Identity $group -members $SAM}}
            
    Elseif ($Title -eq "Online Adjunct Instructor"){
        $groups = Get-ADUser -Identity oaitemp -Properties memberof | Select-Object -ExpandProperty memberof
            foreach ($group in $groups)
            {Add-ADGroupMember -Identity $group -members $Username}}

    Set-ADUser -identity $SAM -Enabled $true -City $City -State $State -Office $Office -Title $Title -Department $Department -Manager $null -server mlk-inf-p-dc01

    Get-ADUser $SAM | Move-ADObject -TargetPath $Path
}