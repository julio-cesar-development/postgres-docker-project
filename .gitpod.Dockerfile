# hadolint ignore=DL3006
FROM gitpod/workspace-full
LABEL maintainer="julio@blackdevs.com.br"

# Install Docker
# hadolint ignore=DL3004
RUN sudo apt-get -q -y update && \
    sudo apt-get install --no-install-recommends -q -y docker.io && \
    sudo rm -rf /var/lib/apt/lists/*

# Install docker-compose
# hadolint ignore=DL3004
RUN sudo curl --silent -L "https://github.com/docker/compose/releases/download/1.17.1/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose && \
    sudo chmod +x docker-compose && sudo mv docker-compose /usr/local/bin

# hadolint ignore=DL3004
RUN sudo usermod -aG docker gitpod

USER gitpod

# docker image build --tag gitpod-pg-project:latest -f .gitpod.Dockerfile .
# docker container run --rm --name gitpod-pg-project gitpod-pg-project:latest
