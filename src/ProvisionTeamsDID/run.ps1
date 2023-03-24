param([object] $serviceBusProvisionTeamsDiDMessage, $TriggerMetadata)

$ErrorActionPreference = "Stop"

Write-Information $serviceBusProvisionTeamsDiDMessage.UserPrincipalName
Write-Information $serviceBusProvisionTeamsDiDMessage.TeamName
Write-Information $serviceBusProvisionTeamsDiDMessage.ChannelName

$clientSecret = $env:AzureAdClientSecret
$applicationId = $env:AzureAdClientId
$tenantId = $env:AzureAdTenantId

$graphTokenBody = @{   
  Grant_Type    = "client_credentials"   
  Scope         = "https://graph.microsoft.com/.default"   
  Client_Id     = $applicationId
  Client_Secret = $clientSecret   
}

Write-Information "Retriving Graph token..."

$graphToken = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Method POST -Body $graphTokenBody | Select-Object -ExpandProperty Access_Token 

$teamsTokenBody = @{   
  Grant_Type    = "client_credentials"   
  Scope         = "48ac35b8-9aa8-4d74-927d-1f4a14a0b239/.default"   
  Client_Id     = $applicationId   
  Client_Secret = $clientSecret 
} 

$teamsToken = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Method POST -Body $teamsTokenBody | Select-Object -ExpandProperty Access_Token

Write-Information "Retrieved Graph token"

Write-Information "Connecting to Microsoft Teams API..."

Connect-MicrosoftTeams -AccessTokens @("$graphToken", "$teamsToken")

Write-Information "Connected to Microsoft Teams API"

Write-Information "Creating team $(${serviceBusProvisionTeamsDiDMessage}.TeamName)..."

$group = New-Team -DisplayName $serviceBusProvisionTeamsDiDMessage.TeamName `
  -Visibility Public `
  -Owner $serviceBusProvisionTeamsDiDMessage.UserPrincipalName

Write-Information "Created team $(${serviceBusProvisionTeamsDiDMessage}.TeamName)"

Write-Information "Adding user $(${serviceBusProvisionTeamsDiDMessage}.UserPrincipalName) as owner..."

Add-TeamUser -GroupId $group.GroupId `
  -User $serviceBusProvisionTeamsDiDMessage.UserPrincipalName `
  -Role Owner

Write-Information "Added user $(${serviceBusProvisionTeamsDiDMessage}.UserPrincipalName) as owner"

Write-Information "Creating channel $(${serviceBusProvisionTeamsDiDMessage}.ChannelName)..."

New-TeamChannel -GroupId $group.GroupId `
  -DisplayName $serviceBusProvisionTeamsDiDMessage.ChannelName

Write-Information "Created channel $(${serviceBusProvisionTeamsDiDMessage}.ChannelName)"