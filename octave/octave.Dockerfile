FROM mtmiller/octave

# octave
RUN apt update && \
    apt install -y --no-install-recommends \
        libqt5sql5-sqlite && \
    rm -rf /var/lib/apt/lists/*
