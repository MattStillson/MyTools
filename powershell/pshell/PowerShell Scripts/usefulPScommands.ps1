Get-ExecutionPolicy
Set-ExecutionPolicy Unrestricted

// hotfixes recently installed adjust dates to present time.
Get-HotFix | Where-Object {$_.InstalledOn -gt "1/1/2017" -AND $_.InstalledOn -lt "3/23/2017" } | Sort-Object InstalledOn | ConvertTo-Html -Property PSComputerName, InstalledOn, HotfixID, Description, Caption > C:\Intel\hotfix.htm

// shows all statuses for services.
Get-Service | ConvertTo-Html -Property Name, Status > C:\Intel\services.htm

// force stop chrome
Get-Process Chrome | Stop Process -force

// shutdown pc
shutdown -r -t 0

// need to change log names for what your wanting
Get-EventLog -LogName System -InstanceID c0ffee -Source “LSA“

// uses your creds and restarts remote pc * enter PC name this is a remote command
Get-Credential | Restart-Computer -ComputerName namehere

//clear tmp files
Get-ChildItem C:\ -include '$_.tmp' -recurse | ForEach-Object ($_) {remove-item [-Force] $_.fullname}

Install-Script -Name Export-LastLogonTime

