FROM centos:8

# coder (https://github.com/cdr/code-server)
RUN yum install -y \
        curl \
        git \
        python3 \
        python3-pip \
        gcc gcc-c++ gcc-gfortran && \
    curl -fsSL https://code-server.dev/install.sh | sh && \
    rm -rf /var/cache/yum/*
