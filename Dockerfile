# syntax=docker/dockerfile:1

ARG BASE_IMAGE="ubuntu:22.04"

FROM $BASE_IMAGE

LABEL org.opencontainers.image.source=https://github.com/dzfranklin/metview-docker

ARG METVIEWBUNDLE
ARG PARALLELISM=1

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install --yes --no-install-suggests --no-install-recommends \
        bison \
        build-essential \
	    cmake \
        curl \
        file \
        flex \
        gfortran \
        git \
        libbz2-dev \
        libcairo2-dev \
        libeigen3-dev \
        libgdbm-dev \
        liblapack-dev \
        liblz4-dev \
        libncurses-dev \
        libnetcdf-dev \
        libpango1.0-dev \
        libproj-dev \
        libsnappy-dev \
        libtirpc-dev \
        libtirpc3 \
        make \
        parallel \
        python3-full \
        python3-pip \
        python-is-python3 \
        rpcsvc-proto \
	&& rm -rf /var/lib/apt/lists/*

COPY ${METVIEWBUNDLE}.tar.gz /build/
RUN set -x \
    && cd /build \
    && tar -xzf ${METVIEWBUNDLE}.tar.gz \
    && rm -rf ${METVIEWBUNDLE}.tar.gz \
    && mkdir -p /build/scratch \
    && cd /build/scratch \
    && export RPC_PATH="$(find / -name libtirpc.so.3 -exec dirname {} \;)" \
    && cmake \
      -DENABLE_UI=OFF \
      -DCMAKE_BUILD_TYPE=Release \
      /build/${METVIEWBUNDLE} \
    && make -j$PARALLELISM \
    && make install \
    && rm -r /build

COPY requirements.txt selfcheck.py /

RUN pip install \
    --no-cache-dir \
    --disable-pip-version-check \
    --no-python-version-warning \
    -r /requirements.txt && rm /requirements.txt

RUN python /selfcheck.py && rm /selfcheck.py

RUN mkdir -p /examples
COPY examples/* /examples/
