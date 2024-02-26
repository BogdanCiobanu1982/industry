<#
    PowerShell script to bootstrap/configure Power Platform from the North Star Reference Implementation. (aka.ms/ppnorthstar)
    Note: The script is designed and optimized to run as a deploymentScript invoked from Azure Resource Manager.
    Refer to https://github.com/microsoft/industry/blob/main/foundations/powerPlatform/referenceImplementation/auxiliary/powerPlatform/ppDeploymentScript.json for details around the input parameters.
#>
[CmdletBinding()]
param (
    #Security, govarnance and compliance
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPGuestMakerSetting,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPAppSharingSetting,
    #Admin environment and settings
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPEnvCreationSetting,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPTrialEnvCreationSetting,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPEnvCapacitySetting,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPTenantIsolationSetting,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPTenantDLP,   
    #Landing Zones
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPDefaultRenameText,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPDefaultDLP,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPDefaultManagedEnv,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPDefaultManagedSharing,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPCitizen,    
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPCitizenNaming,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPCitizenRegion,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPCitizenDlp,    
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPCitizenManagedEnv,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPCitizenAlm,    
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPCitizenCurrency,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$PPCitizenLanguage,     
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$ppD365SalesApp,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$ppD365CustomerServiceApp,
    [Parameter(Mandatory = $false)][string][AllowEmptyString()][AllowNull()]$ppD365FieldServiceApp        
)

$DeploymentScriptOutputs = @{}
#Install required modules
Install-Module -Name PowerOps -AllowPrerelease -Force   

#Default ALM environment tiers
$envTiers = 'dev','test','prod','admin'

$Global:envAdminName = ''

#region supporting functions
function New-EnvironmentCreationObject {
    param (             
        [Parameter(Mandatory = $true, ParameterSetName = 'EnvCount')]$EnvNaming,
        [Parameter(Mandatory = $true, ParameterSetName = 'EnvCount')]$EnvRegion,
        [Parameter(Mandatory = $true, ParameterSetName = 'EnvCount')]$EnvLanguage,
        [Parameter(Mandatory = $true, ParameterSetName = 'EnvCount')]$EnvCurrency,
        [Parameter(Mandatory = $true, ParameterSetName = 'EnvCount')]$EnvDescription,
        [Parameter(Mandatory = $false)][switch]$EnvALM,
        [Parameter(Mandatory = $false, ParameterSetName = 'EnvCount')][switch]$EnvDataverse
    )
                
    $environmentName = $EnvNaming
    $securityGroupId = ''      
    $envSku = 'Sandbox'                 
    if ($true -eq $EnvALM) {                
        foreach ($envTier in $envTiers) {                 
            if($envTier -eq 'dev'){                                          
                $createdSecurityGroup = New-CreateSecurityGroup -EnvironmentType dev                                    
                $securityGroupId = $createdSecurityGroup
                $envSku = 'Sandbox'  
                $envDescription = 'Environment used for development purposes'
            }
            if ( $envTier -eq 'test' ){
                $createdSecurityGroup = New-CreateSecurityGroup -EnvironmentType test
                $securityGroupId = $createdSecurityGroup
                $envSku = 'Sandbox'  
                $envDescription = 'Environment used for testing purposes'
            }
            if ( $envTier -eq 'prod' ){
                $createdSecurityGroup = New-CreateSecurityGroup -EnvironmentType prod
                $securityGroupId = $createdSecurityGroup
                $envSku ='Production'      
                $envDescription = 'Environment used for production purposes'               
            }
            if ( $envTier -eq 'admin' ){
                $createdSecurityGroup = New-CreateSecurityGroup -EnvironmentType admin
                $securityGroupId = $createdSecurityGroup                
                $envSku ='Production'
                $envDescription = 'Environment used for administration purposes'     
                $Global:envAdminName =  "{0}-{1}" -f $environmentName, $envTier                   
            }

            [PSCustomObject]@{
                envName        = "{0}-{1}" -f $environmentName, $envTier                        
                envRegion      = $EnvRegion
                envDataverse   = $EnvDataverse
                envLanguage    = $envLanguage
                envCurrency    = $envCurrency
                envDescription = $envDescription
                envRbac        = $securityGroupId
                envSku         = $envSku
            }
        }
    }   
}

