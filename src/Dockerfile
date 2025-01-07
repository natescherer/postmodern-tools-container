FROM ubuntu:24.04
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# NOTE: As of 2025/01/07, the only way to install Git Credential Manager on arm64 Linux is as a .NET Tool.
# Once arm64 deb packages are released, this install method should be changed.

# renovate: datasource=pypi packageName=copier
ENV COPIER_VERSION=9.4.0
# renovate: datasource=repology depName=ubuntu_24_04/dotnet-sdk-8.0 versioning=loose
ENV DOTNET_VERSION=8.0.104-0ubuntu1
# renovate: datasource=repology depName=ubuntu_24_04/git versioning=loose
ENV GIT_VERSION=1:2.43.0-1ubuntu7.1
# renovate datasource=github-releases depName=git-credential-manager packageName=git-credential-manager/releases
ENV GCM_VERSION=2.5.1
# renovate: datasource=repology depName=ubuntu_24_04/pipx versioning=loose
ENV PIPX_VERSION=1.4.3-1
# renovate: datasource=repology depName=ubuntu_24_04/python3-all versioning=loose
ENV PYTHON_VERSION=3.12.3-0ubuntu2

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    dotnet-sdk-8.0="${DOTNET_VERSION}" \
    git="${GIT_VERSION}" \
    pipx="${PIPX_VERSION}" \
    python3-all="${PYTHON_VERSION}" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# trunk-ignore(hadolint/SC2016)
RUN dotnet tool install --global git-credential-manager --version ${GCM_VERSION} \
    && echo 'export PATH="$PATH:'"$HOME"'/.dotnet/tools"' >> ~/.bashrc \
    && ~/.dotnet/tools/git-credential-manager configure \
    && git config --global credential.credentialStore cache

WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pipx ensurepath \
    && pipx install --pip-args="--no-cache-dir" copier==${COPIER_VERSION} \
    && sed -e 's/#.*//' requirements.txt | xargs pipx inject --pip-args="--no-cache-dir" copier