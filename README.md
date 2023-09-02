# docker-kubectl

[![github-actions](https://github.com/theohbrothers/docker-kubectl/workflows/ci-master-pr/badge.svg)](https://github.com/theohbrothers/docker-kubectl/actions)
[![github-release](https://img.shields.io/github/v/release/theohbrothers/docker-kubectl?style=flat-square)](https://github.com/theohbrothers/docker-kubectl/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/theohbrothers/docker-kubectl/latest)](https://hub.docker.com/r/theohbrothers/docker-kubectl)

Dockerized `kubectl` with useful tools.

## Tags

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
| `:v1.28.1-alpine-3.15`, `:latest` | [View](variants/v1.28.1-alpine-3.15) |
| `:v1.28.1-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.28.1-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |
| `:v1.27.5-alpine-3.15` | [View](variants/v1.27.5-alpine-3.15) |
| `:v1.27.5-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.27.5-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |
| `:v1.26.8-alpine-3.15` | [View](variants/v1.26.8-alpine-3.15) |
| `:v1.26.8-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.26.8-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |
| `:v1.25.11-alpine-3.15` | [View](variants/v1.25.11-alpine-3.15) |
| `:v1.25.11-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.25.11-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |
| `:v1.24.15-alpine-3.15` | [View](variants/v1.24.15-alpine-3.15) |
| `:v1.24.15-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.24.15-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |
| `:v1.23.17-alpine-3.15` | [View](variants/v1.23.17-alpine-3.15) |
| `:v1.23.17-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.23.17-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |
| `:v1.22.17-alpine-3.15` | [View](variants/v1.22.17-alpine-3.15) |
| `:v1.22.17-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.22.17-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |
| `:v1.21.14-alpine-3.15` | [View](variants/v1.21.14-alpine-3.15) |
| `:v1.21.14-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.21.14-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |
| `:v1.20.15-alpine-3.15` | [View](variants/v1.20.15-alpine-3.15) |
| `:v1.20.15-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.20.15-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |
| `:v1.19.16-alpine-3.15` | [View](variants/v1.19.16-alpine-3.15) |
| `:v1.19.16-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.19.16-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |
| `:v1.18.20-alpine-3.15` | [View](variants/v1.18.20-alpine-3.15) |
| `:v1.18.20-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.18.20-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |
| `:v1.17.17-alpine-3.15` | [View](variants/v1.17.17-alpine-3.15) |
| `:v1.17.17-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.17.17-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |
| `:v1.16.15-alpine-3.15` | [View](variants/v1.16.15-alpine-3.15) |
| `:v1.16.15-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.16.15-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |
| `:v1.15.12-alpine-3.15` | [View](variants/v1.15.12-alpine-3.15) |
| `:v1.15.12-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.15.12-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |
| `:v1.14.10-alpine-3.15` | [View](variants/v1.14.10-alpine-3.15) |
| `:v1.14.10-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15` | [View](variants/v1.14.10-envsubst-git-jq-kustomize-sops-ssh-alpine-3.15) |

## Development

Requires Windows `powershell` or [`pwsh`](https://github.com/PowerShell/PowerShell).

```powershell
# Install Generate-DockerImageVariants module: https://github.com/theohbrothers/Generate-DockerImageVariants
Install-Module -Name Generate-DockerImageVariants -Repository PSGallery -Scope CurrentUser -Force -Verbose

# Edit ./generate templates

# Generate the variants
Generate-DockerImageVariants .
```

### Variant versions

[versions.json](generate/definitions/versions.json) contains a list of [Semver](https://semver.org/) versions, one per line.

To list available version updates in `versions.json`:

```powershell
./Update-Versions.ps1 -DryRun
```

To update versions in `versions.json`:

```powershell
./Update-Versions.ps1
```

To update versions in `versions.json`, and open a PR for each updated version:

```powershell
./Update-Versions.ps1 -PR
```
