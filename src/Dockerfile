FROM ubuntu:24.04

# renovate: datasource=repology depName=ubuntu_24_04/nano versioning=loose
ENV NANO_VERSION=7.2-2ubuntu0.1

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    nano="${NANO_VERSION}" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["nano", "--version"]