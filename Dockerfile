ARG UBUNTU_VERSION=latest

# Base Stage
FROM ubuntu:${UBUNTU_VERSION} AS base
ARG GCC_VERSION=9
RUN \
  echo "GCC_VERSION=$GCC_VERSION" && \
  apt-get update && \
  apt-get install -y \
    # build2 Toolchain Dependencies
    gcc-$GCC_VERSION \
    g++-$GCC_VERSION \
    curl \
    wget \
    openssl \
    # Git is needed for CI environments.
    git \
  && \
  rm -rf /var/lib/apt/lists/* && \
  # Set the default GCC version used
  # when calling 'gcc', 'cc', 'g++', or 'c++'.
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-$GCC_VERSION 10 && \
  update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 20 && \
  update-alternatives --set cc /usr/bin/gcc && \
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-$GCC_VERSION 10 && \
  update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 20 && \
  update-alternatives --set c++ /usr/bin/g++


# build2 Build Stage
FROM base AS builder
ARG BUILD2_VERSION=0.13.0
RUN \
  echo "BUILD2_VERSION=$BUILD2_VERSION" && \
  apt-get update && \
  apt-get install -y \
    # To bootstrap the build2 toolchain more efficiently,
    # Make has to be installed.
    make \
  && \
  rm -rf /var/lib/apt/lists/* && \
  curl -sSfO https://download.build2.org/$BUILD2_VERSION/build2-install-$BUILD2_VERSION.sh && \
  sh build2-install-$BUILD2_VERSION.sh --yes --sudo false --no-check --trust yes /opt/build2

# Deployment Stage
FROM base AS deployer
# To keep the links for the build2 shared libraries,
# we have to copy the build2 toolchain to same destination.
COPY --from=builder /opt/build2 /opt/build2
ENV PATH "/opt/build2/bin:$PATH"
LABEL maintainer="lyrahgames@mailbox.org"
