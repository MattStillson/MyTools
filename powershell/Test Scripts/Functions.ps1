Function CreateCred ($FileLocation){
$cred= New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "mstillsonom@ultimatemedical.onmicrosoft.com", (Get-Content $FileLocation | ConvertTo-SecureString)
return $cred
}

Function ConnectServices($cred){
    #Import Modules
    Import-Module MsOnline, MSOnlineExtended
	#Get Connection Credential 
    Connect-MsolService -Credential $cred
}

Function ConnectExchange($cred){
	#Get Connection Credential
  #Create Sessions
	#$exchange = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
	#Import Sessions
	#Import-PSSession $exchange -AllowClobber
	#Import Module C:\Scripts\Scripts\O365\Exchange\Microsoft.Exchange.Management.ExoPowershellModule.dll
	#Import-Module "C:\Scripts\Scripts\O365\CreateExoPSSession.ps1"
  #Connect-EXOPSSession $cred
  $exchange = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $cred -Authentication "Basic" -AllowRedirection
  Import-PSSession $exchange -AllowClobber -DisableNameChecking
}