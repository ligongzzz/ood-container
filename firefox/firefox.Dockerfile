FROM ubuntu:20.04

# firefox
RUN apt update && \
    apt install -y --no-install-recommends \
        firefox \
        ttf-wqy-microhei && \
    rm -rf /var/lib/apt/lists/*