function New-CreateSecurityGroup {
    param (      
        [Parameter(Mandatory = $true)][string]$EnvironmentType
    )

        $devSecurityGroup = @{
            description="Security Group used for Power Platform - Development environment"
            displayName="entra_powerplatform_development"
            mailEnabled=$false
            securityEnabled=$true
            mailNickname="PowerPlatformDevelopmentGroup"
           }
        
          $testSecurityGroup = @{
            description="Security Group used for Power Platform - Test environment"
             displayName="entra_powerplatform_test"
            mailEnabled=$false
             securityEnabled=$true
             mailNickname="PowerPlatformTestGroup"
            }
        
            $productionSecurityGroup = @{
            description="Security Group used for Power Platform - Production environment"
             displayName="entra_powerplatform_production"
             mailEnabled=$false
             securityEnabled=$true
             mailNickname="PowerPlatformProductionGroup"
            }
        
            $adminSecurityGroup = @{
             description="Security Group used for Power Platform - Admin environment"
             displayName="entra_powerplatform_admin"
             mailEnabled=$false
             securityEnabled=$true
             mailNickname="PowerPlatformAdminGroup"
            }
        
            $makersM365Group = @{
             description="Microsoft 365 Group used for Power Platform Makers"
             displayName="entra_powerplatform_makers"
             GroupTypes="Unified"
             mailEnabled=$true
             securityEnabled=$true
             mailNickname="Makers"
            }
        
            $usersM365Group = @{
             description="Microsoft 365 Group used for Power Platform Users"
             displayName="entra_powerplatform_users"
             GroupTypes="Unified"
             mailEnabled=$true
             securityEnabled=$true
             mailNickname="Users"
            }
        
           $adminsM365Group = @{
             description="Microsoft 365 Group used for Power Platform Admins"
             displayName="entra_powerplatform_admins"
             GroupTypes="Unified"
             mailEnabled=$true
             securityEnabled=$true
             mailNickname="Admins"
            }
            $Value =''
            # Code Begins
            # Get token to authenticate to Power Platform                       
            #$Token = (Get-AzAccessToken -ResourceUrl " https://graph.microsoft.com/.default").Token            
            
            #Write-Output "Bearer $($tokeny)" #> 
            #$Token = (Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com/v1.0/groups").Token   

            $Token = "eyJ0eXAiOiJKV1QiLCJub25jZSI6IlBFMGFCQzFqQ2RaNklrbjUzdjZZU1lkRVVNVm5YSlFjTS1sTEdlbG0xcGciLCJhbGciOiJSUzI1NiIsIng1dCI6IlhSdmtvOFA3QTNVYVdTblU3Yk05blQwTWpoQSIsImtpZCI6IlhSdmtvOFA3QTNVYVdTblU3Yk05blQwTWpoQSJ9.eyJhdWQiOiJodHRwczovL2dyYXBoLm1pY3Jvc29mdC5jb20iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC84MjBmZjI0Mi1hNzU0LTRlN2EtOWJlOS1kZTdiNTM1MDI1MWYvIiwiaWF0IjoxNzA4OTQyNjAwLCJuYmYiOjE3MDg5NDI2MDAsImV4cCI6MTcwODk0NzM3MCwiYWNjdCI6MCwiYWNyIjoiMSIsImFpbyI6IkFWUUFxLzhXQUFBQXVMVStmVXpiOUtsZm1LWnNyTjR4Yzk3U05BWWp1WVU2UldUUzZ6b1JzRzYxcVM2SVFlaUtZUHBYVHFPQ1M3K01ocUVKMGVWTElpcTdoTzBmTExqMEJuL3UvbXhSaU00cFdLNDBsVmVPR2tVPSIsImFtciI6WyJwd2QiLCJtZmEiXSwiYXBwX2Rpc3BsYXluYW1lIjoiUG9zdG1hbiIsImFwcGlkIjoiNjZkYzllZTktZTMyZi00ZWNlLTliMTktNjA4YjNhMGY0YjZkIiwiYXBwaWRhY3IiOiIxIiwiaWR0eXAiOiJ1c2VyIiwiaXBhZGRyIjoiODIuNS4xODEuMzUiLCJuYW1lIjoiQm9nZGFuIENpb2JhbnUiLCJvaWQiOiJhOTI2N2JmMS03ZDlhLTRmYjgtOTM5ZC01NWM2M2JiMmU5M2MiLCJwbGF0ZiI6IjMiLCJwdWlkIjoiMTAwMzIwMDMxRjE2MEE1QiIsInJoIjoiMC5BUXdBUXZJUGdsU25lazZiNmQ1N1UxQWxId01BQUFBQUFBQUF3QUFBQUFBQUFBQU1BTEEuIiwic2NwIjoiRGlyZWN0b3J5LkFjY2Vzc0FzVXNlci5BbGwgRGlyZWN0b3J5LlJlYWQuQWxsIERpcmVjdG9yeS5SZWFkV3JpdGUuQWxsIERpcmVjdG9yeS5Xcml0ZS5SZXN0cmljdGVkIEdyb3VwLlJlYWQuQWxsIEdyb3VwLlJlYWRXcml0ZS5BbGwgTWFpbC5SZWFkIE1haWwuUmVhZC5TaGFyZWQgTWFpbC5SZWFkQmFzaWMgTWFpbC5SZWFkQmFzaWMuU2hhcmVkIE1haWwuUmVhZFdyaXRlIE1haWwuUmVhZFdyaXRlLlNoYXJlZCBNYWlsLlNlbmQgTWFpbC5TZW5kLlNoYXJlZCBVc2VyLkVuYWJsZURpc2FibGVBY2NvdW50LkFsbCBVc2VyLkV4cG9ydC5BbGwgVXNlci5JbnZpdGUuQWxsIFVzZXIuTWFuYWdlSWRlbnRpdGllcy5BbGwgVXNlci5SZWFkIFVzZXIuUmVhZC5BbGwgVXNlci5SZWFkQmFzaWMuQWxsIFVzZXIuUmVhZFdyaXRlIFVzZXIuUmVhZFdyaXRlLkFsbCBwcm9maWxlIG9wZW5pZCBlbWFpbCIsInNpZ25pbl9zdGF0ZSI6WyJrbXNpIl0sInN1YiI6IjRkMW1qcEhlUkp1cXYxWVRqUk1sekdwQmdQWjRRbTBIS214bXB4YWFPdTQiLCJ0ZW5hbnRfcmVnaW9uX3Njb3BlIjoiRVUiLCJ0aWQiOiI4MjBmZjI0Mi1hNzU0LTRlN2EtOWJlOS1kZTdiNTM1MDI1MWYiLCJ1bmlxdWVfbmFtZSI6ImJvZ2Rhbi5jaW9iYW51QGFuc2NvZW91dGxvb2sub25taWNyb3NvZnQuY29tIiwidXBuIjoiYm9nZGFuLmNpb2JhbnVAYW5zY29lb3V0bG9vay5vbm1pY3Jvc29mdC5jb20iLCJ1dGkiOiJ5OWZaTFJyYmNrbTYwVzlkT2t0WkFBIiwidmVyIjoiMS4wIiwid2lkcyI6WyI2MmU5MDM5NC02OWY1LTQyMzctOTE5MC0wMTIxNzcxNDVlMTAiLCJiNzlmYmY0ZC0zZWY5LTQ2ODktODE0My03NmIxOTRlODU1MDkiXSwieG1zX3N0Ijp7InN1YiI6InRlRk05X25YcXBZekprTHYxUThNMmtKWGM1cmtJZkVJQnQ2TURMelhSMGcifSwieG1zX3RjZHQiOjE2MjY0MjQzMzF9.J6pWokaAxh-o0sn_WUCn-3YylOSzFrZ9nv7HMaTSBZLvoWyQlVlSSWTlTRSlm0yWsFRBDOcHX_F7W9nm3rA9zV0oYn_V7Px1gJeuKDKAj1FRcFUltUqV4I-DV9d1vvN_w4PyJgLTWOY2zhujcM7bV-AQgijDkn036kk5CNJnEYZSxD11FaypWBRPa6d4hL6J1xiWIs8PIW8mzDqAP6GvULc5mIKf7ASp67rOjCOW0mABZX-8nsDys0Gc8dTcWyY6KcNzSLlbcikULIhBiN-UTjV5oFEhUtvyw6EqKF_AJvzmflvylpZwtedXoj2Xf39vstT6E3ifJgTbCqh9Hh5P7A"
        
            # Power Platform HTTP Post Group Uri
            $PostGroups = 'https://graph.microsoft.com/v1.0/groups'
            
            # Declare Rest headers
            $Headers = @{
                "Content-Type"  = "application/json"
                "Authorization" = "Bearer $($Token)"
            }
           # Declaring the HTTP Post request
            $PostBody = @{             
            }
            if ($EnvironmentType -eq "dev") {          
                $PostBody = $devSecurityGroup   
            }
           elseif ($EnvironmentType -eq "test") {          
                $PostBody = $testSecurityGroup   
            }
            elseif ($EnvironmentType -eq "prod") {          
                $PostBody = $productionSecurityGroup   
            }
            elseif ($EnvironmentType -eq "admin") {          
                $PostBody = $adminSecurityGroup   
            }           
        
            $PostParameters = @{
                "Uri"         = "$($PostGroups)"
                "Method"      = "Post"
                "Headers"     = $headers
                "Body"        = $postBody | ConvertTo-json -Depth 100
                "ContentType" = "application/json"
            }        
            
            try {
                $response = Invoke-RestMethod @PostParameters               
                $Value  = $response.id                                
            }
            catch {            
                Write-Error "AccessToken- $($Token) failed`r`n$_"
                throw "REST API call failed drastically"
            }  

            return $Value
}

