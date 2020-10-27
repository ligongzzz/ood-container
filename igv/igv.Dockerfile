#===========================#
# multi-stage: build
#===========================#

FROM ubuntu:20.04 AS build

# IGV 2.8.10 (https://software.broadinstitute.org/software/igv/download)
RUN apt update && \
    apt install -y --no-install-recommends \
        wget \
        unzip && \
    mkdir -p /var/tmp && \
    wget -q -nc --no-check-certificate \
         -O /var/tmp/IGV_Linux_2.8.10_WithJava.zip \
         "https://data.broadinstitute.org/igv/projects/downloads/2.8/IGV_Linux_2.8.10_WithJava.zip" && \
    unzip /var/tmp/IGV_Linux_2.8.10_WithJava.zip && \
    mv IGV_Linux_2.8.10 /opt/


#===========================#
# multi-stage: install
#===========================#

FROM ubuntu:20.04

RUN apt update && \
    DEBIAN_FRONTEND="noninteractive" \
    apt install -y --no-install-recommends \
        libxtst6 \
        firefox && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/IGV_Linux_2.8.10 /opt/IGV_Linux_2.8.10
ENV PATH=/opt/IGV_Linux_2.8.10:$PATH