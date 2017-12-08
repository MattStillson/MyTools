[string]$Computer = $env:computername
[String]$date = Get-Date -Format "dd-MM-yyyy"
[int]$Days = 90
$Result = @()
Write-Host "Gathering Event Logs, this can take awhile..."
$ELogs = Get-EventLog System -Source Microsoft-Windows-WinLogon -After (Get-Date).AddDays(-$Days) -ComputerName $Computer
If ($ELogs){
    Write-Host "Processing..."
    ForEach ($Log in $ELogs){
        If ($Log.InstanceId -eq 7001){
            $ET = "Logon"
        }ElseIf ($Log.InstanceId -eq 7002){
            $ET = "Logoff"
        }
        Else{
            Continue
        }
        $Result += New-Object PSObject -Property @{
            Time = $Log.TimeWritten
            User = (New-Object System.Security.Principal.SecurityIdentifier $Log.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])
        }
    }
    $Result | Select-Object Time,$ET,User | Sort-Object Time -Descending | Export-Csv "C:\Intel\$Computer_$date.txt"
    Write-Host "Done."
}Else{
    Write-Host "Problem with $Computer."
    Write-Host "If you see a 'Network Path not found' error, try starting the Remote Registry service on that computer."
    Write-Host "Or there are no logon/logoff events (XP requires auditing be turned on)"
}