function New-CreateM365Groups {        
    
    $m365Tiers = 'makers','users','admins'

    $makersM365Group = @{
        description="Microsoft 365 Group used for Power Platform Makers"
        displayName="entra_powerplatform_makers"
        groupTypes=@{"Unified"}        
        mailEnabled=$true
        securityEnabled=$true
        mailNickname="Makers"
    }

    $usersM365Group = @{
        description="Microsoft 365 Group used for Power Platform Users"
        displayName="entra_powerplatform_users"
        groupTypes=@{"Unified"}
        mailEnabled=$true
        securityEnabled=$true
        mailNickname="Users"
    }

    $adminsM365Group = @{
        description="Microsoft 365 Group used for Power Platform Admins"
        displayName="entra_powerplatform_admins"
        groupTypes=@{"Unified"}
        mailEnabled=$true
        securityEnabled=$true
        mailNickname="Admins"
    }
    
    # Code Begins
    # Get token to authenticate to Power Platform                       
    #$Token = (Get-AzAccessToken -ResourceUrl " https://graph.microsoft.com/.default").Token            
    
    #Write-Output "Bearer $($tokeny)" #> 
    #$Token = (Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com/v1.0/groups").Token   

    $Token = "eyJ0eXAiOiJKV1QiLCJub25jZSI6Il9obTJfS3NqQ0xPSWRvYVZwUVJEUTA0SjFNWlVmZENsZ2NXVnpsNGhjN2ciLCJhbGciOiJSUzI1NiIsIng1dCI6IlhSdmtvOFA3QTNVYVdTblU3Yk05blQwTWpoQSIsImtpZCI6IlhSdmtvOFA3QTNVYVdTblU3Yk05blQwTWpoQSJ9.eyJhdWQiOiJodHRwczovL2dyYXBoLm1pY3Jvc29mdC5jb20iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC84MjBmZjI0Mi1hNzU0LTRlN2EtOWJlOS1kZTdiNTM1MDI1MWYvIiwiaWF0IjoxNzA4OTQ4OTU2LCJuYmYiOjE3MDg5NDg5NTYsImV4cCI6MTcwODk1MzY4NywiYWNjdCI6MCwiYWNyIjoiMSIsImFpbyI6IkFWUUFxLzhXQUFBQVYvd1A0dnAyV0tJNDl1L1BJYWlKZW9CTVBOS2JkMXdnZ1JnK3J1TVVKakV6RUhFUG1hd3F5dFNUMXNlcHdYVXUvRUtWazBOYXdpWWNvNUFld1pkTWhMMExJZGZHL2R6Z0pudHFSVmMwK0xrPSIsImFtciI6WyJwd2QiLCJtZmEiXSwiYXBwX2Rpc3BsYXluYW1lIjoiUG9zdG1hbiIsImFwcGlkIjoiNjZkYzllZTktZTMyZi00ZWNlLTliMTktNjA4YjNhMGY0YjZkIiwiYXBwaWRhY3IiOiIxIiwiaWR0eXAiOiJ1c2VyIiwiaXBhZGRyIjoiODIuNS4xODEuMzUiLCJuYW1lIjoiQm9nZGFuIENpb2JhbnUiLCJvaWQiOiJhOTI2N2JmMS03ZDlhLTRmYjgtOTM5ZC01NWM2M2JiMmU5M2MiLCJwbGF0ZiI6IjMiLCJwdWlkIjoiMTAwMzIwMDMxRjE2MEE1QiIsInJoIjoiMC5BUXdBUXZJUGdsU25lazZiNmQ1N1UxQWxId01BQUFBQUFBQUF3QUFBQUFBQUFBQU1BTEEuIiwic2NwIjoiRGlyZWN0b3J5LkFjY2Vzc0FzVXNlci5BbGwgRGlyZWN0b3J5LlJlYWQuQWxsIERpcmVjdG9yeS5SZWFkV3JpdGUuQWxsIERpcmVjdG9yeS5Xcml0ZS5SZXN0cmljdGVkIEdyb3VwLlJlYWQuQWxsIEdyb3VwLlJlYWRXcml0ZS5BbGwgTWFpbC5SZWFkIE1haWwuUmVhZC5TaGFyZWQgTWFpbC5SZWFkQmFzaWMgTWFpbC5SZWFkQmFzaWMuU2hhcmVkIE1haWwuUmVhZFdyaXRlIE1haWwuUmVhZFdyaXRlLlNoYXJlZCBNYWlsLlNlbmQgTWFpbC5TZW5kLlNoYXJlZCBVc2VyLkVuYWJsZURpc2FibGVBY2NvdW50LkFsbCBVc2VyLkV4cG9ydC5BbGwgVXNlci5JbnZpdGUuQWxsIFVzZXIuTWFuYWdlSWRlbnRpdGllcy5BbGwgVXNlci5SZWFkIFVzZXIuUmVhZC5BbGwgVXNlci5SZWFkQmFzaWMuQWxsIFVzZXIuUmVhZFdyaXRlIFVzZXIuUmVhZFdyaXRlLkFsbCBwcm9maWxlIG9wZW5pZCBlbWFpbCIsInNpZ25pbl9zdGF0ZSI6WyJrbXNpIl0sInN1YiI6IjRkMW1qcEhlUkp1cXYxWVRqUk1sekdwQmdQWjRRbTBIS214bXB4YWFPdTQiLCJ0ZW5hbnRfcmVnaW9uX3Njb3BlIjoiRVUiLCJ0aWQiOiI4MjBmZjI0Mi1hNzU0LTRlN2EtOWJlOS1kZTdiNTM1MDI1MWYiLCJ1bmlxdWVfbmFtZSI6ImJvZ2Rhbi5jaW9iYW51QGFuc2NvZW91dGxvb2sub25taWNyb3NvZnQuY29tIiwidXBuIjoiYm9nZGFuLmNpb2JhbnVAYW5zY29lb3V0bG9vay5vbm1pY3Jvc29mdC5jb20iLCJ1dGkiOiJlb2Nyc21CckowQ241NkVHZVlsTkFBIiwidmVyIjoiMS4wIiwid2lkcyI6WyI2MmU5MDM5NC02OWY1LTQyMzctOTE5MC0wMTIxNzcxNDVlMTAiLCJiNzlmYmY0ZC0zZWY5LTQ2ODktODE0My03NmIxOTRlODU1MDkiXSwieG1zX3N0Ijp7InN1YiI6InRlRk05X25YcXBZekprTHYxUThNMmtKWGM1cmtJZkVJQnQ2TURMelhSMGcifSwieG1zX3RjZHQiOjE2MjY0MjQzMzF9.bc0moHMg9liHTzwjXCJB4Wlf-HQgg0nkACkmFRSI2KTG3k-TBKUD1oekuVkz-yu05Vk5jMAEeBevnJaeA4ajd8DukrKX619O2Qe4e9ferglz2uSCN-JZpxY4wI-9V6zntuYd7KRwuS5oqzTea1qV33TY3x9PHm0nX5eN9m_kwck1zBXN6jlUwHuOYiNjbpxbJ0hs4pfF2nTl5h8tU67s7ooyn7tOLEnzqe7zqDfmTY0dnrmnHSy2_3k6yNZl3V0yi-4OhmHy8-LBC8T5pmHrQuhfat_TYCWcZuN3rvl-MdeGFG9oK3J4tPVXW4_c3tBqplGzLoqm01g8Cn6GboON5w"

    # Power Platform HTTP Post Group Uri
    $PostGroups = 'https://graph.microsoft.com/v1.0/groups'
    
    # Declare Rest headers
    $Headers = @{
        "Content-Type"  = "application/json"
        "Authorization" = "Bearer $($Token)"
    }
    
    # Declaring the HTTP Post request    
    foreach ($m365Tier in $m365Tiers) 
    {                 
        if($m365Tier -eq 'makers')
        {
            $PostBody = $makersM365Group
        }        
        elseif($m365Tier -eq 'users')
        {
            $PostBody = $usersM365Group
        }
        elseif($m365Tier -eq 'admins')
        {
            $PostBody = $adminsM365Group
        }                           

        $PostParameters = @{
            "Uri"         = "$($PostGroups)"
            "Method"      = "Post"
            "Headers"     = $headers
            "Body"        = $postBody | ConvertTo-json -Depth 100
            "ContentType" = "application/json"
        }        
        
        try {
            $response = Invoke-RestMethod @PostParameters                                                      
        }
        catch {            
            Write-Error "AccessToken- $($Token) failed`r`n$_"
            throw "REST API call failed drastically"
        }   
    }           
}

