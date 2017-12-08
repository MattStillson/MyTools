#Set-ExecutionPolicy RemoteSigned
Import-Module $((Get-ChildItem -Path $($env:LOCALAPPDATA+"\Apps\2.0\") -Filter Microsoft.Exchange.Management.ExoPowershellModule.dll -Recurse ).FullName|?{$_ -notmatch "_none_"}|select -First 1)
Import-Module MSOnline

#connect-msolservice -Credential $UserCredential - this uses stored credentials

Function CreateCred ($FileLocation){
$cred= New-Object -TypeName [System.Management.Automation.PSCredential] -ArgumentList "mstillson@something.onmicrosoft.com", (Get-Content "C:\Scripts\Learn\cred.txt" | ConvertTo-SecureString)
return $cred
}

$EXOSession = New-ExoPSSession -AzureADAuthorizationEndpointUri 'https://login.windows.net/common' -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred
Import-PSSession $EXOSession

Function CreateCred ($FileLocation){
$cred= New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "mstillson@something.onmicrosoft.com", (Get-Content $FileLocation | ConvertTo-SecureString)
return $cred
}

Function ConnectServices($cred){
    #Import Modules
    Import-Module MsOnline, MSOnlineExtended
    Import-Module $((Get-ChildItem -Path $($env:LOCALAPPDATA+"\Apps\2.0\") -Filter Microsoft.Exchange.Management.ExoPowershellModule.dll -Recurse ).FullName|?{$_ -notmatch "_none_"}|select -First 1)
	#Get Connection Credential
    Connect-MsolService -Credential $cred
}

$cred = CreateCred -FileLocation C:\Scripts\Learn\cred.txt
ConnectServices $cred
