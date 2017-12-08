#Get-GPPermissions -All -Guid 8 | Export-Csv 'C:\scripts\csv\222.csv' -NoType

#Get-GPO -All | Export-Csv 'C:\scripts\csv\111.csv' -NoType

Get-GPOReport -All -ReportType HTML | Set-Content C:\Scripts\GPOReport.html