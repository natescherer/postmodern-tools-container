FROM ubuntu:24.04
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# NOTE 1: As of 2025/01/07, the only way to install Git Credential Manager on arm64 Linux is as a .NET Tool.
# Once arm64 deb packages are released, this install method should be changed.

# NOTE 2: As of 2025/01/08, the only supported way to get pipx 1.5.0+ (which has the needed --global) option
# on Ubuntu 24.04 is to install via zipapp

# renovate: datasource=pypi packageName=copier
ENV RENOVATE_COPIER_VERSION=9.4.0
# renovate: datasource=repology depName=ubuntu_24_04/curl versioning=loose
ENV RENOVATE_CURL_VERSION=8.5.0-2ubuntu10.6
# renovate: datasource=repology depName=ubuntu_24_04/dotnet-sdk-8.0 versioning=loose
ENV RENOVATE_DOTNET_VERSION=8.0.104-0ubuntu1
# renovate: datasource=repology depName=ubuntu_24_04/git versioning=loose
ENV RENOVATE_GIT_VERSION=1:2.43.0-1ubuntu7.1
# renovate datasource=nuget packageName=git-credential-manager
ENV RENOVATE_GCM_VERSION=2.5.1
# renovate: datasource=github-releases depName=pipx packageName=pypa/pipx
ENV RENOVATE_PIPX_VERSION=1.7.0
# renovate: datasource=repology depName=ubuntu_24_04/python-is-python3 versioning=loose
ENV RENOVATE_PYTHON_IS_PYTHON3_VERSION=3.11.4-1
# renovate: datasource=repology depName=ubuntu_24_04/python3-all versioning=loose
ENV RENOVATE_PYTHON3_ALL_VERSION=3.12.3-0ubuntu2
# renovate: datasource=repology depName=ubuntu_24_04/python3-all versioning=loose
ENV RENOVATE_PYTHON312_VENV_VERSION=3.12.3-1ubuntu0.3

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    curl="${RENOVATE_CURL_VERSION}" \
    dotnet-sdk-8.0="${RENOVATE_DOTNET_VERSION}" \
    git="${RENOVATE_GIT_VERSION}" \
    python-is-python3="${RENOVATE_PYTHON_IS_PYTHON3_VERSION}" \
    python3-all="${RENOVATE_PYTHON3_ALL_VERSION}" \
    python3.12-venv="${RENOVATE_PYTHON312_VENV_VERSION}" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN dotnet tool install --tool-path /usr/local/bin git-credential-manager --version ${RENOVATE_GCM_VERSION} \
    && git-credential-manager configure

WORKDIR /usr/src/app
COPY requirements.txt ./
RUN curl -fsSL -O --output-dir /usr/local/bin https://github.com/pypa/pipx/releases/download/${RENOVATE_PIPX_VERSION}/pipx.pyz \
    && echo 'alias pipx="python /usr/local/bin/pipx.pyz"' >> ~/.bash_aliases \
    && python /usr/local/bin/pipx.pyz install --global --pip-args="--no-cache-dir" copier==${RENOVATE_COPIER_VERSION} \
    && sed -e 's/#.*//' requirements.txt | xargs python /usr/local/bin/pipx.pyz inject --global --pip-args="--no-cache-dir" copier