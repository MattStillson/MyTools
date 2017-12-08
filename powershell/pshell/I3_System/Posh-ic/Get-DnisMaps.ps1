function Get-DnisMaps() {
  [CmdletBinding()]
  Param(
  [Parameter(Mandatory=$true)]  [Alias("Session", "Id")] [ININ.ICSession] $ICSession
  )
  $headers = @{
    "Accept-Language"      = $ICSession.language;
    "ININ-ICWS-CSRF-Token" = $ICSession.token;
  }


    $response = Invoke-RestMethod -Uri "$($ICsession.baseURL)/$($ICSession.id)/configuration/dnis-mappings/?select=routingTable&rightsFilter=admin" -Method Get -ContentType 'application/json' -Headers $headers -WebSession $ICSession.webSession -ErrorAction Stop -OutFile C:\Scripts\did.json
    Write-Output $response | Format-List
}