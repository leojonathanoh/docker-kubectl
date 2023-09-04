# This script is to update versions in version.json, and create PR(s) for each bumped version
# It may be run manually or as a cron
[CmdletBinding()]
param (
    [Parameter(HelpMessage="Whether to perform a dry run (skip writing versions.json)")]
    [switch]$DryRun
,
    [Parameter(HelpMessage="Whether to open a PR for each updated version in version.json")]
    [switch]$PR=$true
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# Install modules
@(
    'Generate-DockerImageVariantsHelpers'
    'Powershell-Yaml'
) | % {
    if (! (Get-InstalledModule $_) ) {
        Install-Module $_ -Scope CurrentUser -Force
    }
}

Import-Module ../../theohbrothers/Generate-DockerImageVariantsHelpers/src/Generate-DockerImageVariantsHelpers -Force

$y = (Invoke-WebRequest https://raw.githubusercontent.com/kubernetes/website/main/data/releases/schedule.yaml).Content | ConvertFrom-Yaml
$versionsNew = @( $y.schedules | % { $_.previousPatches[0].release } )
$versionsChanged = Get-VersionsChanged -Versions (Get-DockerImageVariantsVersions) -VersionsNew ($versionsNew + '1.30.0') -AsObject -Descending
Update-DockerImageVariantsVersions -VersionsChanged $versionsChanged -PR:$PR

$y = (Invoke-WebRequest https://raw.githubusercontent.com/kubernetes/website/main/data/releases/eol.yaml).Content | ConvertFrom-Yaml
$versionsNew = @( $y.branches | % { $_.finalPatchRelease } )
$versionsChanged = Get-VersionsChanged -Versions (Get-DockerImageVariantsVersions) -VersionsNew $versionsNew -AsObject -Descending
Update-DockerImageVariantsVersions -VersionsChanged $versionsChanged -PR:$PR
