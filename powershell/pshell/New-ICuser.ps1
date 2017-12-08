import-module 'C:\scripts\scripts\posh-ic\posh-ic.psm1'

$cic = New-ICSession -ComputerName 'ic01' -User 'ME!' -Password 'MINE!'
Set-ICLicense -ICSession $cic -ICUser '' -MediaLevel 1 -AdtionalLicenses 'I3_ACCESS_RECORDER'
Remove-IceSession -ICSession $cic


$cic = New-ICSession -ComputerName 'ic01' -User 'ME!' -Password 'MINE!'
Set-ICLicense -ICSession $cic -ICUser 'tarwilliams' -MediaLevel 0 -AdditionalLicenses 'I3_ACCESS_RECORDER'
Remove-ICSession -ICSession $cic