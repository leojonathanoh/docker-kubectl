# This script is to bump versions and create PR(s) for each bumped version
# It may be run manually or as a cron
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

if (! (Get-Module Powershell-Yaml -ListAvailable) ) {
    Install-Module Powershell-Yaml -Scope CurrentUser -Force
}
Import-Module Powershell-Yaml

if (! (Get-Module Generate-DockerImageVariants -ListAvailable) ) {
    Install-Module Generate-DockerImageVariants -Scope CurrentUser -Force
}
Import-Module Generate-DockerImageVariants

$VERSIONS = Get-Content $PSScriptRoot/generate/definitions/versions.json -Encoding utf8 | ConvertFrom-Json -Depth 100

$y = (Invoke-WebRequest https://raw.githubusercontent.com/kubernetes/website/main/data/releases/eol.yaml).Content | ConvertFrom-Yaml
$VERSIONS_EOL = @( $y.branches | % { $_.finalPatchRelease } )
$y = (Invoke-WebRequest https://raw.githubusercontent.com/kubernetes/website/main/data/releases/schedule.yaml).Content | ConvertFrom-Yaml
$VERSIONS_NEW = @( $y.schedules | % { $_.previousPatches[0].release } )

function Update-Versions ($VERSIONS, $VERSIONS_NEW) {
    for ($i = 0; $i -lt $VERSIONS.Length; $i++) {
        $v = [version]$VERSIONS[$i]
        foreach ($vn in $VERSIONS_NEW) {
            $vn = [version]$vn
            if ($v.Major -eq $vn.Major -and $v.Minor -eq $vn.Minor -and $v.Build -lt $vn.Build) {
                "Updating $v to $vn" | Write-Host -ForegroundColor Green
                if (!(git config --global --get user.name)) {
                    git config --global user.name "The Oh Brothers Bot"
                }
                if (!(git config --global --get user.email)) {
                    git config --global user.email "bot@theohbrothers.com"
                }
                git checkout -f master
                $VERSIONS[$i] = $vn.ToString()
                $VERSIONS | ConvertTo-Json -Depth 100 | Set-Content $PSScriptRoot/generate/definitions/versions.json -Encoding utf8
                Generate-DockerImageVariants .
                $BRANCH = "enhancement/bump-v$( $v.Major ).$( $v.Minor )-variants-to-$( $vn )"
                $COMMIT_MSG = @"
Enhancement: Bump v$( $v.Major ).$( $v.Minor ) variants to $( $vn )

Signed-off-by: $( git config --global user.name ) <$( git config --global --get user.email )>
"@
                git checkout -b $BRANCH
                git add .
                git commit -m $COMMIT_MSG
                git push origin $BRANCH -f

                "Creating PR" | Write-Host -ForegroundColor Green
                $env:GITHUB_TOKEN = if ($env:GITHUB_TOKEN) { $env:GITHUB_TOKEN } else { (Get-Content ~/.git-credentials -Encoding utf8 -Force) -split "`n" | % { if ($_ -match '^https://[^:]+:([^:]+)@github.com') { $matches[1] } } | Select-Object -First 1 }
                # $cmd = "gh pr create --head $BRANCH --title `"$( git log --format=%s -1 )`" --body `"$( git log --format=%b -1 )`" --repo `"theohbrothers/$( (Get-Item $PSScriptRoot/../../ ).Name )`""
                $cmd = "gh pr create --head $BRANCH --fill --repo `"$( git remote get-url origin )`""
                $cmd | Write-Host -ForegroundColor Green
                $cmd | Invoke-Expression
            }
        }
    }
}

Update-Versions $VERSIONS $VERSIONS_EOL
Update-Versions $VERSIONS $VERSIONS_NEW
