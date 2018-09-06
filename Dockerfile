FROM ubuntu:18.04 as dxc_builder
RUN apt-get update && \
	apt-get install -y \
	software-properties-common \
	build-essential \
	git \
	cmake \
	ninja-build \
	python

ENV DXC_BRANCH=master
ENV DXC_REPO=https://github.com/google/DirectXShaderCompiler.git
ENV DXC_COMMIT=f45c5766277627d2b9c24b3e265701c961d75557

WORKDIR /dxc

RUN mkdir -p /dxc && \
	git clone --recurse-submodules -b ${DXC_BRANCH} ${DXC_REPO} /dxc && \
	git checkout ${DXC_COMMIT} && \
	git reset --hard

RUN mkdir -p /dxc/build && cd /dxc/build && \
	cmake ../ -GNinja -DCMAKE_BUILD_TYPE=Release $(cat ../utils/cmake-predefined-config-params) && \
	ninja

ENTRYPOINT ["/dxc/build/bin/dxc"]