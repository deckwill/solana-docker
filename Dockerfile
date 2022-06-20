# This docker file is based on the llvm docker file example located here:
# https://github.com/solana-labs/bpf-tools/blob/master/Dockerfile

FROM launcher.gcr.io/google/debian9:latest as builder
LABEL maintainer "Solana Maintainers"

# Import public key required for verifying signature of cmake download.
# Note, this often fails, do it first
#RUN gpg --no-tty --keyserver hkp://pgp.mit.edu --recv 0x2D2CEF1034921684

# Install build dependencies of rust.
# First, Update the apt's source list and include the sources of the packages.
RUN grep deb /etc/apt/sources.list | \
    sed 's/^deb/deb-src /g' >> /etc/apt/sources.list

# Install compiler, python and subversion.
RUN apt-get update && \
    apt-get install -y \
                    --no-install-recommends \
                    ca-certificates gnupg \
                    build-essential \
                    python \
                    wget \
                    unzip \
                    git \
                    curl \
                    gcc \
                    g++ \
                    clang \
                    ssh \
                    openssl \
                    libssl-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update && \
    apt-get install -y pkg-config

# Install a newer ninja release. It seems the older version in the debian repos
# randomly crashes when compiling llvm.
RUN wget "https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip" && \
    echo "d2fea9ff33b3ef353161ed906f260d565ca55b8ca0568fa07b1d2cab90a84a07 ninja-linux.zip" \
        | sha256sum -c  && \
    unzip ninja-linux.zip -d /usr/local/bin && \
    rm ninja-linux.zip

# Download, verify and install cmake version that can compile clang into /usr/local.
# (Version in debian8 repos is too old)
RUN mkdir /tmp/cmake-install && cd /tmp/cmake-install && \
    wget "https://cmake.org/files/v3.7/cmake-3.7.2-SHA-256.txt.asc" && \
    wget "https://cmake.org/files/v3.7/cmake-3.7.2-SHA-256.txt" && \
    #gpg --verify cmake-3.7.2-SHA-256.txt.asc cmake-3.7.2-SHA-256.txt && \
    wget "https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.tar.gz" && \
    ( grep "cmake-3.7.2-Linux-x86_64.tar.gz" cmake-3.7.2-SHA-256.txt | \
      sha256sum -c - ) && \
    tar xzf cmake-3.7.2-Linux-x86_64.tar.gz -C /usr/local --strip-components=1 && \
    cd / && \
    rm -rf /tmp/cmake-install

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo --version

FROM solanalabs/solana:v1.10.26
# install python

RUN apt update && \
    apt install -y python3 python3-pip &&\
    pip3 install poetry

ENTRYPOINT bash
# CMD ["bash"]