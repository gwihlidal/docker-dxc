# Ideally using Alpine Linux for minimal footprint
# Blocked by:
# https://github.com/google/DirectXShaderCompiler/issues/253

#FROM alpine:3.7 as dxc_builder
#RUN apk add --no-cache build-base git cmake ninja python

FROM ubuntu:18.04 as dxc_builder
RUN apt-get update && \
	apt-get install -y \
	software-properties-common \
	build-essential \
	git \
	cmake \
	ninja-build \
	python

ENV DXC_BRANCH=linux
ENV DXC_COMMIT=4002531aaf84027afbe8714733288678e1a95480

WORKDIR /dxc

RUN mkdir -p /dxc && \
    git clone --recurse-submodules -b ${DXC_BRANCH} https://github.com/google/DirectXShaderCompiler.git /dxc && \
    git checkout ${DXC_COMMIT} && \
    git reset --hard

RUN mkdir -p /dxc/build && cd /dxc/build && \
    cmake ../ -GNinja -DCMAKE_BUILD_TYPE=Release $(cat ../utils/cmake-predefined-config-params) && \
    ninja

ENTRYPOINT ["/dxc/build/bin/dxc"]