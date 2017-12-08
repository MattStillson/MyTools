[CmdletBinding()]
param(
      [Parameter(ValueFromPipeline=$true,Position=1,Mandatory=$false)][ValidateSet("HTML","CSV","BOTH")]$Selector="HTML"
)
function Write-Log{
    [CmdletBinding()]
    #[Alias('wl')]
    [OutputType([int])]
    Param(
            # The string to be written to the log.
            [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)] [ValidateNotNullOrEmpty()] [Alias("LogContent")] [string]$Message,
            # The path to the log file.
            [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=1)] [Alias('LogPath')] [string]$Path=$global:DefaultLog,
            [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true,Position=2)] [ValidateSet("Error","Warn","Info","Load","Execute")] [string]$Level="Info",
            [Parameter(Mandatory=$false)] [switch]$NoClobber
    )

     Process{

        if ((Test-Path $Path) -AND $NoClobber) {
            Write-Warning "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name."
            Return
            }

        # If attempting to write to a log file in a folder/path that doesn't exist
        # to create the file include path.
        elseif (!(Test-Path $Path)) {
            Write-Verbose "Creating $Path."
            $NewLogFile = New-Item $Path -Force -ItemType File
            }

        else {
            # Nothing to see here yet.
            }

        # Now do the logging and additional output based on $Level
        switch ($Level) {
            'Error' {
                Write-Warning $Message
                Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") ERROR: `t $Message" | Out-File -FilePath $Path -Append
                }
            'Warn' {
                Write-Warning $Message
                Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") WARNING: `t $Message" | Out-File -FilePath $Path -Append
                }
            'Info' {
                Write-Host $Message -ForegroundColor Green
                Write-Verbose $Message
                Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") INFO: `t $Message" | Out-File -FilePath $Path -Append
                }
            'Load' {
                Write-Host $Message -ForegroundColor Magenta
                Write-Verbose $Message
                Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") LOAD: `t $Message" | Out-File -FilePath $Path -Append
                }
            'Execute' {
                Write-Host $Message -ForegroundColor Green
                Write-Verbose $Message
                Write-Output "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") EXEC: `t $Message" | Out-File -FilePath $Path -Append
                }
            }
    }
}
function Get-UserInfoHTML{
    [CmdletBinding()]

    param(
        [Parameter(ValueFromPipeline=$true,Position=1,Mandatory=$false)][ValidateSet("HTML","CSV","BOTH")]$Selector="HTML"
        )

 BEGIN{
    Write-Verbose "Importing Active Directory neccesary CMDLETS"
    import-module activedirectory -CMDLet Get-ADUser,SetADUser
    $TodayDate=get-date -UFormat "%Y%m%d" #"%A-%Y%m%d"
    $dia = get-date -UFormat "%A"
    $fecha = $TodayDate
    $hora= Get-date -UFormat "%H:%M:%S"
    $FnHTML= "UsersInfo-$TodayDate.html"
    $FnCSV = "UsersInfo-$TodayDate.csv"

    $header= @"
    <style type=""text/css"">
    body {font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;}
    #report { width: 835px; }
    table{border-collapse: collapse;border: none;
        font: 10pt Verdana, Geneva, Arial, Helvetica, sans-serif;
        color: black; margin-bottom: 10px;}
    table td{ font-size: 12px; padding-left: 0px; padding-right: 20px; text-align: left;}
    table th{ font-size: 12px; font-weight: bold; padding-left: 0px; padding-right: 20px; text-align: left;}
    h2{ clear: both; font-size: 130%;color:#354B5E; }
    h3{ clear: both; font-size: 75%; margin-left: 20px; margin-top: 30px; color:#475F77; }
    p{ margin-left: 20px; font-size: 12px; }
    table.list{ float: left; }
	table.list td:nth-child(1){font-weight: bold;border-right: 1px grey solid;text-align: right;}
    table.list td:nth-child(2){ padding-left: 7px; }
    table tr:nth-child(even) td:nth-child(even){ background: #BBBBBB; }
    table tr:nth-child(odd) td:nth-child(odd){ background: #F2F2F2; }
    table tr:nth-child(even) td:nth-child(odd){ background: #DDDDDD; }
    table tr:nth-child(odd) td:nth-child(even){ background: #E5E5E5; }
	div.column { width: 320px; float: left; }
    div.first{ padding-right: 20px; border-right: 1px grey solid; }
    div.second{ margin-left: 30px; }
    table{ margin-left: 20px; }
	</style>
"@;
    write-verbose "Getting Script Directory path"
 }
 PROCESS{
    Write-Verbose "Getting information from users"
    $usersnames= get-aduser -filter * -Properties *
	$computer = $env:computername
    $AllInfoProperties=@()
    foreach($user in $usersnames){
        $IDName=$user.SamAccountName
        $AllInfoProperties+=Get-ADUser -Identity $IDName -Properties * | Select *
    }
		$AllUsersFilter=  $AllInfoProperties| Sort-Object Displayname,Enabled | Select DisplayName,GivenName,Surname,Enabled,EmailAddress,UserPrincipalName,Description,HomePhone,MobilePhone,OfficePhone,Created,Modified,LastLogonDate,PasswordLastSet,LastBadPasswordAttempt,ObjectClass,SamAccountName,PostalCode,AllowReversiblePasswordEncryption,CannotChangePassword,LogonWorkstations,PasswordExpired,PasswordNeverExpires,PasswordNotRequired,ProtectedFromAccidentalDeletion,ScriptPath,SmartcardLogonRequired,Country,State,City,StreetAddress,Office,Organization,Company,Department,Title,Manager,EmployeeID,HomeDirectory,HomedirRequired,HomeDrive,LockedOut,ProfilePath,CanonicalName
		#Html5 part
     $html= '<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<title>'
    $html+=$title
    $html+="</title>
	<style type=""text/css"">{margin:0;padding:0}@import url(https://fonts.googleapis.com/css?family=Indie+Flower|Josefin+Sans|Orbitron:500|Yrsa);body{text-align:center;font-family:14px/1.4 'Indie Flower','Josefin Sans',Orbitron,sans-serif;font-family:'Indie Flower',cursive;font-family:'Josefin Sans',sans-serif;font-family:Orbitron,sans-serif}#page-wrap{margin:50px}tr:nth-of-type(odd){background:#eee}th{background:#EF5525;color:#fff;font-family:Orbitron,sans-serif}td,th{padding:6px;border:1px solid #ccc;text-align:center;font-size:large}table{width:90%;border-collapse:collapse;margin-left:auto;margin-right:auto;font-family:Yrsa,serif}</style>
</head>
<body>
	<h1>Event Logs Report for $computer on  $dia $fecha - $hora
</h1>
<h2> System Information </h2>
<table>
<tr>
    <th>DisplayName</th><th>GivenName</th><th>Surname</th><th>Enabled</th><th>EmailAddress</th><th>UserPrincipalName</th><th>Description</th><th>SamAccountName</th><th>HomePhone</th><th>MobilePhone</th><th>OfficePhone</th><th>Created</th><th>Modified</th><th>LastLogonDate</th><th>PasswordLastSet</th><th>LastBadPasswordAttempt</th><th>ObjectClass</th><th>PostalCode</th><th>AllowReversiblePasswordEncryption</th><th>CannotChangePassword</th><th>LogonWorkstations</th><th>PasswordExpired</th><th>PasswordNeverExpires</th><th>PasswordNotRequired</th><th>ProtectedFromAccidentalDeletion</th><th>ScriptPath</th><th>SmartcardLogonRequired</th><th>Country</th><th>State</th><th>City</th><th>StreetAddress</th><th>Office</th><th>Organization</th><th>Company</th><th>Department</th><th>Title</th><th>Manager</th><th>EmployeeID</th><th>HomeDirectory</th><th>HomedirRequired</th><th>HomeDrive</th><th>LockedOut</th><th>ProfilePath</th><th>CanonicalName</th>
</tr>
"

foreach($item in  $AllUsersFilter){
   $html+="<tr> <td>$($item.DisplayName)</td><td>$($item.GivenName)</td><td>$($item.Surname)</td> <td>$($item.Enabled)</td> <td>$($item.EmailAddress)</td> <td>$($item.UserPrincipalName)</td><td>$($item.Description)</td><td>$($item.SamAccountName)</td> <td>$($item.HomePhone)</td> <td>$($item.MobilePhone)</td><td>$($item.OfficePhone)</td><td>$($item.Created)</td><td>$($item.Modified)</td><td>$($item.LastLogonDate)</td><td>$($item.PasswordLastSet)</td><td>$($item.LastBadPasswordAttempt)</td><td>$($item.ObjectClass)</td><td>$($item.PostalCode)</td><td>$($item.AllowReversiblePasswordEncryption)</td><td>$($item.CannotChangePassword)</td><td>$($item.LogonWorkstations)</td><td>$($item.PasswordExpired)</td><td>$($item.PasswordNeverExpires)</td><td>$($item.PasswordNotRequired)</td><td>$($item.ProtectedFromAccidentalDeletion)</td><td>$($item.ScriptPath)</td><td>$($item.SmartcardLogonRequired)</td><td>$($item.Country)</td><td>$($item.State)</td><td>$($item.City)</td><td>$($item.StreetAddress)</td><td>$($item.Office)</td><td>$($item.Organization)</td><td>$($item.Company)</td><td>$($item.Department)</td><td>$($item.Title)</td><td>$($item.Manager)</td><td>$($item.EmployeeID)</td><td>$($item.HomeDirectory)</td><td>$($item.HomedirRequired)</td><td>$($item.HomeDrive)</td><td>$($item.LockedOut)</td><td>$($item.ProfilePath)</td><td>$($item.CanonicalName)</td></tr></tr>"
}

$html+="
</table>
<br>
<footer>
	<a href=""https://www.j0rt3g4.com"" target=""_blank"">
	2017 - J0rt3g4 Consulting Services </a> | - &#9400; All rigths reserved.
	</footer>
</body>
</html>"

 }
 END{
    if($Selector -eq "HTML" -or $Selector -eq "BOTH"){
        $html | Out-File "$global:ScriptLocation\$FnHTML"
    }
    if($Selector -eq "CSV" -or $Selector -eq "BOTH"){
        $AllUsersFilter | ConvertTo-Csv -NoTypeInformation | out-file "$global:ScriptLocation\$FnCSV"
    }
 }
 }

function ShowTimeMS{
  [CmdletBinding()]
  param(
    [Parameter(ValueFromPipeline=$True,position=0,mandatory=$true)]	[datetime]$timeStart,
	[Parameter(ValueFromPipeline=$True,position=1,mandatory=$true)]	[datetime]$timeEnd
  )
  BEGIN {

  }
  PROCESS {
		write-Verbose "Stamping time"
		write-Verbose  "initial time: $TimeStart"
		write-Verbose "End time: $TimeEnd"
		$diff=New-TimeSpan $TimeStart $TimeEnd
		Write-verbose "Timediff= $diff"
		$miliseconds = $diff.TotalMilliseconds
		Write-output " Total Time in miliseconds is: $miliseconds ms"
  }
  END{
    Write-Log -Level Execute -Message "Finished $($diff.TotalSeconds) seconds"
  }
}




$TimeStart=Get-Date
$today = get-date -format MM-dd-yyyy

#Script Start

#Clean Up VariableS
$CleanUpVar=@()
$CleanUpGlobal=@()

#Get start time
$TimeStart=Get-Date
$CleanUpVar+="TimeStart"

#GLOBALs
$global:ScriptLocation = $(get-location).Path
$global:DefaultLog = "$global:ScriptLocation\InfoUsers.log"
$CleanUpGlobal+="ScriptLocation"
$CleanUpGlobal+="DefaultLog"


write-log -Level Info "******************* Script Started $TimeStart *******************"

Get-UserInfoHTML -Selector $Selector

#Get the end time
$TimeEnd=Get-Date

#showtime
write-log -Level Info "******************* Script Finished $TimeEnd *******************"

ShowTimeMS $TimeStart $TimeEnd
