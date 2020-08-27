#===========================#
# multi-stage: build
#===========================#

FROM ubuntu:20.04 AS build

# ParaView 5.8.1 (https://www.paraview.org/download/)
RUN apt update && \
    apt install -y --no-install-recommends \
        wget && \
    mkdir -p /var/tmp && \
    wget -q -nc --no-check-certificate \
         -O /var/tmp/ParaView-5.8.1-MPI-Linux-Python3.7-64bit.tar.gz \
         "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.8&type=binary&os=Linux&downloadFile=ParaView-5.8.1-MPI-Linux-Python3.7-64bit.tar.gz" && \
    tar -x -f /var/tmp/ParaView-5.8.1-MPI-Linux-Python3.7-64bit.tar.gz -C /var/tmp -z && \
    mkdir -p /opt/paraview/ && mv /var/tmp/ParaView-5.8.1-MPI-Linux-Python3.7-64bit/* /opt/paraview/ && \
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
        qt5-default \
        qttools5-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/paraview /opt/paraview
ENV PATH=/opt/paraview/bin:$PATH \
    LD_LIBRARY_PATH=/opt/paraview/lib:$LD_LIBRARY_PATH \
    LD_LIBRARY_PATH=/opt/paraview/lib/mesa/:$LD_LIBRARY_PATH