function Grant-userFullRights {            
 [cmdletbinding()]            
 param(            
 [Parameter(Mandatory=$true)]            
 [string[]]$Files,            
 [Parameter(Mandatory=$true)]            
 [string]$UserName            
 )            
 $rule=new-object System.Security.AccessControl.FileSystemAccessRule ($UserName,"FullControl","Allow")            

 foreach($File in $Files) {            
  if(Test-Path $File) {            
   try {            
    $acl = Get-ACL -Path $File -ErrorAction stop            
    $acl.SetAccessRule($rule)            
    Set-ACL -Path $File -ACLObject $acl -ErrorAction stop            
    Write-Host "Successfully set permissions on $File"            
   } catch {            
    Write-Warning "$File : Failed to set perms. Details : $_"            
    Continue            
   }            
  } else {            
   Write-Warning "$File : No such file found"            
   Continue            
  }            
 }            
}

$Users = Import-Csv -Path C:\Scripts\CSV\124.csv
foreach ($User in $Users){
    
    $Name = $User.files
    $SAM = $User.username

    Grant-userFullRights -Files $Name -UserName $SAM
}