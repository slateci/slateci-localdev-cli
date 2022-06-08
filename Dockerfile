# syntax=docker/dockerfile:1
FROM rockylinux/rockylinux:8

# Docker image build arguments:
ARG slateclientversion=0.0.7

# Docker container environmental variables:
ENV HISTFILE=/work/.bash_history_docker

# Package installs/updates:
RUN dnf install -y \
    bind-utils \
    ncurses \
    openssh-clients \
    which
RUN dnf clean all

# Download and install the SLATE CLI:
RUN curl -LO https://github.com/slateci/slate-client-server/releases/download/v${slateclientversion}/slate-linux.tar.gz && \
    curl -LO https://github.com/slateci/slate-client-server/releases/download/v${slateclientversion}/slate-linux.sha256
RUN sha256sum -c slate-linux.sha256 || exit 1
RUN tar xzvf slate-linux.tar.gz && \
    mv slate /usr/bin/slate && \
    rm slate-linux.tar.gz slate-linux.sha256

# Prepare entrypoint:
COPY scripts/docker-entrypoint.sh ./
RUN chmod +x ./docker-entrypoint.sh

# Create the docker directory:
RUN mkdir /docker

# Add the SLATE API envs:
COPY secrets ./docker/secrets

# Add the scripts:
COPY ./scripts ./docker/scripts
RUN chmod +x ./docker/scripts/yml.sh

# Set SLATE home:
RUN mkdir -p -m 0700 "${HOME}/.slate"

# Change working directory:
WORKDIR /work

# Volumes
VOLUME [ "/work" ]

# Run once the container has started:
ENTRYPOINT [ "/docker-entrypoint.sh" ]