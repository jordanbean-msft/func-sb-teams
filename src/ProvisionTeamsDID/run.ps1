param([System.Collections.Hashtable] $message, $TriggerMetadata)

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
  -UserPrincipalName $message.UserPrincipalName `
  -TeamName $message.TeamName `
  -ChannelName $message.ChannelName