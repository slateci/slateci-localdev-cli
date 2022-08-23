# syntax=docker/dockerfile:1
FROM docker.io/rockylinux/rockylinux:8

# Docker image build arguments:
ARG slateclientversion

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
COPY scripts/install-slate.sh ./
RUN chmod +x ./install-slate.sh
RUN ./install-slate.sh ${slateclientversion}
RUN rm ./install-slate.sh

# Set SLATE CLI Bash completions:
RUN echo 'source <(slate completion bash)' >> ${HOME}/.bashrc

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