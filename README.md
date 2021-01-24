# Docker: Ubuntu with GCC and build2

Dockerfile to generate Ubuntu-based Dockerimage with GCC and build2 installed.

## Build

The Dockerfile provides build arguments to change the version numbers.
For building, set them on the command line like in the following example.

    docker build --build-arg UBUNTU_VERSION=20.10 --build-arg GCC_VERSION=10 --build-arg BUILD2_VERSION=0.13.0 . -t ubuntu-gcc-build2:20.10-10-0.13

## Platforms
- amd64
- arm64

## Image

Current images can be found on [Docker Hub](https://hub.docker.com/r/lyrahgames/ubuntu-gcc-build2).

