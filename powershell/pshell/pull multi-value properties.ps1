﻿Get-ADGroup TPA-all -Properties *| select @{name=”authorig”;expression={$_.authorig -join “;”}}  | export-csv "C:\Scripts\csv\TPAall.csv"