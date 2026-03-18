FROM debian:bookworm

WORKDIR /sbbs

# 1. Install required packages
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    libncurses5-dev \
    libnspr4-dev \
    libsdl2-dev \
    pkg-config \
    python3 \
    zip \
    unzip \
    autoconf2.13 \
    libarchive-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Clone the source repository
RUN git clone --depth 1 https://gitlab.synchro.net/main/sbbs.git src

# 3. Build the project (Execute from the sbbs3 directory as recommended)
WORKDIR /sbbs/src/src/sbbs3
RUN make RELEASE=1

# 4. Set environment variables
ENV SBBSCTRL=/sbbs/ctrl
ENV LD_LIBRARY_PATH=/sbbs/src/3rdp/gcc.linux.x64.release/mozjs/lib
ENV PATH="/sbbs/src/src/sbbs3/scfg/gcc.linux.x64.exe.release:/sbbs/src/src/sbbs3/gcc.linux.x64.exe.release:${PATH}"

# 5. Initialize data directories and files
RUN mkdir -p /sbbs/ctrl /sbbs/data /sbbs/xtrn /sbbs/text /sbbs/web /sbbs/exec /sbbs/node1
# Copy default configuration and data from source directories
RUN cp -r /sbbs/src/ctrl/. /sbbs/ctrl/ && \
    cp -r /sbbs/src/text/. /sbbs/text/ && \
    cp -r /sbbs/src/web/. /sbbs/web/ && \
    cp -r /sbbs/src/exec/. /sbbs/exec/ && \
    cp -r /sbbs/src/node1/. /sbbs/node1/ && \
    ln -s /sbbs/web /sbbs/webv4

WORKDIR /sbbs
CMD ["sbbs"]

EXPOSE 23 80 443
