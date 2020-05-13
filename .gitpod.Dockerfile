FROM juliocesarmidia/ubuntu_base:v18.04
LABEL maintainer="julio@blackdevs.com.br"

RUN sudo apt-get -q -y update && \
    sudo apt-get install -q -y docker.io && \
    sudo rm -rf /var/lib/apt/lists/*

RUN sudo usermod -aG docker $USER

RUN sudo curl -L "https://github.com/docker/compose/releases/download/1.17.1/docker-compose-$(uname -s)-$(uname -m)" > docker-compose && \
    sudo chmod +x docker-compose && sudo mv docker-compose /usr/local/bin
