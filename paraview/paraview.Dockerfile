#===========================#
# multi-stage: build
#===========================#

FROM centos:8 AS build

# ParaView 5.8.1 (https://www.paraview.org/download/)
RUN yum install -y \
        wget && \
    mkdir -p /var/tmp && \
    wget -q -nc --no-check-certificate \
         -O /var/tmp/ParaView-5.8.1-MPI-Linux-Python3.7-64bit.tar.gz \
         "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.8&type=binary&os=Linux&downloadFile=ParaView-5.8.1-MPI-Linux-Python3.7-64bit.tar.gz" && \
    tar -x -f /var/tmp/ParaView-5.8.1-MPI-Linux-Python3.7-64bit.tar.gz -C /var/tmp -z && \
    mkdir -p /opt/paraview/ && mv /var/tmp/ParaView-5.8.1-MPI-Linux-Python3.7-64bit/* /opt/paraview/ && \
    rm -rf /var/cache/yum/*


#===========================#
# multi-stage: install
#===========================#

FROM centos:8

COPY --from=build /opt/paraview /opt/paraview
ENV PATH=/opt/paraview/bin:$PATH \
    LD_LIBRARY_PATH=/opt/paraview/lib:$LD_LIBRARY_PATH \
    LD_LIBRARY_PATH=/opt/paraview/lib/mesa/:$LD_LIBRARY_PATH