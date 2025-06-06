FROM ubuntu:24.04@sha256:6015f66923d7afbc53558d7ccffd325d43b4e249f41a6e93eef074c9505d2233
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# NOTE 1: As of 2025/01/07, the only way to install Git Credential Manager on arm64 Linux is as a .NET Tool.
# Once arm64 deb packages are released, this install method should be changed.

# NOTE 2: As of 2025/01/08, the only supported way to get pipx 1.5.0+ (which has the needed --global) option
# on Ubuntu 24.04 is to install via zipapp

# renovate: datasource=repology depName=ubuntu_24_04/ca-certificates versioning=loose
ENV RENOVATE_CA_CERTIFICATES_VERSION=20240203
# renovate: datasource=pypi depName=copier
ENV RENOVATE_COPIER_VERSION=9.7.1
# renovate: datasource=repology depName=ubuntu_24_04/curl versioning=loose
ENV RENOVATE_CURL_VERSION=8.5.0-2ubuntu10.6
# renovate-disabled: datasource=repology depName=ubuntu_24_04/dotnet8 versioning=loose
# Renovate is disabled here because the version number here: https://packages.ubuntu.com/source/noble-updates/dotnet8
# that Repology is aware of is disjoint from the package version number here:
# https://packages.ubuntu.com/noble-updates/dotnet-sdk-8.0
ENV RENOVATE_DOTNET_VERSION=8.0.111-0ubuntu1~24.04.1
# renovate: datasource=repology depName=ubuntu_24_04/git versioning=loose
ENV RENOVATE_GIT_VERSION=1:2.43.0-1ubuntu7.2
# renovate: datasource=nuget depName=git-credential-manager
ENV RENOVATE_GCM_VERSION=2.6.1
# renovate: datasource=github-releases depName=tianon/gosu
ENV RENOVATE_GOSU_VERSION=1.17
# renovate: datasource=pypi depName=invoke
ENV RENOVATE_INVOKE_VERSION=2.2.0
# renovate: datasource=github-releases depName=pypa/pipx
ENV RENOVATE_PIPX_VERSION=1.7.1
# renovate: datasource=repology depName=ubuntu_24_04/python3.12 versioning=loose
ENV RENOVATE_PYTHON312_VERSION=3.12.3-1ubuntu0.5

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    ca-certificates="${RENOVATE_CA_CERTIFICATES_VERSION}" \
    curl="${RENOVATE_CURL_VERSION}" \
    dotnet-sdk-8.0="${RENOVATE_DOTNET_VERSION}" \
    git="${RENOVATE_GIT_VERSION}" \
    python-is-python3=3.11.4-1 \
    python3.12="${RENOVATE_PYTHON312_VERSION}" \
    python3.12-venv="${RENOVATE_PYTHON312_VERSION}" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN dotnet tool install --tool-path /usr/local/bin git-credential-manager --version ${RENOVATE_GCM_VERSION}

WORKDIR /srv/dockercontainer
COPY requirements.txt ./
RUN curl -fsSL -O --output-dir /usr/local/bin https://github.com/pypa/pipx/releases/download/${RENOVATE_PIPX_VERSION}/pipx.pyz \
    && echo 'alias pipx="python /usr/local/bin/pipx.pyz"' >> ~/.bash_aliases \
    && python /usr/local/bin/pipx.pyz install --global --pip-args="--no-cache-dir" copier==${RENOVATE_COPIER_VERSION} \
    && sed -e 's/#.*//' requirements.txt | xargs python /usr/local/bin/pipx.pyz inject --global --pip-args="--no-cache-dir" copier \
    && python /usr/local/bin/pipx.pyz inject --global --pip-args="--no-cache-dir" --include-apps copier invoke==${RENOVATE_INVOKE_VERSION}

RUN DPKG_ARCH="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
	&& curl -fsSL -o gosu --output-dir /usr/local/bin "https://github.com/tianon/gosu/releases/download/$RENOVATE_GOSU_VERSION/gosu-$DPKG_ARCH" \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu --version \
	&& gosu nobody true

COPY entrypoint.sh ./

ENTRYPOINT ["/srv/dockercontainer/entrypoint.sh"]
CMD ["bash", "-c"]
