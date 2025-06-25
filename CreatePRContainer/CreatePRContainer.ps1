Param(
    [Parameter(HelpMessage = "Container Password", Mandatory = $true)]
    [string] $ContainerName,
    [Parameter(HelpMessage = "Container Username", Mandatory = $false)]
    [string] $ContainerUsername = "traser",
    [Parameter(HelpMessage = "Container Password", Mandatory = $false)]
    [securestring] $ContainerPassword = (ConvertTo-SecureString "Traser2025!" -AsPlainText -Force),
    [Parameter(HelpMessage = "BC License", Mandatory = $true)]
    [string] $BcLicense,
    # [Parameter(HelpMessage = "BC Version", Mandatory = $true)]
    # [string] $BcVersion,
    [Parameter(HelpMessage = "Sources Workspace", Mandatory = $true)]
    [string] $SourcesWorkspace
    # [Parameter(HelpMessage = "NuGet Feeds Token", Mandatory = $true)]
    # [string] $NugetFeedsToken
)   

CreateDevEnv containerName $ContainerName `
    kind local `
    baseFolder $SourcesWorkspace `
    project $SourcesWorkspace `
    auth UserPassword `
    credential (new-object -typename System.Management.Automation.PSCredential -argumentlist $ContainerUsername, $ContainerPassword ) `
    licenseFileUrl $BcLicense `
    accept_insiderEula `
    clean

# function CreateDevEnv {
#     Param(
#         [Parameter(Mandatory = $true)]
#         [ValidateSet('local', 'cloud')]
#         [string] $kind,
#         [ValidateSet('local', 'GitHubActions')]
#         [string] $caller = 'local',
#         [Parameter(Mandatory = $true)]
#         [string] $baseFolder,
#         [string] $repository = "$ENV:GITHUB_REPOSITORY",
#         [string] $project,
#         [string] $userName = $env:Username,

#         [Parameter(ParameterSetName = 'cloud')]
#         [Hashtable] $bcAuthContext = $null,
#         [Parameter(ParameterSetName = 'cloud')]
#         [Hashtable] $adminCenterApiCredentials = @{},
#         [Parameter(Mandatory = $true, ParameterSetName = 'cloud')]
#         [string] $environmentName,
#         [Parameter(ParameterSetName = 'cloud')]
#         [switch] $reuseExistingEnvironment,

#         [Parameter(Mandatory = $true, ParameterSetName = 'local')]
#         [ValidateSet('Windows', 'UserPassword')]
#         [string] $auth,
#         [Parameter(Mandatory = $true, ParameterSetName = 'local')]
#         [pscredential] $credential,
#         [Parameter(ParameterSetName = 'local')]
#         [string] $containerName = "",
#         [string] $licenseFileUrl = "",
#         [switch] $accept_insiderEula,
#         [switch] $clean
#     )


# $containerCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $ContainerUsername, $ContainerPassword
# Set-ALAppVersion -root $SourcesWorkspace -Build 2147483647

# if (Test-BcContainer $ContainerName) {
#     Start-BcContainer $ContainerName
#     foreach ($app in ((Get-BcContainerAppInfo -containerName $ContainerName -tenantSpecificProperties -tenant default -sort DependenciesLast -installedOnly -useNewFormat) | Where-Object { $_.Publisher -eq 'TRASER Software GmbH' }) ) {
#         Uninstall-BcContainerApp -containerName $ContainerName -tenant default -name $app.Name -version $app.Version
#     }
#     Set-BCContainerPassword -containername $ContainerName -credential $containerCredential
# }

# if ('' -ne $BcVersion) {
#         $artifactUrl = (Get-ALArtifactUrl -root $SourcesWorkspace -version "$BcVersion" )
# } else {
#         $artifactUrl = ""
# }

# $parameters = @{
#         containername        = "$ContainerName"
#         credential           = $containerCredential
#         root                 = "$SourcesWorkspace"
#         downloaddependencies = $true
#         releasetype          = "master"
#         licensefile          = "$BcLicense"
#         runContainerUpgrade  = $true
#         includeRelatedApps   = $true
#         useNuGet             = $true
#         nuGetToken           = "$NugetFeedsToken"
#         artifactUrl          = $artifactUrl
#     }

#     Deploy-ToALContainer @parameters