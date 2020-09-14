FROM ubuntu:20.04

# scilab 6.1.0
RUN apt update && \
    apt install -y --no-install-recommends \
        scilab && \
    rm -rf /var/lib/apt/lists/*