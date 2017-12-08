Function Load-ExchangeMFAModule {
[CmdletBinding()]
Param ()
    $Modules = @(Get-ChildItem -Path "$($env:LOCALAPPDATA)\Apps\2.0" -Filter "Microsoft.Exchange.Management.ExoPowershellModule.manifest" -Recurse )
    if ($Modules.Count -ne 1 ) {
        throw "No or Multiple Modules found : Count = $($Modules.Count )"
    }  else {
        $ModuleName =  Join-path $Modules[0].Directory.FullName "Microsoft.Exchange.Management.ExoPowershellModule.dll"
        Write-Verbose "Start Importing MFA Module"
        Import-Module -FullyQualifiedName $ModuleName  -Force

        $ScriptName =  Join-path $Modules[0].Directory.FullName "CreateExoPSSession.ps1"
        if (Test-Path $ScriptName) {
            return $ScriptName
            <#
            # Load the script to add the additional commandlets (Connect-EXOPSSession)
            # DotSourcing does not work from inside a function (. $ScriptName)
            #Therefore load the script as a dynamic module instead

            $content = Get-Content -Path $ScriptName -Raw -ErrorAction Stop
            #BugBug >> $PSScriptRoot is Blank :-(
            <#
            $PipeLine = $Host.Runspace.CreatePipeline()
            $PipeLine.Commands.AddScript(". $scriptName")
            $r = $PipeLine.Invoke()
            #Err : Pipelines cannot be run concurrently.

            $scriptBlock = [scriptblock]::Create($content)
            New-Module -ScriptBlock $scriptBlock -Name "Microsoft.Exchange.Management.CreateExoPSSession.ps1" -ReturnResult -ErrorAction SilentlyContinue
            #>

        } else {
            throw "Script not found"
            return $null
        }
    }
}

Function CreateCred ($FileLocation){
$cred= New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "mstillsonom@something.onmicrosoft.com", (Get-Content $FileLocation | ConvertTo-SecureString)
return $cred
}

$cred = CreateCred -FileLocation C:\Scripts\Learn\cred.txt
ConnectServices $cred
$EXOSession = New-ExoPSSession -AzureADAuthorizationEndpointUri 'https://login.windows.net/common' -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred
Import-PSSession $EXOSession -AllowClobber | Out-Null