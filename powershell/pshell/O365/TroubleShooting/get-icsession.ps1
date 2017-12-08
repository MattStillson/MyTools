# Load the DLL (needs to be x86)
[CmdletBinding()]
param
(
    [string]$ICServer,
    [string]$ICPort,
    [string]$UserName,
    [string]$Password
)

#force this to run in 32 bit
if ($env:Processor_Architecture -ne "x86")
{
    # http://stackoverflow.com/questions/9991752/how-to-execute-powershell-script-in-64-bit-machine
    # http://stackoverflow.com/questions/4647429/powershell-on-windows-7-set-executionpolicy-for-regular-users
    # http://stackoverflow.com/questions/5079413/how-to-pass-boolean-values-to-powershell-script-from-command-prompt
    write-warning "Running PowerShell x86"

    &"$env:windir\syswow64\windowspowershell\v1.0\powershell.exe" -noninteractive -noprofile -command $myinvocation.Line
    exit
}

# Load the IceLib API
Add-Type -Path "C:\Program Files (x86)\Interactive Intelligence\IceLib SDK\bin\ININ.IceLib.dll"
write-verbose "IceLib SDK x64 released for CIC 4.0 SU4"

######################################################################
$sessionSettings = new-object  ININ.IceLib.Connection.SessionSettings;
$sessionSettings.IsoLanguage = "en-US";
$sessionSettings.ApplicationName = "FergusCustomApplication";
$sessionSettings.ClassOfService = "General";  # HighlyAvailable, General, SparselyAvailable
write-verbose "IceLib Version: $($sessionSettings.IcelibFileVersion) ($($sessionSettings.IcelibDisplayVersion))"


###############################################################
$hostSettings = new-object ININ.IceLib.Connection.HostSettings;
# Host name of the Interaction Center server
if ($ICServer)
{
    write-verbose "Using [-ICServer <SERVER>] Command Line Argument"
}
else
{
    # No passed server name
    write-verbose "Using ICServer from Host Settings"
    if ($($hostSettings.HostEndpoint.Host))
    {
        $ICServer = $($hostSettings.HostEndpoint.Host);
    }
    else
    {
        write-error "HostSettings.HostEndpoint.Host is not set. Please call this command with the [-ICServer <SERVER>] argument. Error Code: 99";
        Exit 99;
    }
}

# Host Port of the Interaction Center server
if ($ICPort)
{
    write-verbose "Using [-ICPort <SPORT>] Command Line Argument"
}
else
{
    # No passed server name
    write-verbose "Using ICPort from Host Settings"
    if ($($hostSettings.HostEndpoint.Port))
    {
        $ICPort = $($hostSettings.HostEndpoint.Port);
    }
    else
    {
        write-error "HostSettings.HostEndpoint.Port is not set. Please call this command with the [-ICPort <PORT>] argument. Default IC port is 3952. Error Code: 98";
        Exit 98;
    }
}
Write-Host -NoNewLine "IC Server: ";
write-host -NoNewLine -ForegroundColor "Green" "$ICServer";
Write-Host -NoNewLine ":";
write-host -ForegroundColor "Green" "$ICPort";

$hostSettings.HostEndpoint.Host = $ICServer;
$hostSettings.HostEndpoint.Port = $ICPort;

#######################################################
[ININ.IceLib.Connection.AuthSettings]$authSettings
if ($UserName -or $Password)
{
    write-verbose "Using IC Authentication"
    $authSettings = new-object -typename ININ.IceLib.Connection.ICAuthSettings -argumentlist $UserName,$Password;
}
else
{
    write-verbose "Using Windows Authentication";
    $authSettings = new-object -typename ININ.IceLib.Connection.WindowsAuthSettings;
}
Write-Host -NoNewLine "Username: ";
write-Host -ForegroundColor "Green" "$($authSettings.Username)";

#######################################################
$stationSettings = new-object ININ.IceLib.Connection.StationlessSettings;



#######################################################
# Create a new Session
$session = new-object ININ.IceLib.Connection.Session;
$session.Connect($sessionSettings, $hostSettings, $authSettings, $stationSettings);


$session

# Workgroup stats
# http://community.inin.com/forums/archive/index.php/t-8067.html