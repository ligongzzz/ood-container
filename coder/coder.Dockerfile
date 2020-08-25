FROM centos:8

# coder (https://github.com/cdr/code-server)
RUN yum install -y \
        curl \
        python3 \
        python3-pip && \
    curl -fsSL https://code-server.dev/install.sh | sh && \
    rm -rf /var/cache/yum/*
