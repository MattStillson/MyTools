$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
Get-Credential -Credential $user
$Hours = (Get-Date) - (New-TimeSpan -Hour 2)
$FilterEvents = @"
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[(Level=1  or Level=2 or Level=3)TimeCreated[timediff(@SystemTime)&lt;= 86400000]]]</Select>
    <Select Path="Security">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="System">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="ActivationClientLibrary">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="HardwareEvents">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Internet Explorer">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Key Management Service">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Media Center">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Application Server-Applications/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-BitLocker-DrivePreparationTool/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-DSC/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Dhcp-Client/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-DhcpNap/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Dhcpv6-Client/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Diagnosis-Scripted/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Kernel-EventTracing/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-MUI/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-PowerShell/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-PrintService/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-RemoteApp and Desktop Connections/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-RemoteAssistance/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-RemoteDesktopServices-RdpCoreTS/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="microsoft-windows-RemoteDesktopServices-RemoteDesktopSessionManager/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-TerminalServices-ClientUSBDevices/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-TerminalServices-LocalSessionManager/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-TerminalServices-PnPDevices/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-TerminalServices-RemoteConnectionManager/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-TerminalServices-ServerUSBDevices/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-WindowsBackup/ActionCenter">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="OAlerts">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Windows PowerShell">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
  </Query>
</QueryList>
"@
Get-WinEvent -FilterXML $FilterEvents | Where-Object {$_.TimeCreated -ge $Hours} | ConvertTo-Html > C:\Intel\AppLog.htm
Get-HotFix | Where-Object {$_.InstalledOn -gt "1/1/2017" -AND $_.InstalledOn -lt "3/24/2017" } | Sort-Object InstalledOn | ConvertTo-Html -Property PSComputerName, InstalledOn, HotfixID, Description, Caption > C:\Intel\hotfix.htm
Get-Service | Where-Object{$_.Status -eq "Running"} | ConvertTo-Html -Property Name, Status > C:\Intel\services.htm