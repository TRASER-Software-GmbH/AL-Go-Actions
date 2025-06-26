Param(
    [Parameter(HelpMessage = "Container Password", Mandatory = $true)]
    [string] $ContainerName,
    [Parameter(HelpMessage = "Container Username", Mandatory = $false)]
    [string] $ContainerUsername = "traser",
    [Parameter(HelpMessage = "Container Password", Mandatory = $false)]
    [securestring] $ContainerPassword = (ConvertTo-SecureString "Traser2025!" -AsPlainText -Force),
    [Parameter(HelpMessage = "BC License", Mandatory = $true)]
    [string] $BcLicense,
    [Parameter(HelpMessage = "BC Version", Mandatory = $true)]
    [string] $BcVersion,
    [Parameter(HelpMessage = "Sources Workspace", Mandatory = $true)]
    [string] $SourcesWorkspace
)   


$containerCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $ContainerUsername, ConvertTo-SecureString "$ContainerPassword" -AsPlainText
Set-ALAppVersion -root $SourcesWorkspace -Build 214748364

if (Test-BcContainer $ContainerName) {
    Start-BcContainer $ContainerName
    foreach ($app in ((Get-BcContainerAppInfo -containerName $ContainerName -tenantSpecificProperties -tenant default -sort DependenciesLast -installedOnly -useNewFormat) | Where-Object { $_.Publisher -eq 'TRASER Software GmbH' }) ) {
        Uninstall-BcContainerApp -containerName $ContainerName -tenant default -name $app.Name -version $app.Version
    }
    Set-BCContainerPassword -containername $ContainerName -credential $containerCredential
}

if ('' -ne $BcVersion) {
        $artifactUrl = (Get-ALArtifactUrl -root $SourcesWorkspace -version "$BcVersion" )
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