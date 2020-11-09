FROM debian:buster

# R 3.6.3
ARG R_VERSION
ARG BUILD_DATE
ARG CRAN
ENV BUILD_DATE ${BUILD_DATE:-2020-04-24}
ENV R_VERSION=${R_VERSION:-3.6.3} \
    CRAN=${CRAN:-https://cran.rstudio.com} \ 
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TERM=xterm

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash-completion \
        ca-certificates \
        file \
        fonts-texgyre \
        g++ \
        gfortran \
        gsfonts \
        libblas-dev \
        libbz2-1.0 \
        libcurl4 \
        libicu63 \
        libjpeg62-turbo \
        libopenblas-dev \
        libpangocairo-1.0-0 \
        libpcre3 \
        libpng16-16 \
        libreadline7 \
        libtiff5 \
        liblzma5 \
        locales \
        make \
        unzip \
        zip \
        zlib1g-dev \
        libtiff5-dev \
        libreadline-dev \
        libbz2-dev \
        libcairo2-dev \
        libcurl4-openssl-dev \
        libpango1.0-dev \
        libjpeg-dev \
        libicu-dev \
        libpcre3-dev \
        libpng-dev \
        curl \
        perl \
        liblzma-dev && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.utf8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8 && \
    BUILDDEPS="default-jdk \
        libx11-dev \
        libxt-dev \
        tcl8.6-dev \
        tk8.6-dev \
        texinfo \
        texlive-extra-utils \
        texlive-fonts-recommended \
        texlive-fonts-extra \
        texlive-latex-recommended \
        x11proto-core-dev \
        xauth \
        xfonts-base \
        xvfb" && \
    apt-get install -y --no-install-recommends $BUILDDEPS && \
    mkdir -p /var/tmp/ && cd /var/tmp/ && \
    ## Download source code
    curl -O https://cran.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz && \
    ## Extract source code
    tar -xf R-${R_VERSION}.tar.gz && \
    cd R-${R_VERSION} && \
    ## Set compiler flags
    R_PAPERSIZE=letter \
    R_BATCHSAVE="--no-save --no-restore" \
    R_BROWSER=xdg-open \
    PAGER=/usr/bin/pager \
    PERL=/usr/bin/perl \
    R_UNZIPCMD=/usr/bin/unzip \
    R_ZIPCMD=/usr/bin/zip \
    R_PRINTCMD=/usr/bin/lpr \
    LIBnn=lib \
    AWK=/usr/bin/awk \
    CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
    CXXFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
    ## Configure options
    ./configure --enable-R-shlib \
                --enable-memory-profiling \
                --with-readline \
                --with-blas \
                --with-tcltk \
                --disable-nls \
                --with-recommended-packages && \
    ## Build and install
    make && make install && \
    ## Add a library directory (for user-installed packages)
    mkdir -p /usr/local/lib/R/site-library && \
    sed -i '/^R_LIBS_USER=.*$/d' /usr/local/lib/R/etc/Renviron && \
    echo "R_LIBS_USER=\${R_LIBS_USER-'~/R/x86_64-redhat-linux-gnu-library/3.6.3'}" >> /usr/local/lib/R/etc/Renviron && \
    ## Set configured CRAN mirror
    if [ -z "$BUILD_DATE" ]; then MRAN=$CRAN; \
    else MRAN=https://mran.microsoft.com/snapshot/${BUILD_DATE}; fi && \
    echo MRAN=$MRAN >> /etc/environment && \
    echo "options(repos = c(CRAN='$MRAN'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site && \
    ## Clean up from R source install
    rm -rf /var/tmp/R* && \
    apt-get remove --purge -y ${BUILDDEPS} && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

# rstudio 1.2.5042
ARG RSTUDIO_VERSION
ARG PANDOC_TEMPLATES_VERSION
ENV RSTUDIO_VERSION=${RSTUDIO_VERSION:-1.2.5042}
ENV PANDOC_TEMPLATES_VERSION=${PANDOC_TEMPLATES_VERSION:-2.9}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        file \
        git \
        libapparmor1 \
        libclang-dev \
        libcurl4-openssl-dev \
        libedit2 \
        libssl-dev \
        lsb-release \
        multiarch-support \
        psmisc \
        procps \
        python-setuptools \
        sudo \
        pkg-config \
        libxml2-dev \
        jags \
        wget && \
    if [ -z ${RSTUDIO_VERSION} ]; \
    then RSTUDIO_URL="https://www.rstudio.org/download/latest/stable/server/bionic/rstudio-server-latest-amd64.deb"; \
    else RSTUDIO_URL="http://download2.rstudio.org/server/bionic/amd64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb"; fi && \
    cd /var/tmp/ && wget -q $RSTUDIO_URL && \
    dpkg -i rstudio-server-*-amd64.deb && \
    rm rstudio-server-*-amd64.deb && \
    ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin && \
    ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin && \
    git clone --recursive --branch ${PANDOC_TEMPLATES_VERSION} https://github.com/jgm/pandoc-templates && \
    mkdir -p /opt/pandoc/templates && \
    cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/ && \
    mkdir -p /etc/R && \
    echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron && \
    echo "http_proxy=http://proxy.pi.sjtu.edu.cn:3004/" >> /usr/local/lib/R/etc/Renviron && \
    echo "https_proxy=http://proxy.pi.sjtu.edu.cn:3004/" >> /usr/local/lib/R/etc/Renviron

ENV PATH=/usr/lib/rstudio-server/bin:$PATH
