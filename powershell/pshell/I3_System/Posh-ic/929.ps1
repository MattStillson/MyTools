Import-Module 'C:\Scripts\Scripts\Posh-ic\Posh-IC.psm1'

$cic = New-ICSession -ComputerName mlk-tel-p-ic01 -User 'mstillson' -Password 'Logitech2017!'
Get-DnisMaps -ICSession $cic
Remove-ICSession $cic

$cic = New-ICSession -ComputerName mlk-tel-p-ic01 -User 'mstillson' -Password 'Logitech2017!'
Set-ICLicense -ICSession $cic -ICUser '' -AdditionalLicenses I3_Access_Recorder -HasClientAccess $true -LicenseActive $true -MediaLevel 0
Remove-ICSession $cic

$cic = New-ICSession -ComputerName mlk-tel-p-ic01 -User 'mstillson' -Password 'Logitech2017!'
Get-ICUser -ICSession $cic -ICUser 'mstillson'
Remove-ICSession $cic

$cic = New-ICSession -ComputerName mlk-tel-p-ic01 -User 'mstillson' -Password 'Logitech2017!'
(Get-ICLicenseAllocations -ICSession $cic).items
Remove-ICSession $cic



$cic = New-ICSession -ComputerName mlk-tel-p-ic01 -User 'mstillson' -Password 'Logitech2017!'
Get-ICSessionStatus -ICSession $cic
Remove-ICSession $cic