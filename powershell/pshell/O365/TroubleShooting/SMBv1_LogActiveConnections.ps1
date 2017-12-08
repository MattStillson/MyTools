<#
.SYNOPSIS
    To Identify SMB connections less than version 2 and log them for centralized review.
.DESCRIPTION
    This script Uses the Get-SMBConnection CMDLet to check for connection dialects (Versions) less than 2.
    Matches from this check are logged into a Custom WMI Class. Only New connections are logged.
    Previous connections remain in WMI for historical purposes. They are not overwritten.
.INPUTS
    NONE
.OUTPUTS
    Log file:
        'C:\Windows\temp\BL_SMBv1_UsageCheck.log'
  
    SMB Connection Info:
        ServerName : Server1
        ShareName  : Share1
        UserName   : Domain\User
        Credential : Domain\User
        Dialect    : 1.5
        NumOpens   : 1

.EXAMPLE
    .\SMBv1_UsageCheck.ps1
.LINK
    The idea on how this SYNOPSIS could be accomplished is original as far as I know.
    However I did use and modify some of the code I found in the links below
    in addition with my own to create and populate the Custom WMI Class
    
    Creating / Populating the Custom WMI Class:
    http://www.myitforum.com/forums/m244352-print.aspx

.LINK
    http://sccmshenanigans.blogspot.com/2013/11/custom-wmi-classes-and-reporting-into.html?_sm_au_=iqV2MmRqjTjrZfQs

.NOTES
    Version:        1.0
    Author:         Joseph Buckley
    Contact:        JosephLBuckley1@gmail.com
    Contact2:       Joseph2290w@gmail.com
    Creation Date:  06/08/2017
    Purpose/Change: Initial script development
#>

# Output Information to be used later
$OutFile = 'C:\Windows\temp\BL_SMBv1_UsageCheck.log'
$Date = Get-Date |Out-String


# Function to Create WMI Class
Function CreateWMIClass{

# Logic - Detect for SMB Connections less than version 2
$SMBConnection = Get-SMBConnection | Where Dialect -LT 2

# Create Management Class
$newClass = New-Object System.Management.ManagementClass `
    ("root\cimv2", [String]::Empty, $null); 
$newClass["__CLASS"] = "SMBv1Connections"; 

$newClass.Qualifiers.Add("Static", $true)

# Add Properties
## ServerName
$newClass.Properties.Add("ServerName",[System.Management.CimType]::String, $false)
$newClass.Properties["ServerName"].Qualifiers.Add("Key", $true)
## ShareName
$newClass.Properties.Add("ShareName",[System.Management.CimType]::String, $false)
$newClass.Properties["ShareName"].Qualifiers.Add("Key", $true)
## UserName
$newClass.Properties.Add("UserName",[System.Management.CimType]::String, $false)
$newClass.Properties["UserName"].Qualifiers.Add("Key", $true)
## Credential
$newClass.Properties.Add("Credential",[System.Management.CimType]::String, $false)
$newClass.Properties["Credential"].Qualifiers.Add("Key", $true)
## Dialect
$newClass.Properties.Add("Dialect",[System.Management.CimType]::String, $false)
$newClass.Properties["Dialect"].Qualifiers.Add("Key", $true)
## NumOpens
$newClass.Properties.Add("NumOpens",[System.Management.CimType]::String, $false)
$newClass.Properties["NumOpens"].Qualifiers.Add("Key", $true)

$newClass.Put()

# Store the data in WMI
    $SMBConnection | % { $i=0 } {
        [void](Set-WmiInstance -Path \\.\root\cimv2:SMBv1Connections `
                               -Arguments @{ServerName=$_.ServerName;ShareName=$_.ShareName;
                                            UserName=$_.UserName;Credential=$_.Credential;
                                            Dialect=$_.Dialect;NumOpens=$_.NumOpens} -Verbose)
        $i++
    }

} # CreateWMIClass


# Logic - Detect for SMB Connections less than version 2 and Call CreateWMIClass Function if there is a match
$SMBConnection = Get-SMBConnection | Where Dialect -LT 2
If($SMBConnection){
    # Check whether we already created our custom WMI class on this PC, if not, create it
    [void](gwmi SMBv1Connections -ErrorAction SilentlyContinue -ErrorVariable wmiclasserror)
    if($wmiclasserror){
        try {CreateWMIClass
        }
        
        catch{
            "Exit 1 - Could not create WMI class"

        }
    }
    
    $Compliance = 'NonCompliant'
}

    Else{
    $Compliance = 'Compliant'
    }


# Check to see if the SMBv1Connections class exits
$SMBv1ClassCheck = Get-WmiObject -Class SMBv1Connections -List
    If($SMBv1ClassCheck){
        $SMBv1Connections = Get-WmiObject -Class SMBv1Connections|
            Select ServerName,ShareName,UserName, `
                   Credential,Dialect,NumOpens |Out-String
    }
    Else{$SMBv1Connections = 'No Class Exists'}

# Output Findings and Compliance
$Output = @"
$Date
 
$Compliance`n


`n`r$SMBv1Connections
"@

$Output| Out-file $OutFile

$Compliance