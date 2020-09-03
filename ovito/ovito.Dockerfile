#===========================#
# multi-stage: build
#===========================#

FROM ubuntu:20.04 AS build

# ovito 3.2.1 (https://www.ovito.org/linux-downloads/)
RUN apt update && \
    apt install -y --no-install-recommends \
        wget \
        xz-utils && \
    mkdir -p /var/tmp && \
    wget -q -nc --no-check-certificate \
         -O /var/tmp/ovito-basic-3.2.1-x86_64.tar.xz \
         "http://www.ovito.org/download/master/ovito-basic-3.2.1-x86_64.tar.xz" && \
    tar -x -f /var/tmp/ovito-basic-3.2.1-x86_64.tar.xz -C /var/tmp && \
    mkdir -p /opt/ovito/ && mv /var/tmp/ovito-basic-3.2.1-x86_64/* /opt/ovito/ && \
    rm -rf /var/lib/apt/lists/*


#===========================#
# multi-stage: install
#===========================#

FROM ubuntu:20.04

RUN apt update && \
    DEBIAN_FRONTEND="noninteractive" \
    apt install -y --no-install-recommends \
        libgomp1 \
        libqt5x11extras5 \
        libxt6 \
        libxi6 \
        libgssapi-krb5-2 \
        libdbus-1-3 \
        libglib2.0-0 \
        libglu1-mesa \
        qt5-default \
        qttools5-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/ovito /opt/ovito
ENV PATH=/opt/ovito/bin:$PATH \
    LD_LIBRARY_PATH=/opt/ovito/lib/ovito/:$LD_LIBRARY_PATH \
    LD_LIBRARY_PATH=/opt/ovito/lib/ovito/lib:$LD_LIBRARY_PATH