$local:VERSIONS = @( Get-Content $PSScriptRoot/versions.json -Encoding utf8 -raw | ConvertFrom-Json )

# Docker image variants' definitions
$local:VARIANTS_MATRIX = @(
    foreach ($v in $local:VERSIONS.kubectl.versions) {
        @{
            package_version = $v
            subvariants = @(
                @{ components = @(); tag_as_latest = if ($v -eq ($local:VERSIONS.kubectl.versions | ? { $_ -match '^\d+\.\d+\.\d+$' } | Select-Object -First 1 )) { $true } else { $false } }
                @{ components = @( 'envsubst', 'git', 'jq', 'kustomize', 'sops', 'ssh', 'yq' ) }
                @{ components = @( 'git', 'pwsh', 'sops' ) }
            )
        }
    }
)
$VARIANTS = @(
    foreach ($variant in $VARIANTS_MATRIX){
        foreach ($subVariant in $variant['subvariants']) {
            @{
                # Metadata object
                _metadata = @{
                    package_version = $variant['package_version']
                    distro = 'alpine'
                    distro_version = '3.24'
                    platforms = if ($subVariant['components'] -contains 'pwsh') {
                        'linux/amd64,linux/arm64'
                    } else {
                        'linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/s390x'
                    }
                    components = $subVariant['components']
                    job_group_key = $variant['package_version']
                }
                # Docker image tag. E.g. '1.28.2' or '1.28.2[-component..]'
                tag = @(
                        $variant['package_version']
                        $subVariant['components'] | ? { $_ }
                ) -join '-'
                tag_as_latest = if ( $subVariant.Contains('tag_as_latest') ) {
                                    $subVariant['tag_as_latest']
                                } else {
                                    $false
                                }
            }
        }
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $true
                includeHeader = $false
                includeFooter = $false
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'docker-entrypoint.sh' = @{
                common = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
        }
    }
}
