@"
FROM $( $VARIANT['_metadata']['distro'] ):$( $VARIANT['_metadata']['distro_version'] )
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on `$BUILDPLATFORM, building for `$TARGETPLATFORM"

RUN apk add --no-cache ca-certificates

# When `$TARGETPLATFORM is linux/arm/v7, strip out the '/v6' or '/v7' from it
RUN set -eux; \
    BIN_URL=https://dl.k8s.io/release/v$( $VARIANT['_metadata']['package_version'] )/bin/`$( echo `$TARGETPLATFORM | sed 's@/v[67]$@@' )/kubectl; \
    SHA512=`$( wget -qO- "`$BIN_URL.sha512" ); \
    wget -qO- "`$BIN_URL"  > /usr/local/bin/kubectl; \
    chmod +x /usr/local/bin/kubectl; \
    sha512sum /usr/local/bin/kubectl | grep "^`$SHA512 "; \
    kubectl version --client


"@

$VARIANT['_metadata']['components'] | % {
    $component = $_

    switch( $component ) {

        'envsubst' {
            @'
RUN apk add --no-cache gettext-envsubst


'@
        }

        'git' {
            @'
RUN apk add --no-cache git


'@
        }

        'jq' {
            @'
RUN apk add --no-cache jq


'@
        }

        'kustomize' {
            @"
RUN apk add --no-cache curl \
    && curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/v2.0.3/kustomize_2.0.3_linux_amd64 -o /usr/local/bin/kustomize \
    && chmod +x /usr/local/bin/kustomize \
    && apk del curl


"@
        }

        'pwsh' {
            @"
# Disable telemetry for powershell 7.0.0 and above and .NET core: https://github.com/PowerShell/PowerShell/issues/16234#issuecomment-942139350
ENV POWERSHELL_CLI_TELEMETRY_OPTOUT=1
ENV POWERSHELL_TELEMETRY_OPTOUT=1
ENV POWERSHELL_UPDATECHECK=Off
ENV POWERSHELL_UPDATECHECK_OPTOUT=1
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV DOTNET_TELEMETRY_OPTOUT=1
ENV COMPlus_EnableDiagnostics=0

# Install powershell
RUN set -eux; \
    apk add --no-cache powershell; \
    pwsh --version

# Install powershell modules
RUN set -eux; \
    pwsh -c 'Install-Module Pester -Scope AllUsers -MinimumVersion 4.10.1 -MaximumVersion 4.10.1 -Force -ErrorAction Stop -Verbose'; \
    pwsh -c 'Install-Module powershell-yaml -Scope AllUsers -MinimumVersion 0.4.12 -MaximumVersion 0.4.12 -Force -ErrorAction Stop -Verbose'; \
    pwsh -c 'Install-Module posh-SSH -Scope AllUsers -MinimumVersion 3.2.7 -MaximumVersion 3.2.7 -Force -ErrorAction Stop -Verbose'; \
    pwsh -c 'Get-InstalledModule';


"@
        }

        'sops' {

            $SOPS_VERSION = "3.13.3"
            Generate-DownloadBinary @{
                binary = 'sops'
                version = $SOPS_VERSION
                checksumsUrl = "https://github.com/getsops/sops/releases/download/v$SOPS_VERSION/sops-v$SOPS_VERSION.checksums.txt"
                platformFallback = 'linux/amd64'
                destination = '/usr/local/bin/sops'
                testCommand = 'sops --version --disable-version-check'
            }

            @"
# Install gnupg for sops
RUN apk add --no-cache gnupg


"@
        }

        'ssh' {
            @'
RUN apk add --no-cache openssh-client


'@
        }

        'yq' {
            @'
RUN apk add --no-cache yq-go


'@
        }

        default {
            throw "No such component: $component"
        }
    }
}

@"
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "kubectl" ]

"@
