FROM ubuntu:16.04

WORKDIR /tmp

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get -y --no-install-recommends install ca-certificates curl xz-utils \
    && curl -L -O --referer https://support.amd.com https://www2.ati.com/drivers/linux/ubuntu/amdgpu-pro-18.10-572953.tar.xz \
    && tar -Jxvf amdgpu-pro-18.10-572953.tar.xz \
    && rm amdgpu-pro-18.10-572953.tar.xz \
    && chmod +x ./amdgpu-pro-18.10-572953/amdgpu-pro-install \
    && ./amdgpu-pro-18.10-572953/amdgpu-pro-install -y --opencl=pal \
    && rm -r amdgpu-pro-18.10-572953 \
    && apt-get -y remove ca-certificates curl xz-utils \
    && apt-get -y autoremove \
    && apt-get clean autoclean \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

COPY donate-level.patch /tmp

# Default git repository
ENV GIT_REPOSITORY https://github.com/fireice-uk/xmr-stak.git
ENV XMRSTAK_CMAKE_FLAGS -DXMR-STAK_COMPILE=generic -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=ON -DOpenCL_INCLUDE_DIR=/usr/include/CL -DOpenCL_LIBRARY=/opt/amdgpu-pro/lib/x86_64-linux-gnu/libamdocl64.so -DHWLOC_ENABLE=OFF

# Install packages
RUN apt-get update \
    && set -x \
    && apt-get -y --no-install-recommends install ca-certificates curl build-essential cmake libuv1-dev ocl-icd-opencl-dev opencl-headers libhwloc-dev libmicrohttpd-dev libssl-dev git \
    && git clone $GIT_REPOSITORY \
    && git -C xmr-stak apply ../donate-level.patch \
    && cd xmr-stak \
    && cmake ${XMRSTAK_CMAKE_FLAGS} . \
    && make \
    && cd - \
    && mv xmr-stak/bin/* /usr/local/bin/ \
    && rm -rf xmr-stak \
    && apt-get purge -y -qq build-essential cmake libuv1-dev ocl-icd-opencl-dev libhwloc-dev libmicrohttpd-dev libssl-dev \
    && apt-get clean -qq

ENTRYPOINT ["/usr/local/bin/xmr-stak"]
CMD ["-h"]

