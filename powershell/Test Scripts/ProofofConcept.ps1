Get-Service s*

$Script:WindowVersion = [Environment]::OSVersion.Version.Major
write-host $Script:WindowVersion

Get-ChildItem $PSHOME\PowerShell.exe | Format-List -Property *

(New-Object System.Net.WebClient).Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
get-wmiobject -query "SELECT * FROM Win32_service"

(New-Object System.Net.WebClient).Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
[void][System.Runtime.Interopservices.Marshal]::FinalReleaseComObject($Objexcel)


$s = [WmiSearcher]'Select * from Win32_Process where Handlecount > 1000'
$s.Get() |sort handlecount |ft handlecount,__path,name -auto

Get-Counter
Get-WinEvent

Get-Content myTestLog.log –Wait

Get-Content myTestLog.log -wait | where { $_ -match “WARNING” }


Get-WmiObject -Class Win32_Service -ComputerName 127.0.0.1


### SET FOLDER TO WATCH
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = "C:\fso"
    $watcher.Filter = "*.xls"
    $watcher.EnableRaisingEvents = $true  

### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
    $action = { Start-Process cmd.exe "/c D:\Users\xfirebg\Desktop\excel\append.cmd"
              }    
### DECIDE WHICH EVENTS SHOULD BE WATCHED 
    Register-ObjectEvent $watcher "Created" -Action $action
    while ($true) {sleep 20}