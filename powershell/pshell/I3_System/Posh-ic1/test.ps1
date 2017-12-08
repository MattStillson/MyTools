function Get-ICLicensesAllUsers {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory = $true)] [Alias("Session", "Id")] [ININ.ICSession] $ICSession,
    [Parameter(Mandatory = $true)] [Alias("User")] [string] $ICUser,
    [Parameter(Mandatory = $false)] [Alias("ClientAccess")] [boolean] $HasClientAccess,
    [Parameter(Mandatory = $false)] [Alias("EnableLicenses", "ActivateLicenses")] [boolean] $LicenseActive,
    [Parameter(Mandatory = $false)] [Alias("MediaLicense")] [int] $MediaLevel,
    [Parameter(Mandatory = $false)] [string[]] $AdditionalLicenses
  )
  $userExists = Get-ICUser $ICSession -ICUser $ICUser
  if ([string]::IsNullOrEmpty($userExists)) {
    return
  }

  if (!$PSBoundParameters.ContainsKey('HasClientAccess')) {
    $HasClientAccess = $true
  }

  if (!$PSBoundParameters.ContainsKey('LicenseActive')) {
    $LicenseActive = $true
  }

  if (!$PSBoundParameters.ContainsKey('MediaLevel')) {
    $MediaLevel = 3
  }

  # Add headers
  $headers = @{
    "Accept-Language"      = $ICSession.language;
    "ININ-ICWS-CSRF-Token" = $ICSession.token;
  }
  if ($AdditionalLicenses) {
    # Get Licenses all licenses?
    if ($AdditionalLicenses.Length -eq 1 -and $AdditionalLicenses[0] -eq "*") {
      $allAdditionalLicenses = ((Get-ICLicenseAllocations $ICSession).items | foreach { if (-not ($_.configurationId.id -match "EASYSCRIPTER" -or $_.configurationId.id -match "MSCRM")) { $_.configurationId }
        })
      if (![string]::IsNullOrEmpty($licenseProperties)) {
        $body += @{
          "licenseProperties" = $licenseProperties
        }
      }

      $body = ConvertTo-Json($body) -Depth 4

      # Call it!
      $response = Invoke-RestMethod -Uri "$($ICsession.baseURL)/$($ICSession.id)/configuration/users/$($ICUser)" -Body $body -Method Put -Headers $headers -WebSession $ICSession.webSession -ErrorAction Stop
      Write-Output $response | Format-Table
      [PSCustomObject] $response
    }
  }
}
