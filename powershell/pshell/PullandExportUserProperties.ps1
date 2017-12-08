$Users = gc "C:\scripts\CSV\34533.csv"

Get-ADUser -Filter '*' -Properties SAMAccountName,Description,Enabled | ? { $Users -contains $_.SamAccountName } | select SAMAccountName,Description,Enabled | Export-Csv 'C:\scripts\csv\34533Results.csv' -NoType