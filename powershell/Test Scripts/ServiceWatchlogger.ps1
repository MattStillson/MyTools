# SET VARIABLES FOR SERVERNAMES
# GET LIST OF SERVICES
# ATTEMPT RESTART 3 TIMES AFTER 3RD EMAIL
# RUN WMI SCAN OF PROCESSES AND MEMORY AND CPU
# DEBUG, INFO, WARN, ERROR, FATAL [STRING]
# using this with script to log to sql server for monitoring

[System.Enum]::GetNames([microsoft.win32.registryvaluekind])

$ComputerNames = 'C:\Scripts\Computers.txt'
$CoreServices = ''

Get-WmiObject -Class Win32_Service -ComputerName $ComputerNames
if (Get-Service -Name $CoreServices | Where-Object {$_.Status -eq "Stopped"}){
    Get-Service -Name $CoreServices | Foreach { Where-Object {$_.Status -eq "Stopped"} | Restart-Service | Send-Email
}
get-service lanmanserver | Foreach { start-service $_.name -passthru; start
-service $_.DependentServices -passthru}

get-service | where {$_.CanPauseandContinue}

Invoke-Command {restart-service dns –passthru} –comp chi-dc03,chi-dc02,chi-dc01


get-wmiobject win32_service | format-table
get-wmiobject win32_service -filter "name='bits'" | Select *
get-wmiobject win32_service -filter "StartMode <>'disabled'" | sort StartMode | format-table -GroupBy StartMode -Property Name,State,PathName -AutoSize
get-wmiobject win32_service -filter "startmode='auto' AND state<>'Running'" | Select Name,State
get-wmiobject win32_service -computer $computers -filter "startname like '%administrator%'"| Select Name,startmode,state,startname,systemname

get-ciminstance win32_service -comp chi-dc01
get-ciminstance win32_service -filter "startmode='auto' AND state<>'Running'" -comp chi-ex01 | Select Name,State,Systemname

### starting service with service account.
Get-CimInstance win32_service -filter "name='yammmsvc'" | Invoke-CimMethod -Name Change -Arguments @{StartName=".\Jeff";StartPassword="P@ssw0rd"}
Invoke-CimMethod -Name Change -Arguments {StartName=".\Jeff";StartPassword="P@ssw0rd"} -Query "Select * from Win32_Service where name='yammmsvc'" –Computername JeffPC

### outfile can be switched around to sql with a insert statement
Invoke-CimMethod -Name Change -Arguments @{StartPassword="P@ssw0rd"} -Query "Select * from Win32_service where name='MyCustomService'" –computername $computers | out-file c:\work\results.txt