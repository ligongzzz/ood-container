#===========================#
# multi-stage: build
#===========================#

FROM centos:7 AS build

# visit 3.1.3 (https://github.com/visit-dav/visit/releases/tag/v3.1.3)
RUN yum install -y \
        wget && \
    mkdir -p /var/tmp && \
    wget -q -nc --no-check-certificate \
         -O /var/tmp/visit3_1_3.linux-x86_64-rhel7.tar.gz \
         https://github.com/visit-dav/visit/releases/download/v3.1.3/visit3_1_3.linux-x86_64-rhel7-wmesa.tar.gz && \
    tar xf /var/tmp/visit3_1_3.linux-x86_64-rhel7.tar.gz && \
    mv visit3_1_3.linux-x86_64 /opt/


#===========================#
# multi-stage: install
#===========================#

FROM centos:7

RUN yum install -y \
        libfabric \
        mesa-libGL-devel \
        mesa-libGLU-devel \
        mesa-libGLw-devel \
        mesa-dri-drivers \
        libicu-devel \
        fontconfig-devel \
        libXi-devel \
        libXcursor-devel \
        xcb-util xcb-util-devel \
        libXrender-devel \
        harfbuzz && \
    rm -rf /var/cache/yum/*

COPY --from=build /opt/visit3_1_3.linux-x86_64 /opt/visit3_1_3.linux-x86_64
ENV PATH=/opt/visit3_1_3.linux-x86_64/bin:$PATH
