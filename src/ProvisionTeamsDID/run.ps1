param([object] $serviceBusProvisionTeamsDiDMessage, $TriggerMetadata)

$ErrorActionPreference = "Stop"

Import-Module TeamsAuthentication
Import-Module TeamsAutomation

$graphToken, $teamsToken = Get-TeamsAccessTokens

New-TeamsItems -GraphToken $graphToken `
  -TeamsToken $teamsToken `
  -UserPrincipalName $serviceBusProvisionTeamsDiDMessage.UserPrincipalName `
  -TeamName $serviceBusProvisionTeamsDiDMessage.TeamName `
  -ChannelName $serviceBusProvisionTeamsDiDMessage.ChannelName