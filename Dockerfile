FROM alpine:3.7 as dxc_builder

RUN apk add --no-cache build-base git cmake ninja python

ENV DXC_VERSION=linux

RUN mkdir -p /dxc && \
    git clone --recurse-submodules -b ${DXC_VERSION} https://github.com/google/DirectXShaderCompiler.git /dxc

# https://github.com/google/DirectXShaderCompiler/issues/253
RUN mkdir -p /dxc/build && cd /dxc/build && \
    cmake ../ -GNinja -DCMAKE_BUILD_TYPE=Release $(cat ../utils/cmake-predefined-config-params) && \
    ninja

ENTRYPOINT ["/dxc/build/bin/dxc"]