function New-InstallPackaggeToEnvironment {
    param (      
        [Parameter(Mandatory = $true)][string]$EnvironmentId,
        [Parameter(Mandatory = $true)][string]$PackageName
    ) 
        # Code Begins
        # Get token to authenticate to Power Platform
        $TokenGraph = (Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com/").Token
        
        $Token = (Get-AzAccessToken -ResourceUrl "https://api.powerplatform.com/").Token
        # Power Platform HTTP Post Environment Uri
        $PostEnvironment = "https://api.powerplatform.com/appmanagement/environments/$($EnvironmentId)/applicationPackages/$($PackageName)/install?api-version=2022-03-01-preview"           
        
        # Declare Rest headers
        $Headers = @{
            "Content-Type"  = "application/json"
            "Authorization" = "Bearer $($Token)"
        }
        # Declaring the HTTP Post request
        $PostParameters = @{
            "Uri"         = "$($PostEnvironment)"
            "Method"      = "Post"
            "Headers"     = $headers
            "ContentType" = "application/json"
        }  
        try {
            Invoke-RestMethod @PostParameters  
            Write-Output "Application Installation $($PackageName) in progress"
        }
        catch {            
            Write-Error "$($PackageName) Installation EnvironmentId $($EnvironmentId) failed`r`n$_"               
        }          
}

function New-DLPAssignmentFromEnv {
    param (
        [Parameter(Mandatory = $true)][string[]]$Environments,
        [Parameter(Mandatory = $true)][string]$EnvironmentDLP
    )
    #DLP Template references
    $dlpPolicies = @{
        baseUri          = 'https://raw.githubusercontent.com/HemantKumar10/landingzones/main/foundations/powerPlatform/referenceImplementation/auxiliary/powerPlatform/'
        tenant           = @{
            low    = 'lowTenantDlpPolicy.json'
            medium = 'mediumTenantDlpPolicy.json'
            high   = 'highTenantDlpPolicy.json'
        }
        defaultEnv       = 'defaultEnvDlpPolicy.json'
        adminEnv         = 'adminEnvDlpPolicy.json'
        citizenDlpPolicy = 'citizenDlpPolicy.json'
        proDlpPolicy     = 'proDlpPolicy.json'
    }

    # Get base template from repo
    $templateFile = if ($EnvironmentDLP -in 'low', 'medium', 'high') { $dlpPolicies['tenant'].$EnvironmentDLP } else { $dlpPolicies["$EnvironmentDLP"] }
    if ([string]::IsNullOrEmpty($templateFile)) {
        throw "Cannot find DLP template $EnvironmentDLP"
    }
    try {
        $template = (Invoke-WebRequest -Uri ($dlpPolicies['BaseUri'] + $templateFile)).Content | ConvertFrom-Json -Depth 100
        Write-Output "Using base DLP template $templatefile"
    }
    catch {
        throw "Failed to get template $templatefile from $($dlpPolicies['baseUri'])"
    }

    # Handle environment inclusion
    if (($Environments -contains 'AllEnvironments' -and $Environments.count -gt 1) -or ($Environments -ne 'AllEnvironments')) {
        $environmentsToIncludeorExclude = $Environments | Where-Object { $_ -notlike 'AllEnvironments' } | ForEach-Object -Process {
            $envDisplayName = $_
            $envDetails = ''
            $envDetails = Get-PowerOpsEnvironment | Where-Object { $_.properties.displayName -eq $envDisplayName }
            [PSCustomObject]@{
                id   = $envDetails.id
                name = $envDetails.name
                type = 'Microsoft.BusinessAppPlatform/scopes/environments'
            }
        }
        if ($environmentsToIncludeorExclude.count -eq 1) {
            $template.environments | Add-Member -Type NoteProperty -Name id -Value $environmentsToIncludeorExclude.id -Force
            $template.environments | Add-Member -Type NoteProperty -Name name -Value $environmentsToIncludeorExclude.name -Force
        }
        else {
            $template.environments = $environmentsToIncludeorExclude
        }
        if ($Environments -contains 'AllEnvironments') {
            $template.environmentType = 'ExceptEnvironments'
        }
        else {
            $template.environmentType = 'OnlyEnvironments'
        }
    }
    # Convert template back to json and
    $template | ConvertTo-Json -Depth 100 -EnumsAsStrings | Set-Content -Path $templateFile -Force
    try {
        $null = New-PowerOpsDLPPolicy -TemplateFile $templateFile -Name $template.displayName -ErrorAction Stop
        Write-Output "Created Default $EnvironmentDLP DLP Policy"
    }
    catch {
        Write-Warning "Created Default $EnvironmentDLP DLP Policy`r`n$_"
    }
}

#endregion supporting functions

#region set tenant settings
# Only change tenant settings if "Setting" parameters have been provided
if ($PSBoundParameters.Keys -match "Setting") {
    # Get existing tenant settings
    #TODO - add condition so script can be used without changing tenant settings
    $existingTenantSettings = Get-PowerOpsTenantSettings
    # Update tenant settings
    $tenantSettings = $existingTenantSettings
    $tenantSettings.disableTrialEnvironmentCreationByNonAdminUsers = $PPTrialEnvCreationSetting -eq 'Yes'
    $tenantSettings.powerPlatform.powerApps.enableGuestsToMake = $PPGuestMakerSetting -eq 'No'
    $tenantSettings.powerPlatform.powerApps.disableShareWithEveryone = $PPAppSharingSetting -eq 'Yes'
    $tenantSettings.disableEnvironmentCreationByNonAdminUsers = $PPEnvCreationSetting -eq 'Yes'
    $tenantSettings.disableCapacityAllocationByEnvironmentAdmins = $PPEnvCapacitySetting -eq 'Yes'

    # Update tenant settings

    try {
        $tenantRequest = @{
            Path        = '/providers/Microsoft.BusinessAppPlatform/scopes/admin/updateTenantSettings'
            Method      = 'Post'
            RequestBody = ($tenantSettings | ConvertTo-Json -Depth 100)
        }
        $null = Invoke-PowerOpsRequest @tenantRequest
        Write-Output "Updated tenant settings"
    }
    catch {
        throw "Failed to set tenant settings"
    }
}

# Tenant Isolation settings
if ($PPTenantIsolationSetting -in 'inbound', 'outbound', 'both') {
    $tenantIsolationSettings = @{
        Enabled = $true
    }
            
    if ($PPTenantIsolationSetting -eq 'both') {
        $tenantIsolationSettings.AllowedDirection = 'InboundAndOutbound'
    }
    else {
        $tenantIsolationSettings.AllowedDirection = $PPTenantIsolationSetting
    }    

    try {
        Set-PowerOpsTenantIsolation @tenantIsolationSettings
        Write-Output "Updated tenant isolation settings with $PPTenantIsolationSetting"
    }
    catch {
        throw "Failed to update tenant isolation settings"
    }
}
#endregion set tenant settings

#region default environment
# Get default environment
# Retry logic to handle green field deployments
$defaultEnvAttempts = 0
do {
    $defaultEnvAttempts++
    $defaultEnvironment = Get-PowerOpsEnvironment | Where-Object { $_.Properties.environmentSku -eq "Default" }
    if (-not ($defaultEnvironment)) {
        Write-Output "Getting default environment - attempt $defaultEnvAttempts"
        Start-Sleep -Seconds 15
    }
} until ($defaultEnvironment -or $defaultEnvAttempts -eq 15)

# Rename default environment if parameter provided
if (-not [string]::IsNullOrEmpty($PPDefaultRenameText)) {
    # Get old default environment name
    $oldDefaultName = $defaultEnvironment.properties.displayName
    if ($PPDefaultRenameText -ne $oldDefaultName) {
        $defaultEnvironment.properties.displayName = $PPDefaultRenameText
        $defaultEnvRequest = @{
            Path        = '/providers/Microsoft.BusinessAppPlatform/scopes/admin/environments/{0}' -f $defaultEnvironment.name
            Method      = 'Patch'
            RequestBody = ($defaultEnvironment | ConvertTo-Json -Depth 100)
        }
        try {
            Invoke-PowerOpsRequest @defaultEnvRequest
            Write-Output "Renamed default environment from $oldDefaultName to $PPDefaultRenameText"
        }
        catch {
            Write-Warning "Failed to rename Default Environment`r`n$_"
        }
    }
}
# Create DLP policy for default environment
if ($PPDefaultDLP -eq 'Yes') {
    # Get default recommended DLP policy from repo
    try {
        New-DLPAssignmentFromEnv -Environments $defaultEnvironment.properties.displayName -EnvironmentDLP 'defaultEnv'
    }
    catch {
        Write-Warning "Failed to create Default Environment DLP Policy`r`n$_"
    }
}
# Enable managed environment for default environment
if ($defaultEnvironment.properties.governanceConfiguration.protectionLevel -ne 'Standard' -and $PPDefaultManagedEnv -eq 'Yes') {
    try {
        Write-Output "Enabling managed environment for the default environment"
        Enable-PowerOpsManagedEnvironment -EnvironmentName $defaultEnvironment.name -GroupSharingDisabled ($PPDefaultManagedSharing -eq 'Yes')
    }
    catch {
        Write-Warning "Failed to enable managed environment for default environment"
    }
}
#endregion default environment

#region create M365 Groups 
#$createdM365Groups = New-CreateM365Groups
#endregion create M365 Groups 

#region create landing zones for citizen devs
if ($PPCitizen -in "yes") 
{   
    try {
        $envHt = @{            
            EnvNaming       = $PPCitizenNaming
            EnvRegion       = $PPCitizenRegion
            envLanguage     = $PPCitizenLanguage
            envCurrency     = $PPCitizenCurrency
            envDescription  = ''
            EnvALM          = $PPCitizenAlm -eq 'Yes'
            EnvDataverse    = $PPCitizen -eq 'Yes'            
        }
        $environmentsToCreate = New-EnvironmentCreationObject @envHt
    }
    catch {
        throw "Failed to create environment object. Input data is malformed. '`r`n$_'"
    }
    
    foreach ($environment in $environmentsToCreate) 
    {             
        try {
            $envCreationHt = @{
                Name               = $environment.envName
                Description        = $environment.envDescription
                Location           = $environment.envRegion
                Dataverse          = $true
                ManagedEnvironment = $PPCitizenManagedEnv -eq 'Yes'                
                LanguageName       = $environment.envLanguage
                Currency           = $environment.envCurrency
                SecurityGroupId    = $environment.envRbac
                EnvSku             = $environment.envSKu                                           
            }  

            Write-Output "Create Environment: $($envCreationHt.Name)" 
                       
            # Code Begins
            # Get token to authenticate to Power Platform
            $Token = (Get-AzAccessToken).Token            
            
            # Power Platform API base Uri
            $BaseUri = "https://api.bap.microsoft.com"            
            
            # Power Plaform HTTP Get Environment Uri
            $GetEnvironment = '/providers/Microsoft.BusinessAppPlatform/scopes/admin/environments?$expand=permissions&api-version=2016-11-01'
            
            # Power Platform HTTP Post Environment Uri
            $PostEnvironment = '/providers/Microsoft.BusinessAppPlatform/environments?api-version=2019-05-01&ud=/providers/Microsoft.BusinessAppPlatform/scopes/admin/environments'
                       
            # Declare Rest headers
            $Headers = @{
                "Content-Type"  = "application/json"
                "Authorization" = "Bearer $($Token)"
            }                              
            
            # Form the request body to create new Environments in Power Platform           
            $templates = @()
            if ($ppD365SalesApp -eq 'true' -and $envCreationHt.Name -ne $Global:envAdminName ) {          
                $templates += 'D365_Sales'   
            }
            if ($ppD365CustomerServiceApp -eq 'true' -and $envCreationHt.Name -ne $Global:envAdminName ) {          
                $templates += 'D365_CustomerService'   
            }
            if ($ppD365FieldServiceApp -eq 'true' -and $envCreationHt.Name -ne $Global:envAdminName ) { 
                $templates += 'D365_FieldService'   
            }           
            
        # Declaring the HTTP Post request
            $PostBody = @{
                "properties" = @{
                    "linkedEnvironmentMetadata" = @{
                        "baseLanguage" = "$($envCreationHt.LanguageName)"
                        "domainName"   = "$($envCreationHt.Name)"
                        "templates"    =  $templates  
                        "securityGroupId" = "$($environment.envRbac)"
                    }
                    "databaseType"   = "CommonDataService"
                    "displayName"    = "$($envCreationHt.Name)"
                    "description"    = "$($envCreationHt.Description)"
                    "environmentSku" = "$($envCreationHt.EnvSku)"                                        
                }
                "location"          = "$($environment.envRegion)"                
            }
        
            $PostParameters = @{
                "Uri"         = "$($baseUri)$($postEnvironment)"
                "Method"      = "Post"
                "Headers"     = $headers
                "Body"        = $postBody | ConvertTo-json -Depth 100
                "ContentType" = "application/json"
            }            
        
            try {
                $response = Invoke-RestMethod @PostParameters                               
            }
            catch {
                Write-Error "Creation of citizen Environment $($envCreationHt.Name) failed`r`n$_"
                throw "REST API call failed drastically"
            }                                                       
        }
        catch {
            Write-Warning "Failed to create citizen environment $($environment.envName)"
            Write-Output "Failed to create environment citizen.'`r`n$_'"  
        }
    }
    if ($PPCitizenDlp -eq "Yes") {
        New-DLPAssignmentFromEnv -Environments $environmentsToCreate.envName -EnvironmentDLP 'citizenDlpPolicy'
    }

    #region Install Power Platform Pipeline App in Admin Envrionemnt        
    Start-Sleep -Seconds 60           
    foreach ($envTier in $envTiers) 
    {
        if($envTier -eq 'dev')
        {
            try {          
                    $adminEnvironment = Get-PowerOpsEnvironment | Where-Object { $_.Properties.displayName -eq $envAdminName }
                    New-InstallPackaggeToEnvironment -EnvironmentId $($adminEnvironment.name) -PackageName 'msdyn_AppDeploymentAnchor'
            }
            catch {
                Write-Warning "Error installing App`r`n$_"
            }
        }
    }    
    #endregion Install Power Platform Pipeline App in Admin Envrionemnt   
}
#endregion create landing zones for citizen devs

$DeploymentScriptOutputs['Deployment'] = 'Successful'
