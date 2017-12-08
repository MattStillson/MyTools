$1 = "18 16 14 4".Split(" ")
$2 = "23 19 18 10 13 3".Split(" ")
$3 = "61 46 45 43 40 16 24 21".Split(" ")
$4 = "48 23".Split(" ")
$5 = "65 61 60 42 48 57 52 54".Split(" ") 
Clear-Host
Write-Host "Random full name generator"
Write-Host 
1..100 | foreach { 
    $1st = $1[ (Get-Random $1.count ) ]
    $2nd = $2[ (Get-Random $2.count ) ]
    $3rd = $3[ (Get-Random $3.count ) ]
    $4th = $4[ (Get-Random $4.count ) ]
    $5th = $5[ (Get-Random $5.count ) ]
    
    $full = $1st+", "+$2nd+", "+$3rd+", "+$4th+", "+$5th
    


    Write-Host -NoNewline $full.PadRight(25)
    If ($_ % 2 -eq 0) {
        Write-Host ""
    }
}