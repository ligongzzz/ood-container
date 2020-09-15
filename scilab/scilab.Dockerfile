FROM ubuntu:20.04

RUN apt update && \
    apt install -y --no-install-recommends \
        wget scilab libtinfo5 && \
    rm -rf /var/lib/apt/lists/*

# scilab 6.1.0
RUN mkdir -p /var/tmp && \
    wget -q -nc --no-check-certificate \
         -O /var/tmp/scilab-6.1.0.bin.linux-x86_64.tar.gz \
         "https://www.scilab.org/download/6.1.0/scilab-6.1.0.bin.linux-x86_64.tar.gz" && \
    tar -x -f /var/tmp/scilab-6.1.0.bin.linux-x86_64.tar.gz -C /var/tmp && \
    mkdir -p /opt/scilab/ && mv /var/tmp/scilab-6.1.0/* /opt/scilab/

ENV PATH=/opt/scilab/bin:$PATH