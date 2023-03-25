param([object] $serviceBusProvisionTeamsDiDMessage, $TriggerMetadata)

$ErrorActionPreference = "Stop"

Import-Module TeamsAuthentication
Import-Module TeamsAutomation

$clientSecret = $env:AzureAdClientSecret
$applicationId = $env:AzureAdClientId
$tenantId = $env:AzureAdTenantId

$graphToken, $teamsToken = Get-TeamsAccessTokens -ApplicationId $applicationId `
  -ClientSecret $clientSecret `
  -TenantId $tenantId

New-TeamsItems -GraphToken $graphToken `
  -TeamsToken $teamsToken `
  -UserPrincipalName $serviceBusProvisionTeamsDiDMessage.UserPrincipalName `
  -TeamName $serviceBusProvisionTeamsDiDMessage.TeamName `
  -ChannelName $serviceBusProvisionTeamsDiDMessage.ChannelName