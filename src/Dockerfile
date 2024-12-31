FROM ubuntu:24.04

# renovate: datasource=repology depName=ubuntu_24_04/nano versioning=deb
ENV NANO_VERSION=7.2

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    nano="${NANO_VERSION}" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["nano --version"]