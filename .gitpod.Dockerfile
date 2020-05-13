FROM juliocesarmidia/ubuntu_base:v18.04
LABEL maintainer="julio@blackdevs.com.br"

# Install Docker
RUN apt-get -q -y update && \
    apt-get install --no-install-recommends -q -y docker.io=19.03.6-0ubuntu1~18.04.1 && \
    rm -rf /var/lib/apt/lists/*

# Add gitpod user to docker group
RUN usermod -aG docker gitpod

# Install docker-compose
RUN curl --silent -L "https://github.com/docker/compose/releases/download/1.17.1/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose && \
    chmod +x docker-compose && mv docker-compose /usr/local/bin

# docker image build --tag juliocesarmidia/gitpod-pg-project:latest -f .gitpod.Dockerfile .
# docker container run --rm --name gitpod-pg-project juliocesarmidia/gitpod-pg-project:latest
