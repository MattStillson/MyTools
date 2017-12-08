
function Get-ICDirectoriesUser() {
# Documentation {{{3
<#
.SYNOPSIS
  Gets a list of all additional licenses
.DESCRIPTION
  Gets a list of all additional licenses, as shown in the User "Licensing" tab
.PARAMETER ICSession
  The Interaction Center Session
.PARAMETER ICUser
The User you would like to look up
#> # }}}3
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$true)]  [Alias("Session", "Id")] [ININ.ICSession] $ICSession,
  [Parameter(Mandatory=$true)] [Alias("User")] [string] $ICUser
)
if (! $PSBoundParameters.ContainsKey('ICUser'))
{
  $ICUser = $ICSession.user
}
$response = '';
  $response = Invoke-RestMethod -Uri "$($ICsession.baseURL)/$($ICSession.id)/configuration/dnis-mappings" -Method Get -Headers $headers -WebSession $ICSession.webSession -ErrorAction Stop
  Write-Output $response | Format-Table
  [PSCustomObject] $response
}