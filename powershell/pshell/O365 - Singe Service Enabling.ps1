# Bulk Enable Office 365 License Options v1.2

# COMMENT OUT ANY SERVICES YOU WANT TO ENABLE

#Connect-MsolService

$AccountSkuId = "contoso:STANDARDWOFFPACK_IW_FACULTY"
$LicensedUsers = (Import-Csv "c:\scripts\CSV\UserList.csv" | Select UserPrincipalName)
#$LicensedUsers = (Get-MsolUser -All | Where { $_.IsLicensed -eq $true } | Select UserPrincipalName)

ForEach ($User in $LicensedUsers) {
    $Upn = $User.UserPrincipalName
    $AssignedLicenses = (Get-MsolUser -UserPrincipalName $Upn).Licenses
    $Exchange = "Disabled"; $SharePoint = "Disabled"; $Skype = "Disabled"; $Office = "Disabled"; $WebApps = "Disabled"; $Yammer = "Disabled"; $DataSync = "Disabled"; $Stream = "Disabled"; $Teams = "Disabled"; $Intune = "Disabled"; $Deskless = "Disabled"; $Flow = "Disabled"; $PowerApps = "Disabled"; $AzureRights = "Disabled"; $Forms = "Disabled"; $Planner = "Disabled"; $Sway = "Disabled"
    ForEach ($License in $AssignedLicenses) {
        If ($License.AccountSkuId -eq "$AccountSkuId") {
            ForEach ($ServiceStatus in $License.ServiceStatus) {
                If ($ServiceStatus.ServicePlan.ServiceName -eq "EXCHANGE_S_STANDARD" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $Exchange = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "SHAREPOINTSTANDARD_EDU" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $SharePoint = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "MCOSTANDARD" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $Skype = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "OFFICESUBSCRIPTION" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $Office = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "SHAREPOINTWAC_EDU" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $WebApps = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "YAMMER_EDU" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $Yammer = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "SCHOOL_DATA_SYNC_P1" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $DataSync = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "STREAM_O365_E3" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $Stream = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "TEAMS1" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $Teams = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "INTUNE_O365" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $Intune = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "Deskless" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $Deskless = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "FLOW_O365_P2" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $Flow = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "POWERAPPS_O365_P2" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $PowerApps = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "RMS_S_ENTERPRISE" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $AzureRights = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "OFFICE_FORMS_PLAN_2" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $Forms = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "PROJECTWORKMANAGEMENT" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $Planner = "Enabled" }
                If ($ServiceStatus.ServicePlan.ServiceName -eq "SWAY" -and $ServiceStatus.ProvisioningStatus -ne "Disabled") { $Sway = "Enabled" }

            }
            $DisabledOptions = @()
            If ($Exchange -eq "Disabled”) { $DisabledOptions += “EXCHANGE_S_STANDARD“ }
            If ($SharePoint -eq "Disabled”) { $DisabledOptions += “SHAREPOINTSTANDARD_EDU“ }
            If ($Skype -eq "Disabled”) { $DisabledOptions += “MCOSTANDARD“ }
            If ($Office -eq "Disabled”) { $DisabledOptions += “OFFICESUBSCRIPTION“ }
            If ($WebApps -eq "Disabled”) { $DisabledOptions += “SHAREPOINTWAC_EDU“ }
            If ($Yammer -eq "Disabled”) { $DisabledOptions += “YAMMER_EDU“ }
            If ($DataSync -eq "Disabled”) { $DisabledOptions += “SCHOOL_DATA_SYNC_P1“ }
            If ($Stream -eq "Disabled”) { $DisabledOptions += “STREAM_O365_E3“ }
            If ($Teams -eq "Disabled”) { $DisabledOptions += “TEAMS1“ }
            If ($Intune -eq "Disabled”) { $DisabledOptions += “INTUNE_O365“ }
            If ($Deskless -eq "Disabled”) { $DisabledOptions += “Deskless“ }
            If ($Flow -eq "Disabled”) { $DisabledOptions += “FLOW_O365_P2“ }
            If ($PowerApps -eq "Disabled”) { $DisabledOptions += “POWERAPPS_O365_P2“ }
            If ($AzureRights -eq "Disabled”) { $DisabledOptions += “RMS_S_ENTERPRISE“ }
            If ($Forms -eq "Disabled”) { $DisabledOptions += “OFFICE_FORMS_PLAN_2“ }
            If ($Planner -eq "Disabled”) { $DisabledOptions += “PROJECTWORKMANAGEMENT“ }
            If ($Sway -eq "Disabled") { $DisabledOptions += "SWAY" }

            $LicenseOptions = New-MsolLicenseOptions -AccountSkuId $AccountSkuId -DisabledPlans $DisabledOptions
            Set-MsolUserLicense -User $Upn -LicenseOptions $LicenseOptions
        }
    }
}