[string]$Computer = "localhost"
[String]$date = Get-Date -Format "dd-MM-yyyy"
[int]$Days = 90
$Result = @()
Write-Host "Gathering Event Logs, this can take awhile..."
$FilterEvents=@"
<QueryList>
  <Query Id="0" Path="System">
    <Select Path="System">*[System[(EventID=7001 or EventID=7002)]]</Select>
    <Select Path="Security">*[System[EventID=4624 or 4634] and EventData[Data[@Name='ProcessName'] = 'C:\Windows\System32\winlogon.exe']]</Select>
  </Query>
</QueryList>
"@
$Top="<style>"
$Top=$Top+"body{ background-color:#FFFFFF; border:1px solid #666666; color:#000000; font-size:68%; font-family:MS Shell Dlg; margin:0,0,3px,0; word-break:normal; word-wrap:break-word; }"
$Top=$Top+"table{ font-size:100%; table-layout:fixed; width:100%; }"
$Top=$Top+"h2{background: lightblue}"
$Top=$Top+"th{ overflow:visible; text-align:left; vertical-align:top; white-space:normal; border: 1px solid black; background: grey}"
$Top=$Top+"td{ overflow:visible; text-align:left; vertical-align:top; white-space:normal; border: 1px solid black; background: gainsboro}"
$Top=$Top+".title{ background:#FFFFFF; border:none; color:#333333; display:block; height:24px; margin:0px,0px,-1px,0px; padding-top:4px; position:relative; table-layout:fixed; width:100%; z-index:5; }"
$Top=$Top+"</style>"
Get-WinEvent -FilterXML $FilterEvents | Where-Object {$_.TimeCreated -ge $Days} | ConvertTo-Html -Property MachineName, UserId, TimeCreated, BookMark > C:\Intel\LoginTimes.htm
