Param(
    [Parameter(HelpMessage = "Container Password", Mandatory = $true)]
    [string] $ContainerName,
    [Parameter(HelpMessage = "Container Username", Mandatory = $false)]
    [string] $ContainerUsername = "traser",
    [Parameter(HelpMessage = "Container Password", Mandatory = $false)]
    [string] $ContainerPassword = "Traser2025!",
    [Parameter(HelpMessage = "BC License", Mandatory = $true)]
    [string] $BcLicense,
    [Parameter(HelpMessage = "BC Version", Mandatory = $true)]
    [string] $BcVersion,
    [Parameter(HelpMessage = "Sources Workspace", Mandatory = $true)]
    [string] $SourcesWorkspace
)   

$securePassword = ConvertTo-SecureString $ContainerPassword -AsPlainText -Force
$containerCredential = New-Object System.Management.Automation.PSCredential ($ContainerUsername, $securePassword)

if (Test-BcContainer $ContainerName) {
    Start-BcContainer $ContainerName
    foreach ($app in ((Get-BcContainerAppInfo -containerName $ContainerName -tenantSpecificProperties -tenant default -sort DependenciesLast -installedOnly -useNewFormat) | Where-Object { $_.Publisher -eq 'TRASER Software GmbH' }) ) {
        Uninstall-BcContainerApp -containerName $ContainerName -tenant default -name $app.Name -version $app.Version
    }
    Set-BCContainerPassword -containername $ContainerName -credential $containerCredential
}

if ('' -ne $BcVersion) {
        $artifactUrl = (Get-ALArtifactUrl -root $SourcesWorkspace -version "$BcVersion" -type "Sandbox")
} else {
        $artifactUrl = ""
}

$parameters = @{
        containername        = "$ContainerName"
        credential           = $containerCredential
        root                 = "$SourcesWorkspace"
        downloaddependencies = $true
        releasetype          = "master"
        licensefile          = "$BcLicense"
        runContainerUpgrade  = $true
        includeRelatedApps   = $true
        useNuGet             = $true
        nuGetToken           = $env:NugetFeedsToken
        artifactUrl          = $artifactUrl
}  
Deploy-ToALContainer @parameters