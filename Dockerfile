FROM ubuntu:18.04 as dxc_builder
RUN apt-get update && \
	apt-get install -y \
	software-properties-common \
	build-essential \
	git \
	cmake \
	ninja-build \
	python

ENV DXC_BRANCH=NV_ray_tracing
ENV DXC_REPO=https://github.com/sparmarNV/DirectXShaderCompiler.git
ENV DXC_COMMIT=b5af042167dca350c4022a9dd70df949b1b36c02

WORKDIR /dxc

RUN mkdir -p /dxc && \
	git clone --recurse-submodules -b ${DXC_BRANCH} ${DXC_REPO} /dxc && \
	git checkout ${DXC_COMMIT} && \
	git reset --hard

RUN mkdir -p /dxc/build && cd /dxc/build && \
	cmake ../ -GNinja -DCMAKE_BUILD_TYPE=Release $(cat ../utils/cmake-predefined-config-params) && \
	ninja

ENTRYPOINT ["/dxc/build/bin/dxc"]