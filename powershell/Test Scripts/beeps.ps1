$cred = CreateCred -FileLocation C:\Scripts\Learn\cred.txt
ConnectServices $cred

$user = "someone@something.com"
Get-MsolUser -UserPrincipalName $user | FL Displayname, Licenses

$SKUs = Get-MSOLAccountSku

foreach($SKU in $SKUs){
Write-Host " "
Write-host $SKU.AccountSkuId
Write-host "-----------------------------------------"

(Get-MsolAccountSku | where {$_.AccountSkuId -eq $SKU.AccountSkuId}).ServiceStatus
}

$cred = CreateCred -FileLocation C:\Scripts\Learn\cred.txt
ConnectExchange $cred

Get-Mailbox -Identity "mstillson" -RecipientTypeDetails